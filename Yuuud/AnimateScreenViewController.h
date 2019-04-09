//
//  AnimateScreenViewController.h
//  MY_Audio_Demo
//
//  Created by mac-00015 on 2/21/17.
//  Copyright © 2017 mac-00012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTransitionAnimator.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MIAudioWaveform.h"
#import "FBShimmering.h"
#import "FBShimmeringView.h"


@interface AnimateScreenViewController : SuperViewController<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
{
    IBOutlet UIView *vwAnimate, *vwBottom;
    
    IBOutlet GADBannerView *vwAdBanner;
    
    IBOutlet NSLayoutConstraint *cnVwAnimateBottomSpace, *cnBtnRecordBottomSpace;
    
    IBOutlet UIButton *btnRecord;
    
    IBOutlet UITableView *tblRecordings, *tblShimmer;
    
    IBOutlet UILabel *lbNoYuuud;
    
    IBOutlet FBShimmeringView *shimmeringView;
}

@property (nonatomic, strong) ARTransitionAnimator *transitionAnimator;

@end
