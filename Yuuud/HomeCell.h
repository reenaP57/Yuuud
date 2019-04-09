//
//  HomeCell.h
//  Yuuud
//
//  Created by mac-00015 on 2/24/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import "MIAudioWaveform.h"


//#define PixelScale      [UIScreen mainScreen].scale
//#define WaveBarWidth    (.5 * PixelScale)
//#define WaveBarSpacing  (0 * PixelScale)

typedef void(^didFinishAudio)(BOOL didFinish);

@interface HomeCell : UITableViewCell<MIAudioWaveformDelegate>
{
    IBOutlet UIActivityIndicatorView *ActivityIndicator;
}

@property (nonatomic, strong) IBOutlet UIView *viewWaveForm,*viewWaveContainer;
@property (nonatomic, strong) IBOutlet UIImageView *imgWave;
@property (nonatomic, strong) IBOutlet UIImageView *imgLike;
@property (nonatomic, strong) IBOutlet UIButton *btnComment, *btnLoadWave, *btnLikeAction;
@property (nonatomic, strong) IBOutlet TTFaveButton *btnLike;
@property (nonatomic, strong) IBOutlet UILabel *lbUsername, *lbCommentCount, *lbLocation, *lbLikeCount, *lbTitle;
@property (nonatomic, retain) IBOutlet MIAudioWaveform *waveForm;

@property (copy,nonatomic) didFinishAudio configureDidFinishAudio;


// WaveForm data
@property (nonatomic, weak) UIImage *normalImage;
@property (nonatomic, weak) UIImage *progressImage;

@property (assign, readwrite, nonatomic) CGFloat value;
@property (assign, readwrite, nonatomic) CGFloat minimumValue;
@property (assign, readwrite, nonatomic) CGFloat maximumValue;

-(void)generateWaveform:(NSDictionary *)dicWaveForm runningAudio:(MIAudioWaveform*)runningAudio;
-(void)PlayAudioFile:(NSString *)strUrl;
-(void)StopAudioFile;
-(void)ForceStopAudioFile;


@end
