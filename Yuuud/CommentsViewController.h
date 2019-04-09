//
//  CommentsViewController.h
//  Yuuud
//
//  Created by mac-00015 on 2/24/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HPGrowingTextView.h"
#import "MIAudioWaveform.h"

@interface CommentsViewController : SuperViewController<HPGrowingTextViewDelegate,MIAudioWaveformDelegate>
{
    IBOutlet UITableView *tblComments;
    IBOutlet HPGrowingTextView *txtComment;
    IBOutlet NSLayoutConstraint *cnTxtCommentHeight;
    IBOutlet UIButton *btnSend,*btnLike;
    IBOutlet UIView *vwHorizontalLine, *vwTop;
    IBOutlet UIView *viewWave;
    IBOutlet UIView *viewWaveContainer;
    
    IBOutlet UILabel *lbYuudName;
    IBOutlet UILabel *lbUserName;
    IBOutlet UILabel *lbCommentCount;
    IBOutlet UILabel *lbLikeCount;
    IBOutlet UILabel *lbLocation;
    IBOutlet UILabel *lbNoComments;
    IBOutlet UIButton *btnPlay;
    IBOutlet UIActivityIndicatorView *activityInd;
}

@property (nonatomic, strong) UIColor *clrBackground;
@property (nonatomic, strong) UIImage *imgWave;
@property (nonatomic, strong) NSDictionary *dicFromList;
@property (nonatomic, strong) NSMutableDictionary *dictData;
@property (nonatomic, strong) NSDictionary *dicRemote;
@property (nonatomic, assign) BOOL shouldShowColor, isFromNotification;

@end
