//
//  UIGestureRecognizer+Blocks.h
//  
//
//  Created by Mehul Rajput on 06/08/15.
//
//

#import <UIKit/UIKit.h>

#import "Master.h"

@interface UIGestureRecognizer (Blocks)

-(void)addTargetBlock:(MIVoidBlock)block;

@end
