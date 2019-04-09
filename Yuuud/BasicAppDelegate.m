//
//  BasicAppDelegate.m
//  TestSuperAppDelegate
//
//  Created by mac-0001 on 10/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "BasicAppDelegate.h"

@implementation BasicAppDelegate

#pragma mark - Application Lifecycle

// To Check Authentication of Framework

// To Check Authentication of Framework
+(void)load
{
    [super load];
    
    //    #if defined(DEBUG)
    //        [UIApplication enableConsoleLogHandling];
    //        [UIApplication enableCrashHandling];
    //    #endif
    
    @try {
        
        [UIApplication checkOtherLinkerFlagsContainObjCOrNpt];
        
    }
    @catch (NSException *exception) {
        
        if (exception)
        {
            NSLog(@"Set \"-ObjC\" for \"Other Linker Flags\" from Build Settings");
            exit(0);
        }
        
    }
    @finally{
        
        [UIApplication setKeychain:@"Initialized" forKey:@"Application"];
        
    }
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Checking Insallation and Version Update Information
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Version"])
    {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"Version"] isEqualToString:CVersionNumber] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"Build"] isEqualToString:CBuildNumber])
            [[UIApplication sharedApplication] setBoolean:YES forKey:@"newVersion"];
    }
    else
    {
        [UIApplication removeAccessToken];
        [UIApplication removeUserId]; // It will also Refresh channels when application is uninstalled and user is not logedin, and when user wass loged in while uninstalling
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        
        if (![UIApplication uniqueIdentifier] || [UIApplication uniqueIdentifier].length==0)
            [UIApplication setKeychain:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"deviceUniqueIdentifier"];
        
        [[UIApplication sharedApplication] setBoolean:YES forKey:@"newInstallation"];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:CVersionNumber forKey:@"Version"];
    [[NSUserDefaults standardUserDefaults] setValue:CBuildNumber forKey:@"Build"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //
    
    if(IS_IPHONE_SIMULATOR)
    {
        NSLog(@"Documents Folder = %@",CDocumentsDirectory);
        NSLog(@"Cache Folder = %@",CCachesDirectory);
    }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[DelegateObserver sharedInstance]];
    [UIApplication applicationWillTerminate:^{
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:[DelegateObserver sharedInstance]];
    }];
    
    //////
    [[UIApplication sharedApplication] addDelegate:self];
    
    if (NSClassFromString(@"PFInstallation"))
    {
        Class PushNotificationManager = NSClassFromString(@"PushNotificationManager");
        [[UIApplication sharedApplication] addDelegate:[PushNotificationManager sharedInstance]];
    }
    
    if (NSClassFromString(@"SocialNetworks"))
    {
        Class SocialNetworks = NSClassFromString(@"SocialNetworks");
        [[UIApplication sharedApplication] addDelegate:[SocialNetworks sharedInstance]];
    }
    //////
    
    return YES;
}


// To Hanlde SocialNetworks CallBack
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}
@end

