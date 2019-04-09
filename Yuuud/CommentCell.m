//
//  CommentCell.m
//  Yuuud
//
//  Created by mac-00015 on 2/27/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat radians = atan2f(self.transform.b, self.transform.a);
    CGFloat degrees = radians * (180 / M_PI);
    if (degrees == 0) {
        self.transform = CGAffineTransformMakeRotation(M_PI);
    }

}


@end
