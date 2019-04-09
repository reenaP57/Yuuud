//
//  AppDelegate.m
//  Yuuud
//
//  Created by mac-00015 on 2/22/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "AppDelegate.h"

#import "AFNetworking.h"
#import "MIAFNetworking.h"
#import "AnimateScreenViewController.h"
#import "LocationSelectionViewController.h"
#import "LandingViewController.h"
#import "TutorialScreenViewController.h"
#import "CommentsViewController.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <AVFoundation/AVAudioSession.h>
#import "WToast.h"



#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <UNUserNotificationCenterDelegate, FIRMessagingDelegate>
{
    CTCallCenter *callCenter1;
}
@end

@implementation AppDelegate


NSString *const kGCMMessageIDKey = @"gcm.message_id";

#pragma mark - Application Life Cycle Events
#pragma mark -


//void (^block)(CTCall*) = ^(CTCall* objCall)
//{
//    NSLog(@"%@", objCall.callState);
//    
//    if (objCall.callState == CTCallStateConnected || objCall.callState == CTCallStateDialing || objCall.callState == CTCallStateIncoming)
//    {
////        NSLog(@"On call....");
//        
//        //[[PPAlerts sharedAlerts] showAlertWithType:3 withMessage:@"Unable to access microphone when another app is using it."];
//        
////        [[PPAlerts sharedAlerts] showAlertWithType:3 withMessage:@"Unable to access microphone when another app is using it." withTitle:nil withTimeoutImterval:1];
//    }
//};


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//     Override point for customization after application launch.
    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:59.3293 longitude:18.0686];
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (error == nil && [placemarks count] > 0)
//         {
//             CLPlacemark *placemark = [placemarks lastObject];
//             
//             NSLog(@"name: %@", placemark.name);
//             NSLog(@"thoroughfare: %@", placemark.thoroughfare);
//             NSLog(@"subThoroughfare: %@", placemark.subThoroughfare);
//             NSLog(@"locality: %@", placemark.locality);
//             NSLog(@"subLocality: %@", placemark.subLocality);
//             NSLog(@"administrativeArea: %@", placemark.administrativeArea);
//             NSLog(@"subAdministrativeArea: %@", placemark.subAdministrativeArea);
//             NSLog(@"postalCode: %@", placemark.postalCode);
//             NSLog(@"ISOcountryCode: %@", placemark.ISOcountryCode);
//             
//             NSLog(@"country: %@", placemark.ISOcountryCode);
//             NSLog(@"inlandWater: %@", placemark.inlandWater);
//             NSLog(@"ocean: %@", placemark.ocean);
//             NSLog(@"areasOfInterest: %@", placemark.areasOfInterest);
//             
//             [CUserDefaults setObject:[NSString stringWithFormat:@"%@,%@",placemark.subLocality,placemark.locality] forKey:CCurrentLocation];
//             [CUserDefaults synchronize];
//         }
//     }];
    
