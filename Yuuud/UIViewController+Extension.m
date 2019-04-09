//
//  UIViewController+Extension.m
//  Only Appointment
//
//  Created by mac-00015 on 7/7/15.
//  Copyright (c) 2015 mac-0009. All rights reserved.

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

+(id)initWithXib
{
    return  [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}


@end
