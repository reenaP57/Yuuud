//
//  RecordViewController.m
//  MY_Audio_Demo
//
//  Created by mac-00015 on 2/21/17.
//  Copyright © 2017 mac-00012. All rights reserved.
//

#import "RecordViewController.h"
#import "SaveAudioView.h"
#import "AnimateScreenViewController.h"
#import "IQKeyboardManager.h"

//#define kAudioFilePath @"yuuud.mp3"
#define kAudioFilePath @"yuuud.wav"

@interface RecordViewController ()
{
    NSTimer *timer, *timerWaveform;
    int recordingTime;
    
    double currentLat,currentLong;
    NSString *currentLocation;
    
    BOOL isPresented,isLock;
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    CADisplayLink *displaylink;
    
    NSMutableArray *arrFrequencyData;
    
    SaveAudioView *objSave;
}

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameBackFromSleep) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    appDelegate.didFindLocation = NO;
    appDelegate.shouldRefresh = NO;
    [appDelegate.locationManager startUpdatingLocation];
    

    arrFrequencyData = [NSMutableArray new];
    
    [btnSave setImage:[UIImage imageNamed:@"v_BtnSave"] forState:UIControlStateNormal];
    [btnSave.imageView setContentMode:UIViewContentModeScaleToFill];
    
    [btnLock setImage:[UIImage imageNamed:@"v_btn_lock"] forState:UIControlStateNormal];
    [btnLock.imageView setContentMode:UIViewContentModeScaleToFill];
    
    btnRecord.layer.shadowColor = [[UIColor blackColor] CGColor];
    btnRecord.layer.shadowOffset = CGSizeMake(0,10.0);
    btnRecord.layer.shadowOpacity = 0.2f;
    btnRecord.layer.shadowRadius = 7.0f;
    btnRecord.layer.masksToBounds = NO;
    
    self.view.backgroundColor = CScreenBackgroundColor;
    [self.navigationItem setHidesBackButton:YES];
    [btnRecord addGestureRecognizer:appDelegate.longPress];
    btnRecord.exclusiveTouch = YES;
    
    lblRecording.hidden = YES;
    
    int currentTimestamp = [[NSDate date] timeIntervalSince1970];
    
    NSArray *pathComponents = [NSArray arrayWithObjects: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [NSString stringWithFormat:@"Yuuud%d.m4a", currentTimestamp], nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    
    [recorder prepareToRecord];
    [recorder setMeteringEnabled:YES];
    [recorder record];
    
    NSError *error;
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];

    // Waveform setup......
    displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
//  [displaylink setFrameInterval:3.6];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [waveformView setWaveColor:[UIColor whiteColor]];
    [waveformView setSecondaryWaveColor:CRGB(165,205,214)];
    [waveformView setPrimaryWaveLineWidth:20];
    [waveformView setSecondaryWaveLineWidth:15];

    recordingTime = 20;
    if (!timer)
        timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(timeRecording:) userInfo:nil repeats:YES];
    
