//
//  SuperNavigationController.m
//  ChamRDV
//
//  Created by mac-0001 on 12/17/13.
//  Copyright (c) 2013 MIND INVENTORY. All rights reserved.
//

#import "SuperNavigationController.h"

@interface SuperNavigationController ()

@end

@implementation SuperNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:CScreenBackgroundColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, CFontNotoSans(16), NSFontAttributeName,nil]];
    
    self.navigationBar.translucent = NO;
    

//    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObjects:[UINavigationBar class], nil]] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:CFontNotoSans(16) } forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    
    [self preferredStatusBarStyle];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/// # MI-r5

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    for (UIViewController *viewController in [self viewControllers])
    {
        if ([viewController canPerformAction:@selector(navigationControllerDidDisappear) withSender:nil])
            [viewController performSelector:@selector(navigationControllerDidDisappear)];
    }
    
    [self navigationControllerDidDisappear];
}

/// # MI-r5

- (void)navigationControllerDidDisappear
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
