//
//  UIApplication+Extension.m
//  Master
//
//  Created by mac-0001 on 01/12/14.
//  Copyright (c) 2014 mac-0001. All rights reserved.
//

#import "UIApplication+Extension.h"

#import "Master.h"

#import "NSObject+NewProperty.h"

#import "PushNotificationManager.h"


#import <EventKit/EventKit.h>


@interface UIViewController ()

+(void)sendEmailToDeveloper:(NSString *)subject body:(NSString *)body completion:(MIBooleanResultBlock)completion;

@end


@interface NSObject ()

+ (instancetype)sharedInstance;
- (void)setDisableTracing:(BOOL)tracing;

@end



@implementation UIApplication (Extension)

#pragma mark - Crash Management

static void exceptionHandler(NSException *exception)
{
//    extern NSString *GTMStackTraceFromException(NSException *e);
//    NSString *crashString = [[NSString alloc] initWithFormat:@"%@\n\nStack trace:\n%@)", exception, GTMStackTraceFromException(exception)];
//    
//    NSString *crashPath = [UIApplication crashDirectory];
//
//    NSString *fileName =[NSString stringWithFormat:@"%f.crash",[[NSDate date] timeIntervalSince1970]];
//
//    
//    crashString = [crashString stringByAppendingString:[UIApplication deviceInformation]];
//    crashString = [crashString stringByAppendingString:@"\n"];
//    crashString = [crashString stringByAppendingString:[UIApplication applicationInformation]];
//    crashString = [crashString stringByAppendingString:@"\n"];
//    crashString = [crashString stringByAppendingString:[UIApplication timeZoneInfomration]];
//    crashString = [crashString stringByAppendingString:@"\n"];
//    crashString = [crashString stringByAppendingString:[UIApplication userDefaultsInfomration]];
//    crashString = [crashString stringByAppendingString:@"\n"];
//    
//    
//    [crashString writeToFile:[crashPath stringByAppendingPathComponent:fileName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

//+(NSString *)crashDirectory
//{
//    return [CCachesDirectory stringByAppendingPathComponent:@"MIApplication/Crash"];
//}

//+(void)enableCrashHandling
//{
//    if (IS_IPHONE_SIMULATOR)
//        return;
//    
//    if (NSGetUncaughtExceptionHandler())
//        return;
//        
//
//    NSLog(@"Crash Handling Enabled.");
//    
//    NSString *crashPath = [self crashDirectory];
//    
//    if(![[NSFileManager defaultManager] fileExistsAtPath:crashPath])
//        [[NSFileManager defaultManager] createDirectoryAtPath:crashPath withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    NSSetUncaughtExceptionHandler(&exceptionHandler);
//}
//
//+(void)disableCrashHandling
//{
//    if(NSGetUncaughtExceptionHandler())
//    {
//        NSLog(@"Crash Handling Disabled.");
//        NSSetUncaughtExceptionHandler(nil);
//    }
//}


#pragma mark - Parse Application Response

//+(void)parseApplicaitonResponse:(NSDictionary*)responseDictionary
//{
//    if (![responseDictionary objectForKey:@"ApplicationResponse"])
//        return;
//
//    
//    NSArray *arrayCodes = [[responseDictionary objectForKey:@"ApplicationResponse"] objectForKey:@"codes"];
//    
//    arrayCodes = [arrayCodes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"SELF" ascending:YES]]];
//    
//    for (int i=0; i<[arrayCodes count]; i++)
//    {
//        NSInteger code = (NSInteger)[arrayCodes objectAtIndex:i];
//        
//        switch (code)
//        {
//            case 1001:
//            {
//                if (NSClassFromString(@"MIAFNetworking"))
//                {
//                    id networking = [NSClassFromString(@"MIAFNetworking") sharedInstance];
//                    [networking setDisableTracing:NO];
//                }
//            }
//                break;
//            case 1002:
//            {
//                if (NSClassFromString(@"MIAFNetworking"))
//                {
//                    id networking = [NSClassFromString(@"MIAFNetworking") sharedInstance];
//                    [networking setDisableTracing:YES];
//                }
//            }
//                break;
//            case 2001:
//                [UIApplication enableConsoleLogHandling];
//                break;
//            case 2002:
//                [UIApplication disableConsoleLogHandling];
//                break;
//            case 2003:
//            {
//                [UIApplication sendDataFromDirectory:[UIApplication logDirectory] filtered:responseDictionary];
//            }
//                break;
//            case 3001:
//                [UIApplication enableCrashHandling];
//                break;
//            case 3002:
//                [UIApplication disableCrashHandling];
//                break;
//            case 3003:
//            {
//                [UIApplication sendDataFromDirectory:[UIApplication crashDirectory] filtered:responseDictionary];
//            }
//                break;
//            case 3004:
//                break;
//        }
//    }
//
//}
//
//
//+(void)sendDataFromDirectory:(NSString *)directory filtered:(NSDictionary *)filter
//{
//    [UIViewController sendEmailToDeveloper:[directory lastPathComponent] body:[self getDataFromDirectory:directory filter:filter] completion:nil];
//}
//
//+(NSString *)getDataFromDirectory:(NSString *)directory filter:(NSDictionary *)filter
//{
//    NSMutableString *logFiles = [[NSMutableString alloc] init];
//    
//    NSInteger fromInterval = 0;
//    NSInteger toInterval = [[NSDate date] timeIntervalSince1970];
//    
//    if ([filter objectForKey:@"timeInterval"])
//    {
//        fromInterval = [[[filter objectForKey:@"timeInterval"] objectForKey:@"from"] integerValue];
//        toInterval = [[[filter objectForKey:@"timeInterval"] objectForKey:@"to"] integerValue];
//    }
//    
//    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
//    
//    for (NSString *path in array)
//    {
//        NSString *filename = [path lastPathComponent];
//        
//        if ([[[filename componentsSeparatedByString:@"."] firstObject] integerValue]>fromInterval && [[[filename componentsSeparatedByString:@"."] firstObject] integerValue] < toInterval)
//        {
//            [logFiles appendFormat:@"\n\n\n%@============================\n",filename];
//            [logFiles appendString:[[NSString alloc] initWithData:[[NSFileManager defaultManager] contentsAtPath:path] encoding:NSUTF8StringEncoding]];
//        }
//    }
//    
//    return logFiles;
//}

#pragma mark - Log Management

//+(NSString *)logDirectory
//{
//    return [CCachesDirectory stringByAppendingPathComponent:@"MIApplication/Log"];
//}
//
//+(void)enableConsoleLogHandling
//{
//    NSLog(@"Console Log Enabled.");
//    
//    [self printSystemInformation];
//
//    
//    if (IS_IPHONE_SIMULATOR)
//        return;
//    
//    if ([self currentLogFile])
//        return;
//
//    
//    
//    NSString *logsPath = [self logDirectory];
//    
//    if(![[NSFileManager defaultManager] fileExistsAtPath:logsPath])
//        [[NSFileManager defaultManager] createDirectoryAtPath:logsPath withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    
//    NSString *fileName =[NSString stringWithFormat:@"%f.log",[[NSDate date] timeIntervalSince1970]];
//    NSString *logFilePath = [logsPath stringByAppendingPathComponent:fileName];
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
//    
//    [[UIApplication sharedApplication] setObject:logFilePath forKey:@"LogFile"];
//}
//
//+(void)disableConsoleLogHandling
//{
//    if ([self currentLogFile])
//    {
//        NSLog(@"Console Log Disabled.");
//        [[UIApplication sharedApplication] setObject:nil forKey:@"LogFile"];
//        fclose(stderr);
//    }
//}
//
//
//+(NSString *)currentLogFile
//{
//    return [[UIApplication sharedApplication] objectForKey:@"LogFile"];
//}

//+(void)printSystemInformation
//{
//    NSLog(@"%@",[self deviceInformation]);
//    NSLog(@"%@",[self applicationInformation]);
//
//    NSLog(@"%@",[self timeZoneInfomration]);
//    NSLog(@"%@",[self userDefaultsInfomration]);
//}
//
//+(NSString *)deviceInformation
//{
//    NSString *string = @"";
//    
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"Device Model == %@ === %@",[UIDevice platform],[UIDevice platformString]];
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"Ratina Scale == %f",[UIScreen mainScreen].scale];
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"Resolution == %f*%f",[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height];
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"iOs Version == %@",[[UIDevice currentDevice] systemVersion]];
//    
//    return string;
//}

