//
//  NotificationCell.m
//  Yuuud
//
//  Created by mac-00015 on 5/25/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.vwInner.layer.cornerRadius = 3;
    //self.vwInner.layer.borderWidth = 1;
    self.vwInner.layer.borderColor = CRGB(234, 234, 234).CGColor;
    [self.vwInner.layer setMasksToBounds:NO];
    self.vwInner.layer.shadowOffset = CGSizeMake(0, 2);
    self.vwInner.layer.shadowOpacity = 0.1;
    self.vwInner.layer.shadowRadius = 1.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)swChanged:(UISwitch*)sender
{
    if (self.configureSwitchChanged)
        self.configureSwitchChanged(sender);
}


@end