//    callCenter1 = [[CTCallCenter alloc] init];
//    callCenter1.callEventHandler = block;
    
    
    
   

    
    
    
    if(![CUserDefaults objectForKey:CCommentNotification])
        [CUserDefaults setBool:YES forKey:CCommentNotification];

    
    if(![CUserDefaults objectForKey:CLikeNotification])
        [CUserDefaults setBool:YES forKey:CLikeNotification];
    
    [CUserDefaults synchronize];
    
    [Fabric with:@[[Crashlytics class]]];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    [AFNetworkActivityIndicatorManager sharedManager];
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.google.com"]];
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusReachableViaWWAN:
             case AFNetworkReachabilityStatusReachableViaWiFi:
             {
                 NSLog(@"NETWORK REACHABLE");
                 [operationQueue setSuspended:NO];
             }
                 break;
             case AFNetworkReachabilityStatusNotReachable:
             default:
             {
                 NSLog(@"NETWORK UNREACHABLE");
                 [operationQueue setSuspended:YES];
                 break;
             }
         }
     }];
    
    [manager.reachabilityManager startMonitoring];
    
    __weak typeof(self) weakSelf = self;
    
    weakSelf.configureLocationPermission = ^{
        
        if (!weakSelf.locationManager)
        {
            [self setUpLocationManager];
        }
    };
    
    if (!self.locationManager && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined)
        [self setUpLocationManager];
    
    if(![CUserDefaults objectForKey:CCurrentLatitude] && ![CUserDefaults objectForKey:CCurrentLongitude])
    {
        [CUserDefaults setDouble:0 forKey:CCurrentLatitude];
        [CUserDefaults setDouble:0 forKey:CCurrentLongitude];
        [CUserDefaults setObject:@"" forKey:CCurrentLocation];
        
        if(IS_IPHONE_SIMULATOR)
        {
            [CUserDefaults setDouble:23 forKey:CCurrentLatitude];
            [CUserDefaults setDouble:72 forKey:CCurrentLongitude];
            [CUserDefaults setObject:@"Memnagar" forKey:CCurrentLocation];
        }
    }
    
    [CUserDefaults synchronize];
    
    [GADMobileAds configureWithApplicationID:CAdMobUnitID];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    self.longPress.numberOfTouchesRequired = 1;
    //self.longPress.minimumPressDuration = 0.5;
    
    AnimateScreenViewController *objAnimate = [AnimateScreenViewController initWithXib];
    SuperNavigationController *objSuperHome = [[SuperNavigationController alloc] initWithRootViewController:objAnimate];
    
    //LandingViewController *objLanding = [LandingViewController initWithXib];
    //SuperNavigationController *objSuperLanding = [[SuperNavigationController alloc] initWithRootViewController:objLanding];
    
    if([UIApplication userId])
        self.window.rootViewController = objSuperHome;
    else
    {
        TutorialScreenViewController *objTutorial = [TutorialScreenViewController initWithXib];
        self.window.rootViewController = objTutorial;
    }

    [self enableRemoteNotification];
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        NSLog(@"Launch from Notifications :  . . . .  .");
        
        NSDictionary *dic = (NSDictionary *) [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        [self redirectionToCommentScreen:dic];
    }

    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FIRApp configure];
    
    return [super application:application willFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    
    //[self setUpLocationManager];
    
    [[PPLoader sharedLoader] HideHudLoader];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark
#pragma mark - Remote Notification Delegate

- (void)disableRemoteNotification
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

#pragma mark -
#pragma mark - FireBase Messaging/Notification

- (void)enableRemoteNotification
{
    // Push Notification initialize:
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max)
    {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions =
        (UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge);
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
        
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        // For iOS 10 data message (sent via FCM)
        [FIRMessaging messaging].remoteMessageDelegate = self;
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    }
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
//{
//    if (userInfo[kGCMMessageIDKey])
//    {
//        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
//    }
//}

// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification. . .. . . ");
    
    if (userInfo[kGCMMessageIDKey])
    {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    [self redirectionToCommentScreen:userInfo];
}


#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
    NSLog(@"willPresentNotification. . .. . . ");
    
    //********
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if (userInfo[kGCMMessageIDKey])
    {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    NSLog(@"Notification1 %@", userInfo);

    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    if (userInfo[kGCMMessageIDKey])
    {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    [self redirectionToCommentScreen:userInfo];
    
    completionHandler();
}
#endif
// [END ios_10_message_handling]


// [START ios_10_data_message_handling]

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

// Receive data message on iOS 10 devices while app is in the foreground.

- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage
{ //********
    NSLog(@"Notification3 %@", remoteMessage.appData);
    
    NSLog(@"applicationReceivedRemoteMessage");
    
}
#endif
// [END ios_10_data_message_handling]


// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification
{
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}

// [END refresh_token]

// [START connect_to_fcm]

- (void)connectToFcm
{
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token])
        return;
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM. %@", [[FIRInstanceID instanceID] token]);
            
            if([[FIRInstanceID instanceID] token])
            {
                [CUserDefaults setObject:[[FIRInstanceID instanceID] token] forKey:CFCMToken];
                [CUserDefaults synchronize];
                
                [[APIRequest request] registerUserDeviceID:[[FIRInstanceID instanceID] token] completion:^(id responseObject, NSError *error) {
                    
                    NSLog(@"Response : %@",responseObject);
                    
                }];
            }
        }
    }];
}

// [END connect_to_fcm]

#pragma mark -
#pragma mark - Register Remote Notification Delegated

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"APNs token retrieved: %@", deviceToken);
    
    const unsigned *devTokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                       ntohl(devTokenBytes[0]), ntohl(devTokenBytes[1]), ntohl(devTokenBytes[2]),
                       ntohl(devTokenBytes[3]), ntohl(devTokenBytes[4]), ntohl(devTokenBytes[5]),
                       ntohl(devTokenBytes[6]), ntohl(devTokenBytes[7])];
    token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Token: %@", token);
    
    if (token)
    {
        //[CUserDefaults setObject:token forKey:UserDefaultUDID];
    }
    
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
    
    [self connectToFcm];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
}

#pragma mark - App Purchase method

-(void)applicationDidCompleteTransaction:(SKPaymentTransaction *)transaction error:(NSError *)error
{
    NSLog(@"Calling applicationDidCompleteTransaction");
}

