//
//  NotificationCell.h
//  Yuuud
//
//  Created by mac-00015 on 5/25/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^switchChanged)(UISwitch *sw);

@interface NotificationCell : UITableViewCell
@property (nonatomic, strong)  IBOutlet UIImageView *imgIcon;
@property (nonatomic, strong)  IBOutlet UILabel *lbTitle;
@property (nonatomic, strong)  IBOutlet UISwitch *swPush;
@property (nonatomic, strong)  IBOutlet UIView *vwInner;

@property (nonatomic, copy) switchChanged configureSwitchChanged;



@end