//+(NSString *)applicationInformation
//{
//    NSString *string = @"";
//    
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"Application Name == %@",CApplicationName];
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"Bundle Identidier == %@",CBundleIdentifier];
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"Build Version == %@",CVersionNumber];
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"Build Number == %@",CBuildNumber];
//
//    return string;
//}
//
//+(NSString *)timeZoneInfomration
//{
//    NSString *string = @"";
//
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"Timezone == %@\n%@\n%@\n%ld\n%f",[[NSTimeZone defaultTimeZone] name],[[NSTimeZone defaultTimeZone] description],[[NSTimeZone defaultTimeZone] abbreviation],(long)[[NSTimeZone defaultTimeZone] secondsFromGMT],[[NSTimeZone defaultTimeZone] daylightSavingTimeOffset]];
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"Locale == %@",[NSLocale currentLocale]];
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"24-Hour Clock == %@",[UIApplication uses24HourTimeCycle]?@"YES":@"NO"];
//    string = [string stringByAppendingString:@"\n"];
//    string = [string stringByAppendingFormat:@"CurrentTime == %@ --- %f",[NSDate date],[[NSDate date] timeIntervalSince1970]];
//
//    return string;
//}
//
//+(NSString *)userDefaultsInfomration
//{
//    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
//}




//+(void)setDeveloperEmail:(NSString *)email
//{
//    [UIApplication setKeychain:email forKey:@"dEmail"];
//}
//
//+(NSString *)developerEmail
//{
//    return [UIApplication keychainForKey:@"dEmail"];
//}
//
//#pragma mark - Device Clock Information
//
//+ (BOOL)uses24HourTimeCycle
//{
//    BOOL uses24HourTimeCycle = NO;
//    
//    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
//    NSScanner *symbolScanner = [NSScanner scannerWithString:formatStringForHours];
//    
//    NSString *singleQuoteCharacterString = @"'";
//    
//    // look for single quote characters, ignore those and the enclosed strings
//    while ( ![symbolScanner isAtEnd] ) {
//        
//        NSString *scannedString = @"";
//        [symbolScanner scanUpToString:singleQuoteCharacterString intoString:&scannedString];
//        
//        // if 'H' or 'k' is found the locale uses 24 hour time cycle, and we can stop scanning
//        if ( [scannedString rangeOfString:@"H"].location != NSNotFound ||
//            [scannedString rangeOfString:@"k"].location != NSNotFound ) {
//            
//            uses24HourTimeCycle = YES;
//            
//            break;
//        }
//        
//        // skip the single quote
//        [symbolScanner scanString:singleQuoteCharacterString intoString:NULL];
//        // skip everything up to and including the next single quote
//        [symbolScanner scanUpToString:singleQuoteCharacterString intoString:NULL];
//        [symbolScanner scanString:singleQuoteCharacterString intoString:NULL];
//    }
//    
//    return uses24HourTimeCycle;
//}
//
//#pragma mark - Parse - Push Notification
//
//-(void)setParseApplicationId:(NSString *)key
//{
//    [[UIApplication sharedApplication] setObject:key forKey:@"ParseApplicationId"];
//}
//
//-(void)setParseClientKey:(NSString *)key
//{
//    [[UIApplication sharedApplication] setObject:key forKey:@"ParseClientKey"];
//}


