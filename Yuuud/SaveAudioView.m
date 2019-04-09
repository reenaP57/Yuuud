//
//  SaveAudioView.m
//  Yuuud
//
//  Created by mac-00015 on 2/24/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "SaveAudioView.h"

@implementation SaveAudioView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    
//    CViewSetWidth(self, [appDelegate getAspectWidth:306]);
//    CGFloat height =  [appDelegate getAspectHeight:189];
//    height = 189;
//    CViewSetHeight(self, height);
}

@end