//TODO: Start recording and dismiss the screen on stop recording
    
    appDelegate.configureStartRecording = ^(UILongPressGestureRecognizer *longPress)
    {
        appDelegate.configureStartRecording = ^(UILongPressGestureRecognizer *longPress){
            
            CGPoint point = [longPress locationInView:self.view.superview];
            
            cnBtnRecordBottomSpace.constant = CScreenHeight - point.y - 22;
            
            if((cnBtnRecordBottomSpace.constant) > 166)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    
                    cnBtnRecordBottomSpace.constant = 199;
                    btnSave.transform = CGAffineTransformMakeScale(1.4, 1.4);
                    btnRecord.transform = CGAffineTransformMakeScale(0.7, 0.7);
                    btnSave.alpha = 0.5;
                    
                }];
            }
            else if((cnBtnRecordBottomSpace.constant) < 28)
            {
                cnBtnRecordBottomSpace.constant = 7;
                isLock = YES;
                [UIView animateWithDuration:0.5 animations:^{
                    btnLock.transform = CGAffineTransformMakeScale(1.4, 1.4);
                    btnRecord.transform = CGAffineTransformMakeScale(0.7, 0.7);
                    btnLock.alpha = 0.5;
                }];
            }
            else
            {
                isLock = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    btnSave.transform = btnLock.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    btnRecord.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    btnSave.alpha = btnLock.alpha = 1.0;
                }];
            }
        };
    };
    
    appDelegate.configureDismissScreen = ^(UILongPressGestureRecognizer *longPress)
    {
        if((cnBtnRecordBottomSpace.constant) > 166  && (cnBtnRecordBottomSpace.constant) < 206)
        {
            if (recordingTime > 17)
            {
                [[PPAlerts sharedAlerts] showAlertWithType:3 withMessage:@"Audio length must be greater than 2 seconds."];
                [self popToPreviousViewController];
                return;
            }
            
            [self showSaveRecordingAlertView];
        }
            
        if(isPresented || isLock)
            return;
        
        cnBtnRecordBottomSpace.constant = 86;
        
        [self emptyRecorder];
        
        [self popToPreviousViewController];
    };
    
    [UIApplication applicationDidBecomeActive:^{
        
        NSLog(@"did become active method called.... ");
        
        if (isPresented && objSave)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                CViewSetWidth(objSave, [appDelegate getAspectWidth:306]);
                CGFloat height =  [appDelegate getAspectHeight:189];
                height = 189;
                CViewSetHeight(objSave, height);
                
                objSave.center = CScreenCenter;
                CViewSetY(objSave, 150);
                
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [arrFrequencyData removeAllObjects];
    
    appDelegate.isRecordingScreen = YES;
    
    isPresented = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController setNavigationBarHidden:YES];
        lblRecording.hidden = lblRecordingTime.hidden = waveformView.hidden = NO;
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (timerWaveform)
    {
        [timerWaveform invalidate];
        timerWaveform = nil;
    }
    
    appDelegate.isRecordingScreen = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Add Audio Api

- (void)addAudioWithName:(NSString *)audio_name
{
    
//TODO: Save audio file to the document directory
    
    NSString *strPath = [NSString stringWithFormat:@"%@/%@", [appDelegate getSoundPath], kAudioFilePath];
    NSData* data = [NSData dataWithContentsOfFile:strPath];
    
    //duration in milliseconds
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:recorder.url options:nil];
    CMTime time = asset.duration;
    double seconds = CMTimeGetSeconds(time);
    int iSeconds = (int)seconds;
    
    [[APIRequest request] addYuuudWithName:audio_name andYuuud_audio:data duration:iSeconds*1000 frequency:[NSArray arrayWithArray:arrFrequencyData] completion:^(id responseObject, NSError *error) {
    
       if (appDelegate.configureRefreshYuuuds)
            appDelegate.configureRefreshYuuuds();
        
    }];
}

#pragma mark - Timer Fuctions

- (void)timeRecording:(NSTimer *)timer1
{
    recordingTime--;
    lblRecording.hidden = NO;
    lblRecordingTime.text = [NSString stringWithFormat:@"00:%02d",recordingTime];
    if (recordingTime >= 1)
    {
        NSLog(@"00:%02d",recordingTime);
//        lblRecordingTime.text = [NSString stringWithFormat:@"00:%02d",recordingTime];
    }
    else
    {
        [self showSaveRecordingAlertView];
        timer = nil;
    }
}

- (void)waveFormUpdate:(NSTimer *)timer1
{
    if (!timer)
    {
        [timer1 invalidate];
        timer1 = nil;
        return;
    }
    
    CGFloat normalizedValue;
    normalizedValue = [self _normalizedPowerLevelFromDecibels:[recorder averagePowerForChannel:0]];
    [arrFrequencyData addObject:@(normalizedValue)];
//    NSLog(@"objects count: %lu", (unsigned long)arrFrequencyData.count);
}


#pragma mark - General Functions

