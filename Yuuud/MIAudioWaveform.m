
//
//  MIAudioWaveform.m
//  DemoLayout
//
//  Created by mac-00012 on 15/03/17.
//  Copyright © 2017 Krishna-00012. All rights reserved.
//


#import "MIAudioWaveform.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>


#define PixelScale      [UIScreen mainScreen].scale

#define WaveBarWidth    (1 * PixelScale)
#define WaveBarSpacing  (0.004 * PixelScale)

@interface MIAudioWaveform()
{
    UIColor *normalColor;
    
    float timerProgress;
    
    float previousProgressValue;
    
    int second;
    
    NSArray *arrDrawData;
    
    AVPlayerItem *playerItem;
    AVQueuePlayer *player;
    AVAudioTime *timeObserver;
    
    float audioLength;
    
    BOOL isSeeking, isFilled;
}

@end

@implementation MIAudioWaveform
@synthesize delegate; 

- (instancetype)initWithSize:(CGSize)size andNormalImage:(UIImage *)normalImage andProgressImage:(UIImage *)progressImage Data:(NSDictionary *)dicData;
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MIAudioWaveform" owner:nil options:nil] lastObject];
    
    if (self)
    {
        self.frame = CGRectMake(0, 0, size.width, size.height);
        
        normalColor = CRGB(255, 255, 255);
        
        self.progressColor = CNavigationBarColor;
        
        self.normalImage = normalImage;
        self.progressImage = progressImage;
        
        NSString *strFrequency = [dicData stringValueForJSON:@"frequency"];
        strFrequency = [strFrequency stringByReplacingOccurrencesOfString:@"[" withString:@""];
        strFrequency = [strFrequency stringByReplacingOccurrencesOfString:@"]" withString:@""];
        strFrequency = [strFrequency stringByReplacingOccurrencesOfString:@" " withString:@""];
        arrDrawData = [strFrequency componentsSeparatedByString:@","];
        
        audioLength = [dicData stringValueForJSON:@"yuuud_duration"].floatValue/1000;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (!self.normalImage && !self.progressImage)
        [self generateWaveform];
    
    [super drawRect:rect];
}


#pragma mark - 
#pragma mark - UIImage
- (UIImage *)normalImage
{
    return normalImageView.image;
}

- (void)setNormalImage:(UIImage *)normalImage
{
    normalImageView.image = normalImage;
}

- (void)setProgressImage:(UIImage *)progressImage {
    progressImageView.image = progressImage;
}

- (UIImage *)progressImage {
    return progressImageView.image;
}

