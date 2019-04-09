//
//  SaveAudioView.h
//  Yuuud
//
//  Created by mac-00015 on 2/24/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveAudioView : UIView

@property (nonatomic, weak) IBOutlet UITextField *txtName;
@property (nonatomic, weak) IBOutlet UIButton *btnSave, *btnHide;
@property (nonatomic, weak) IBOutlet UIView *vwInner;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *cnVwInnerHeight, *cnVwInnerWidth;


@end