- (void)showSaveRecordingAlertView
{
    [self emptyRecorder];
    
    objSave = [SaveAudioView viewFromXib];
    
    CViewSetWidth(objSave, [appDelegate getAspectWidth:306]);
    CGFloat height =  [appDelegate getAspectHeight:189];
    height = 189;
    CViewSetHeight(objSave, height);
    
    objSave.center = CScreenCenter;
    CViewSetY(objSave, 150);
    
    [objSave.txtName becomeFirstResponder];
    
    objSave.txtName.delegate = self;
    
    [objSave.btnSave touchUpInsideClicked:^{
        
        if (![objSave.txtName.text isBlankValidationPassed])
            [[PPAlerts sharedAlerts] showAlertWithType:0 withMessage:@"Please enter name" withTitle:@""];
        else
        {
            SystemSoundID soundID;
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"m4a"];
            NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
            AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
            AudioServicesPlaySystemSound(soundID);
            
            [self SaveAudioFileToLibrary];
            [self addAudioWithName:objSave.txtName.text];
            [btnHide sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }];

    isPresented = YES;
    btnHide.hidden = NO;
    [self.view addSubview:objSave];
    
    [[IQKeyboardManager sharedManager] setConfigureDoneClicked:^{
        
        [objSave.btnSave sendActionsForControlEvents:UIControlEventTouchUpInside];
        //[objSave.txtName resignFirstResponder];
    }];
    
    [btnHide touchUpInsideClicked:^{
        
        NSLog(@"Frequency data ======== > %@",arrFrequencyData);
        NSLog(@"File Path ========= > %@",CCachesDirectory);
        
        //[self SaveAudioFileToLibrary];
        btnHide.hidden = YES;
        [objSave removeFromSuperview];
        //[self.navigationController popViewControllerAnimated:YES];
        [self popToPreviousViewController];
    }];
    
    [btnRecord removeGestureRecognizer:appDelegate.longPress];
}

#pragma mark - WaveFrom Functions

- (void)updateMeters
{
    if (recordingTime <= 0)
        return;
    
    [recorder updateMeters];
    
    CGFloat normalizedValue = [self _normalizedPowerLevelFromDecibels:[recorder averagePowerForChannel:0]];
    
    if(!timerWaveform)
    {
        timerWaveform = [NSTimer scheduledTimerWithTimeInterval:0.047 target:self selector:@selector(waveFormUpdate:) userInfo:nil repeats:YES];
    }


//    switch (self.selectedInputType)
//    {
//        case SCSiriWaveformViewInputTypeRecorder: {
//            [self.recorder updateMeters];
//            normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.recorder averagePowerForChannel:0]];
//            break;
//        }
//        case SCSiriWaveformViewInputTypePlayer: {
//            [self.player updateMeters];
//            normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.player averagePowerForChannel:0]];
//            break;
//        }
//    }
    
    [waveformView updateWithLevel:normalizedValue];
}

#pragma mark - Private

- (CGFloat)_normalizedPowerLevelFromDecibels:(CGFloat)decibels
{
    if (decibels < -60.0f || decibels == 0.0f)
        return 0.0f;
    
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}


- (void)SaveAudioFileToLibrary
{
    NSData *urlData = [NSData dataWithContentsOfURL:recorder.url];
    NSString *strPath = [NSString stringWithFormat:@"%@/%@", [appDelegate getSoundPath], kAudioFilePath];
    
    NSError *error = nil;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:strPath])
        [[NSFileManager defaultManager] removeItemAtPath:strPath error:&error]; //Delete old file

    if (urlData)
    {
        if ([urlData writeToFile:strPath atomically:YES])
        {
            // yeah - file written
            NSLog(@"YES");
        }
        else
        {
            // oops - file not written
            NSLog(@"NO");
        }
    }
    else
    {
        // oops - couldn't get data
        NSLog(@"NOT");
    }
}

- (void)popToPreviousViewController
{
    [self emptyRecorder];
    
    for (UIViewController *objViewController in self.navigationController.viewControllers)
    {
        if ([objViewController isKindOfClass:[AnimateScreenViewController class]])
        {
            [self.navigationController popToViewController:objViewController animated:YES];
            break;
        }
    }
}

- (void)emptyRecorder
{
    lblRecording.hidden = YES;
    [timer invalidate];
    [recorder stop];
    [displaylink invalidate];
    [timerWaveform invalidate];
}


#pragma mark - Textfield delegate methods
#pragma mark -

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if ([textField isEqual:txt])
//    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (newLength == 51)
        {
            if (newLength > oldLength)
                return NO;
        }
        return YES;
//    }
//    return YES;
}


@end