#pragma mark - Location Manager Methods
#pragma mark -

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSString *errorString;
    switch([error code])
    {
        case kCLErrorDenied:
        {
            //            errorString = @"It seems your 'locations services' is turned off, Please turn it on from 'Settings > Privacy > Location Services' for this app to get location current!";
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //            NSLog(@"alert.msg : %@", alert.message);
            //            [alert show];
            break;
        }
            //        case kCLErrorLocationUnknown:
            //            errorString = @"Location data unavailable";
            //            break;
            //        default:
            //            errorString = @"An unknown error has occurred";
            //            break;
    }
    
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//
//    [CUserDefaults setDouble:newLocation.coordinate.latitude forKey:CCurrentLatitude];
//    [CUserDefaults setDouble:newLocation.coordinate.longitude forKey:CCurrentLongitude];
//    [CUserDefaults synchronize];
//    
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (error == nil && [placemarks count] > 0)
//         {
//             CLPlacemark *placemark = [placemarks lastObject];
//             [CUserDefaults setObject:[NSString stringWithFormat:@"%@,%@",placemark.subLocality,placemark.locality] forKey:CCurrentLocation];
//             [CUserDefaults synchronize];
//         }
//     }];
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.didFindLocation)
        return;
    
    CLLocation *newLocation = (CLLocation *)[locations lastObject];
   
    //NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
    if(newLocation)
    {
        self.didFindLocation = YES;
        [CUserDefaults setDouble:newLocation.coordinate.latitude forKey:CCurrentLatitude];
        [CUserDefaults setDouble:newLocation.coordinate.longitude forKey:CCurrentLongitude];
        [CUserDefaults synchronize];
        
        [self.locationManager stopUpdatingLocation];
        
        if (self.shouldRefresh)
        {
            if(appDelegate.configureRefreshYuuuds)
                appDelegate.configureRefreshYuuuds();
        }
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error == nil && [placemarks count] > 0)
             {
                 CLPlacemark *placemark = [placemarks lastObject];
                 
                 NSString *strName = @"";
                 
                 if (placemark.subLocality)
                     strName = placemark.subLocality;
                 
                 if ([strName isEqualToString:@""] && placemark.locality)
                     strName = placemark.locality;
                 else
                 {
                     if (placemark.locality)
                         strName = [NSString stringWithFormat:@"%@, %@", strName, placemark.locality];
                 }
                 
                 if([strName isEqualToString:@""] && placemark.name)
                     strName = placemark.name;
                 
                 [CUserDefaults setObject:strName forKey:CCurrentLocation];
                 [CUserDefaults synchronize];
                 
             }
         }];
    }
}

#pragma mark - Long press gesture event
#pragma mark -

- (IBAction)longPressGestureRecognized:(UILongPressGestureRecognizer*)sender
{
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if (self.configureChangeScreen)
                self.configureChangeScreen(sender);
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.configureStartRecording)
                self.configureStartRecording(sender);
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            NSLog(@"removed the gesture..");
            
            if (self.configureDismissScreen)
                self.configureDismissScreen(sender);
        }
            break;
        default:
        {
            
        }
            break;
    }
}

#pragma mark - Functions
#pragma mark -


-(CGFloat)getAspectWidth:(CGFloat)baseWidth
{
    return (CScreenWidth*baseWidth)/375;
}

- (CGFloat)getAspectHeight:(CGFloat)baseHeight
{
    return (CScreenHeight*baseHeight)/667;
}

- (void)hideKeyboard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (NSString *)getSoundPath
{
    NSError *error;
    
    NSString *strSoundPath = [NSString stringWithFormat:@"%@/Sounds", CDocumentsDirectory];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:strSoundPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:strSoundPath withIntermediateDirectories:NO attributes:nil error:&error]; //
    
    return strSoundPath;
}

- (NSString *)convertLikeCountInShortForm:(NSNumber *)count
{
    long num = [count floatValue];
    
    if (num < 999)
        return [NSString stringWithFormat:@"%@",count];
    
    double newCount =  (num/1000.0);
    
    if(num > 999 && num < 1100)
        return @"1K";
    else
        return [NSString stringWithFormat:@"%.1f",newCount];
}

- (void)redirectionToCommentScreen:(NSDictionary*)userInfo
{
    if (self.isCommentScreen)
    {
        if(self.configureRrefreshComments)
            self.configureRrefreshComments();

        return;
    }
    
    CommentsViewController *commentVC = [[CommentsViewController alloc] initWithNibName:@"CommentsViewController" bundle:nil];
    
    commentVC.shouldShowColor = YES;
    
    commentVC.dicRemote = userInfo;
    
    AnimateScreenViewController *objAnimate = [[AnimateScreenViewController alloc] initWithNibName:@"AnimateScreenViewController" bundle:nil];
    
    SuperNavigationController *objSuperLanding = [[SuperNavigationController alloc] initWithRootViewController:objAnimate];
    
    self.window.rootViewController = objSuperLanding;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [objSuperLanding pushViewController:commentVC animated:NO];
        
    });
    
    NSLog(@"%@", userInfo);
}

- (void)setUpLocationManager
{
    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [self.locationManager setDistanceFilter:100];
        [self.locationManager setDelegate:self];
        
        if(IS_Ios8)
            [self.locationManager requestWhenInUseAuthorization];
    }
    
    appDelegate.didFindLocation = NO;
    [self.locationManager startUpdatingLocation];
    appDelegate.shouldRefresh = YES;
}

@end
