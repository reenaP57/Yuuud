//
//  UIViewController+Helper.m
//  MI API Example
//
//  Created by mac-0001 on 13/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIViewController+Helper.h"

#import "NSObject+NewProperty.h"

static NSString *const BACKACTIIONHANDLER = @"backActionHandler";
static NSString *const MENUACTIONHANDLER = @"menuActionHandler";

@implementation UIViewController (Helper)

+(UIViewController *)viewController
{
    return [[self alloc] init];
}


- (BOOL)isVisible
{
    return (self.isViewLoaded && self.view.window);
}

- (BOOL)isDismissed
{
    return ([self isBeingDismissed] || [self isMovingFromParentViewController]);
}

- (BOOL)isPresented
{
    return ([self isBeingPresented] || [self isMovingToParentViewController]);
}



-(void)presentOnTop
{
    [[UIApplication topMostController] presentViewController:self animated:YES completion:nil];
}



-(void)setBackButton
{
    __typeof(self)blockSelf = self;
    [self setBackButton:^{
        [blockSelf.navigationController popViewControllerAnimated:YES];
    }];
}



-(void)setBackButton:(Block)block
{
    [self setObject:block forKey:BACKACTIIONHANDLER];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage backImage] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 8, 0, 0)] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    
}

-(void)backButtonClicked:(id)sender
{
    Block block = [self objectForKey:BACKACTIIONHANDLER];
    
    if (block)
        block();
}



@end



// To-Do check "presentOnTop" method - Its not working.
