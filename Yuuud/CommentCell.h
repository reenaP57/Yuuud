//
//  CommentCell.h
//  Yuuud
//
//  Created by mac-00015 on 2/27/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UIButton *btnLike, *btnLikeAction;
@property(weak,nonatomic) IBOutlet UILabel *lbMainTitle;
@property(weak,nonatomic) IBOutlet UILabel *lbMainUsername;
@property(weak,nonatomic) IBOutlet UILabel *lbTime;
@property(weak,nonatomic) IBOutlet UILabel *lbLikeCount;


@end
