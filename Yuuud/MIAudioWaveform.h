//
//  MIAudioWaveform.m
//  DemoLayout
//
//  Created by mac-00012 on 15/03/17.
//  Copyright © 2017 Krishna-00012. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^donePlaying)(void);

@class AudioStreamer;
@class MIAudioWaveform;

@protocol MIAudioWaveformDelegate <NSObject>
- (void)DidFinishAudio:(MIAudioWaveform *)waveFormView Finish:(BOOL)isFinish;
- (void)DidAudioBuffering:(AVQueuePlayer *)player Continue:(BOOL)isContinue;

@end //end protocol


typedef enum
{
    PreviewPlayerStateNone,
    PreviewPlayerStatePlaying,
    PreviewPlayerStateBuffering,
    PreviewPlayerStatePaused,
    PreviewPlayerStateStopped,
    PreviewPlayerPauseReasonNotPause,
    PreviewPlayerStateDisposed,
} PreviewPlayerState;


@interface MIAudioWaveform : UIView<AVAudioPlayerDelegate>
{
    IBOutlet UIView *normalView;
    IBOutlet UIImageView *normalImageView;
    
    IBOutlet UIView *progressView;
    IBOutlet UIImageView *progressImageView;
    
    IBOutlet NSLayoutConstraint *cnProgressWidth;
    
    NSTimer *progressUpdateTimer;
}

@property (nonatomic, weak) UIImage *normalImage;
@property (nonatomic, weak) UIImage *progressImage;
@property (nonatomic, strong) UIImage *tempImage;

@property (nonatomic, strong) UIColor *progressColor;;

@property (nonatomic, copy) donePlaying configureDonePlaying;

@property (nonatomic, strong) AudioStreamer *streamer;


@property (assign, readwrite, nonatomic) CGFloat value;
@property (assign, readwrite, nonatomic) CGFloat minimumValue;
@property (assign, readwrite, nonatomic) CGFloat maximumValue;

- (instancetype)initWithSize:(CGSize)size andNormalImage:(UIImage *)normalImage andProgressImage:(UIImage *)progressImage Data:(NSDictionary *)dicData;

- (void)StartProgressToFilldata:(NSString *)strUrl;
- (UIImage *)recolorizeImage:(UIImage *)image withColor:(UIColor *)color;
- (void)createStreamer:(NSString *)strUrl;
- (void)destroyStreamer;

@property (nonatomic, weak) id <MIAudioWaveformDelegate> delegate;

@end
