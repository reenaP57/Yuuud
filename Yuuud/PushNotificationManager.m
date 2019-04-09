//
//  PushNotificationManager.m
//  MI API Example
//
//  Created by mac-0001 on 25/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "PushNotificationManager.h"
#import "Master.h"
#import "NSObject+NewProperty.h"
#import "ApplicationConstants.h"



#import <UserNotifications/UserNotifications.h>



//#import <Parse/Parse.h>

@interface NSObject ()

@end


@interface NSObject ()

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo fromState:(UIApplicationState)state;

@end

@interface PushNotificationManager ()
@end


@implementation PushNotificationManager

+ (instancetype)sharedInstance
{
    static PushNotificationManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[PushNotificationManager alloc] init];
        
    });
    
    return _sharedInstance;
}

#pragma mark - Appdelegate Handlers

//#ifdef PARSE_DEPRECATED

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        NSDictionary *dic = (NSDictionary *) [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    }

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    NSString *tokenString = [[[newDeviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"Push Notification tokenstring is %@",tokenString);
    
    [UIApplication setDeviceToken:tokenString];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Push Notification Error %@",error.localizedDescription);
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
//{
//
//    NSLog(@"didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:");
//
//
//    [UIApplication parseApplicaitonResponse:[userInfo objectForKey:@"aps"]];
//
//    // To-Do call following methods after process completed.
//
//    handler(UIBackgroundFetchResultNewData);
//}

//#endif


- (void)disableRemoteNotification
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (void)enableRemoteNotification
{
    float systemVersion = [IosFullVersion floatValue];
    
    if (systemVersion >= 10)
    {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings)
         {
             switch (settings.authorizationStatus)
             {
                     // This means we have not yet asked for notification permissions
                 case UNAuthorizationStatusNotDetermined:
                 {
                     [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                         // You might want to remove this, or handle errors differently in production
                         NSAssert(error == nil, @"There should be no error");
                         if (granted) {
                             [[UIApplication sharedApplication] registerForRemoteNotifications];
                         }
                     }];
                 }
                     break;
                     // We are already authorized, so no need to ask
                 case UNAuthorizationStatusAuthorized:
                 {
                     // Just try and register for remote notifications
                     [[UIApplication sharedApplication] registerForRemoteNotifications];
                 }
                     break;
                     // We are denied User Notifications
                 case UNAuthorizationStatusDenied:
                 {
                     // Possibly display something to the user
                     UIAlertController *useNotificationsController = [UIAlertController alertControllerWithTitle:@"Turn on notifications" message:@"This app needs notifications turned on for the best user experience" preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"Go to settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         
                     }];
                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
                     [useNotificationsController addAction:goToSettingsAction];
                     [useNotificationsController addAction:cancelAction];
                     [appDelegate.window.rootViewController presentViewController:useNotificationsController animated:true completion:nil];
                     NSLog(@"We cannot use notifications because the user has denied permissions");
                 }
                     break;
             }
         }];
    }
    else if ((systemVersion < 10) || (systemVersion >= 8))
    {
        UIUserNotificationType types = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound |
                                        UIUserNotificationTypeAlert);
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        
        NSLog(@"Ipod added notificaion ====== > ");
    }
    else
    {
        NSLog(@"We cannot handle iOS 7 or lower in this example.");
    }
}

@end