#pragma mark - Unread Count Manager

-(void)setCount:(NSInteger)count forNotificaitonType:(NSInteger)notificationType
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setDictionary:[UIApplication keychainObjectForKey:@"NotificationCount"]];
    

    [dictionary setObject:[NSString stringWithFormat:@"%ld",count] forKey:[NSString stringWithFormat:@"%ld",notificationType]];
    
    
    [UIApplication setKeychainObject:dictionary forKey:@"NotificationCount"];
    
    [self updateNotificationCountForType:notificationType];
}

-(NSInteger)countForNotificationType:(NSInteger)notificationType
{
    NSDictionary *dictionary = [UIApplication keychainObjectForKey:@"NotificationCount"];
    
    return [[dictionary objectForKey:[NSString stringWithFormat:@"%ld",notificationType]] integerValue];
}

-(void)updateNotificationCountForType:(NSInteger)type
{
    NSInteger count = [self countForNotificationType:type];
    
    NSDictionary *dicBlocks = [[UIApplication sharedApplication] objectForKey:@"NotificaiotnBlocks"];
    
    for (NSString *key in [dicBlocks allKeys])
    {
        if([key isEqualToString:[NSString stringWithFormat:@"%ld",(long)type]])
        {
            MIIntegerResultBlock block = [dicBlocks valueForKey:key];
            block(count,nil);
        }
        else if([key rangeOfString:[NSString stringWithFormat:@"%ld",(long)type]].location!=NSNotFound)
        {
            NSInteger totalCount = 0;

            NSArray *allTypes = [key componentsSeparatedByString:@"-"];
            
            for (NSString *typeString in allTypes)
            {
                totalCount += [self countForNotificationType:[typeString integerValue]];
            }
            
            MIIntegerResultBlock block = [dicBlocks valueForKey:key];
            block(totalCount,nil);
        }
    }
    
    [self updateTotalNotificaiotnCount];
}

