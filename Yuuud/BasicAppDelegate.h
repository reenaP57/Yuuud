//
//  BasicAppDelegate.h
//  TestSuperAppDelegate
//
//  Created by mac-0001 on 10/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BasicAppDelegate : UIResponder


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions NS_AVAILABLE_IOS(6_0);


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
