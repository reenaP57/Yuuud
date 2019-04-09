//
//  PopUpViewController.h
//  ChamRDV
//
//  Created by mac-0001 on 6/27/14.
//  Copyright (c) 2014 MIND INVENTORY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpViewController : UIViewController




-(IBAction)btnCloseClicked:(id)sender;


@property (nonatomic,assign) BOOL shouldHideOnOutsideClick;        /////  Default NO


@property (copy, nonatomic) void(^closeHandler)(BOOL animated);

@end