-(void)updateTotalNotificaiotnCount
{
    NSInteger totalcount = 0;

    NSDictionary *dictionary = [UIApplication keychainObjectForKey:@"NotificationCount"];

    for (NSString *key in [dictionary allKeys])
    {
        totalcount += [[dictionary objectForKey:key] integerValue];
    }
    
    
    NSDictionary *dicBlocks = [[UIApplication sharedApplication] objectForKey:@"NotificaiotnBlocks"];
    
    for (NSString *key in [dicBlocks allKeys])
    {
        if([key isEqualToString:@"Total"])
        {
            MIIntegerResultBlock block = [dicBlocks valueForKey:key];
            block(totalcount,nil);
        }
    }

    //[[PushNotificationManager sharedInstance] setBadge:totalcount];
}

-(void)addCountObserverForTotalNotificationCount:(MIIntegerResultBlock)block
{
    [self registerNotificaiotnCountObserver:block forKey:@"Total"];
    [self updateTotalNotificaiotnCount];
}

-(void)addCountObserver:(MIIntegerResultBlock)block forNotificationType:(NSInteger)type
{
    [self registerNotificaiotnCountObserver:block forKey:[NSString stringWithFormat:@"%ld",type]];
    [self updateNotificationCountForType:type];
}

-(void)addCountObserver:(MIIntegerResultBlock)block forSumOfNotificationTypes:(NSArray*)types
{
    [self registerNotificaiotnCountObserver:block forKey:[NSString stringWithFormat:@"%@",[types componentsJoinedByString:@"-"]]];
    [self updateNotificationCountForType:(NSInteger)[types objectAtIndex:0]];
}

-(void)registerNotificaiotnCountObserver:(MIIntegerResultBlock)observer forKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setDictionary:[[UIApplication sharedApplication] objectForKey:@"NotificaiotnBlocks"]];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:[dictionary objectForKey:key]];

    
    if (![array containsObject:observer])
    {
        [array addObject:observer];
        
        [dictionary setObject:array forKey:key];
        
        [[UIApplication sharedApplication] setObject:dictionary forKey:@"NotificaiotnBlocks"];
    }
}

-(void)removeAllNotificationsCount
{
    [[UIApplication sharedApplication] setObject:nil forKey:@"NotificaiotnBlocks"];
    [UIApplication removeKeychainForKey:@"NotificationCount"];
}


#pragma mark - Location Manager

+(void)startUpdatingLocation
{
    [[LocationManager sharedInstance] startUpdatingLocation];
}

+(void)stopUpdatingLocation
{
    [[LocationManager sharedInstance] stopUpdatingLocation];
}

+(CLLocation *)currentLocation
{
    return [[LocationManager sharedInstance] currentLocation];
}

+(CLLocation *)defaultLoaction
{
    return [[LocationManager sharedInstance] defaultLoaction];
}

+(CLLocation *)previousLoaction
{
    return [[LocationManager sharedInstance] previousLoaction];
}


#pragma mark - General

+(UIImage *)screenshot
{
    return [UIViewController screenshot];
}

+(UIViewController *)topMostController
{
    UIViewController *topController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while ([topController presentedViewController])	topController = [topController presentedViewController];
    
    return topController;
}

+(BOOL)isNewApplciaitonVersionInstalled
{
    return [[UIApplication sharedApplication] booleanForKey:@"newVersion"];
}

+(BOOL)isNewInstallation
{
    return [[UIApplication sharedApplication] booleanForKey:@"newInstallation"];
}

+(NSString*)applicationName
{
    return CApplicationName;
}

+(void)setApplicationThemeWithTintColor:(UIColor*)tintColor barTintColor:(UIColor*)barTintColor navigationBarFont:(UIFont*)font
{
    [[UINavigationBar appearance] setBarTintColor:barTintColor];
    [[UINavigationBar appearance] setTintColor:tintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:tintColor}];
    
    [[UIToolbar appearance] setBarTintColor:barTintColor];
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:tintColor];
    
    [[UISwitch appearance] setOnTintColor:barTintColor];
    
    [[UISearchBar appearance] setBarTintColor:barTintColor];
    [[UISearchBar appearance] setTintColor:tintColor];
    
    [[UISegmentedControl appearance] setTintColor:barTintColor];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:tintColor} forState:UIControlStateNormal];
    
    [[UIActivityIndicatorView appearance] setColor:barTintColor];
    
    [[UISlider appearance] setMinimumTrackTintColor:barTintColor];
    [[UISlider appearance] setMaximumTrackTintColor:tintColor];
    [[UISlider appearance] setThumbTintColor:barTintColor];
    
    [[UIButton appearance] setTitleColor:tintColor forState:UIControlStateNormal];
    
    [[UIPageControl appearance] setPageIndicatorTintColor:barTintColor];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:tintColor];
    [[UIPageControl appearance] setBackgroundColor:[UIColor clearColor]];
    
    [[UIProgressView appearance] setProgressTintColor:tintColor];
    [[UIProgressView appearance] setTrackTintColor:barTintColor];
    
    [[UITabBar appearance] setTintColor:tintColor];
    [[UITabBar appearance] setBarTintColor:barTintColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:tintColor} forState:UIControlStateNormal];
    
    [[UITableView appearance] setSeparatorColor:barTintColor];
    [[UITableView appearance] setTintColor:barTintColor];
}