- (void)generateWaveform
{
//  self.normalImage = nil;
//  [self setNeedsDisplay];
    
    //self.normalImage = nil;
    
    timerProgress = 0;
    
    CGSize size = self.frame.size;
    size.width *= PixelScale;
    size.height *= PixelScale;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetLineWidth(context, WaveBarWidth);
    
    float fltlength = Is_iPhone_6_PLUS ? (CScreenWidth/arrDrawData.count)*3 : (CScreenWidth/arrDrawData.count)*2;
    
    CGContextSetLineWidth(context, fltlength+0.8);
    CGContextSetStrokeColorWithColor(context, normalColor.CGColor);
    
    CGFloat x = (fltlength/2);
    CGFloat hSpace = (size.width + x);
    
    double dWaveHeight = 108;
    
    for (int i = 0; arrDrawData.count > i; i++)
    {
        if (x <= (hSpace - fltlength))
        {
            NSString* StrData = [NSString stringWithFormat:@"%.04f", [arrDrawData[i] floatValue]];
            
            double waveData = StrData.doubleValue;
            
            if(waveData == 0)
                waveData = 0.01;
            
            double dWaveLength = ((size.height/2) - waveData*dWaveHeight);
            
            CGContextMoveToPoint(context, x, (waveData*dWaveHeight*2) + dWaveLength);
            CGContextAddLineToPoint(context, x, dWaveLength);
            CGContextStrokePath(context);
            
            //x = x + WaveBarWidth + WaveBarSpacing;
            
            x = x + fltlength;
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *imgTemp;
    
    //    if (image.size.width < CScreenWidth*3)
    //    {
    //        CGSize size = CGSizeMake(CScreenWidth*3, image.size.height);
    //        imgTemp = [self imageWithImage:image scaledToSize:size];
    //    }
    //    else
    
    self.tempImage = imgTemp = image;
    
    self.normalImage = imgTemp;
    //self.progressImage = [self recolorizeImage:imgTemp withColor:progressColor];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 3.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)recolorizeImage:(UIImage *)image withColor:(UIColor *)color
{
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 3);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, imageRect, image.CGImage);
    [color set];
    UIRectFillUsingBlendMode(imageRect, kCGBlendModeSourceAtop);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark - Filling Pattern functions

- (void)StartProgressToFilldata:(NSString *)strUrl
{
    NSURL *trackURL = [NSURL URLWithString:strUrl];
    [self initializePlayerWithURL:trackURL];
}

- (void)initializePlayerWithURL:(NSURL *)trackURL
{
    cnProgressWidth.constant = 0;
    [self createStreamer:trackURL.absoluteString];
}


#pragma mark - Streamer Functions

- (void)createStreamer:(NSString *)strUrl
{
    if (_streamer)
        return;
    
    [self destroyStreamer];
    
    NSString *escapedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)strUrl,NULL, NULL,kCFStringEncodingUTF8));
    NSURL *url = [NSURL URLWithString:escapedValue];
    _streamer = [[AudioStreamer alloc] initWithURL:url];
    
    progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:progressUpdateTimer forMode:NSRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged:) name:ASStatusChangedNotification object:_streamer];
    
    [_streamer start];
}

- (void)destroyStreamer
{
    if (_streamer)
    {
        cnProgressWidth.constant = 0;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASStatusChangedNotification object:_streamer];

        if (progressUpdateTimer)
        {
            [progressUpdateTimer invalidate];
            progressUpdateTimer = nil;
        }
        
        [_streamer stop];
        _streamer = nil;
    }
}

- (void)updateProgress:(NSTimer *)updatedTimer
{
    if (_streamer.bitRate != 0.0)
    {
        double progress = _streamer.progress;
        double duration = _streamer.duration;
        
        if (duration > 0)
        {
            NSLog(@"value is: %f", CScreenWidth * progress / duration);
            
            NSLog(@"cnProgressWidth is : %@", cnProgressWidth);
            
            if(CScreenWidth * progress / duration >= CScreenWidth)
                return;
            
            if (CScreenWidth * progress / duration < cnProgressWidth.constant)
                return;
            
            if (isnan((CScreenWidth * progress / duration)))
                return;
            
            cnProgressWidth.constant = (CScreenWidth * progress / duration);
            
            NSLog(@"cnProgressWidth.constant : %@", cnProgressWidth);
            
//            [UIView animateWithDuration:0 animations:^{
//                [self layoutIfNeeded];
//            }];
        }
        else
        {
            //cnProgressWidth.constant = 0;
        }
    }
    else
    {
        
    }
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
    if ([_streamer isWaiting])
    {
        NSLog(@"isWaiting");
        //cnProgressWidth.constant = 0;
    }
    else if ([_streamer isPlaying])
    {
        NSLog(@"isPlaying");
    }
    else if ([_streamer isIdle])
    {
        NSLog(@"isIdle");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (_streamer)
            {
                if(cnProgressWidth.constant != 0 && cnProgressWidth.constant> CScreenWidth/2)
                    cnProgressWidth.constant = CScreenWidth;
                
                NSLog(@"outside : %f", cnProgressWidth.constant);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    cnProgressWidth.constant = 0;
                    
                    NSLog(@"inside : %f", cnProgressWidth.constant);
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASStatusChangedNotification object:_streamer];
                    
                    if (progressUpdateTimer)
                    {
                        [progressUpdateTimer invalidate];
                        progressUpdateTimer = nil;
                    }
                    
                    [_streamer stop];
                    _streamer = nil;
                    
                    if (self.configureDonePlaying)
                        self.configureDonePlaying();
                    
                });
            }
        });
    }
}

@end
