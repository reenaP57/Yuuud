//
//  SettingViewController.h
//  Yuuud
//
//  Created by mac-00015 on 2/23/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : SuperViewController<SKPaymentTransactionObserver>
{
    IBOutlet UITableView *tblSetting;
    IBOutlet UILabel *lbInfo;
    IBOutlet UIView *vwInApp;
}
@end