+(void)checkOtherLinkerFlagsContainObjCOrNpt
{
    // Don't remove this method, it is used to check project contains -ObjC or not?
}


#pragma mark - Methods


//-(NSString *)userAgent
//{
//    return [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",@"iOS",CBundleIdentifier,DeviceModel,IosFullVersion,CVersionNumber,CBuildNumber];
//}


#pragma mark - AccessTokens

+(void)setKeychainObject:(id)value forKey:(NSString *)key
{
    if (value)
        [KeychainWrapper createKeychainObject:value forIdentifier:key];
}

+(id)keychainObjectForKey:(NSString *)key
{
    return [KeychainWrapper keychainDataFromMatchingIdentifier:key];
}





+(void)setKeychain:(NSString *)value forKey:(NSString *)key
{
    if (value)
        [KeychainWrapper createKeychainValue:value forIdentifier:key];
}

+(void)removeKeychainForKey:(NSString *)key
{
    [KeychainWrapper deleteItemFromKeychainWithIdentifier:key];
}

+(NSString *)keychainForKey:(NSString *)key
{
   return [KeychainWrapper keychainStringFromMatchingIdentifier:key];
}





+(NSString *)uniqueIdentifier
{
    return [UIApplication keychainForKey:@"deviceUniqueIdentifier"];
}



+(NSString *)appID
{
    return [UIApplication keychainForKey:@"appID"];
}


+(NSString *)deviceToken
{
    return [UIApplication keychainForKey:@"deviceToken"];
}

+(void)setDeviceToken:(NSString *)deviceToken
{
    if (![[UIApplication deviceToken] isEqualToString:deviceToken])
        [UIApplication setKeychain:@"YES" forKey:@"isNewDeviceToken"];
    
    [UIApplication setKeychain:deviceToken forKey:@"deviceToken"];
}

+(void)removeDeviceToken
{
    [UIApplication removeKeychainForKey:@"deviceToken"];
}



+(NSString *)accessToken
{
    return [UIApplication keychainForKey:@"userAccessToken"];
}

+(void)setAccessToken:(NSString *)accessToken
{
    [UIApplication setKeychain:accessToken forKey:@"userAccessToken"];
}

+(void)removeAccessToken
{
    [UIApplication removeKeychainForKey:@"userAccessToken"];
}



+(NSString *)userId
{
    return [UIApplication keychainForKey:@"userID"];
}

+(void)setUserId:(id)userId
{
    [UIApplication setKeychain:userId forKey:@"userID"];
    //[[PushNotificationManager sharedInstance] refreshChannelsWithInsert];
}

+(void)removeUserId
{
    [UIApplication removeKeychainForKey:@"userID"];
    //[[PushNotificationManager sharedInstance] refreshChannelsWithInsert];
    [[UIApplication sharedApplication] removeAllNotificationsCount];
    
    if (NSClassFromString(@"MIAFNetworking"))
    {
        [[NSClassFromString(@"MIAFNetworking") performSelectorFromStringWithReturnObject:@"sharedInstance"] performSelectorFromString:@"cancelAllRequests"];
    }
    
    if (NSClassFromString(@"SocialNetworks"))
    {
        [[NSClassFromString(@"SocialNetworks") performSelectorFromStringWithReturnObject:@"sharedInstance"] performSelectorFromString:@"logoutFromAllSocialNetworks"];
    }
}



#pragma mark - Applicaiton Lifecycle Methods


+ (void)applicationDidReceiveMemoryWarning:(Block)block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        block();
    }];
}

+ (void)applicationDidBecomeActive:(Block)block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        block();
    }];
}

+ (void)applicationWillResignActive:(Block)block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        block();
    }];
}

+ (void)applicationDidEnterBackground:(Block)block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        block();
    }];
}

+ (void)applicationWillEnterForeground:(Block)block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        block();
    }];
}

+ (void)applicationWillTerminate:(Block)block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        block();
    }];
}



@end
