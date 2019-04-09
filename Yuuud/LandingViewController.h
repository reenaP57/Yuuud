//
//  LandingViewController.h
//  Yuuud
//
//  Created by mac-00015 on 2/23/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingViewController : SuperViewController
{
    IBOutlet UITextField *txtUserName;
    IBOutlet UIButton *btnNext;
//    IBOutlet UIButton *btnCheckbox;
//    IBOutlet UIButton *btnTerms;
//    IBOutlet UIImageView *imgCheckbox;
//    IBOutlet UIView *vwHorizontalLine;
//    IBOutlet UILabel *lbTerms;
}

@property (nonatomic, assign) BOOL isFromEdit;

@end
