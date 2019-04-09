//
//  UIApplication+Extension.h
//  Master
//
//  Created by mac-0001 on 01/12/14.
//  Copyright (c) 2014 mac-0001. All rights reserved.
//

typedef void (^Block)(void);



#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Master.h"
//#import "MIEvent.h"

//#import "APAddressBook.h"
//#import "APContact.h"

@interface UIApplication (Extension)


+(void)checkOtherLinkerFlagsContainObjCOrNpt;


+(void)setApplicationThemeWithTintColor:(UIColor*)tintColor barTintColor:(UIColor*)barTintColor navigationBarFont:(UIFont*)font;

#pragma mark - Crash And Log Handler

//+(void)setDeveloperEmail:(NSString *)email;
//+(NSString *)developerEmail;
//
//
//
//+(void)enableCrashHandling;
//+(void)disableCrashHandling;
//
//+(void)enableConsoleLogHandling;
//+(void)disableConsoleLogHandling;
//
//+(void)printSystemInformation;
//
//+(NSString *)deviceInformation;
//+(NSString *)applicationInformation;
//+(NSString *)timeZoneInfomration;
//+(NSString *)userDefaultsInfomration;
//
//
//+(void)parseApplicaitonResponse:(NSDictionary*)response;



#pragma mark - Parse - Push Notification

-(void)setParseApplicationId:(NSString *)key;
-(void)setParseClientKey:(NSString *)key;



#pragma mark - Unread Count Manager

-(void)setCount:(NSInteger)count forNotificaitonType:(NSInteger)notificationType;

-(void)addCountObserverForTotalNotificationCount:(MIIntegerResultBlock)block;
-(void)addCountObserver:(MIIntegerResultBlock)block forNotificationType:(NSInteger)type;
-(void)addCountObserver:(MIIntegerResultBlock)block forSumOfNotificationTypes:(NSArray*)types;




#pragma mark - Location Manager

//#if SDKLocationManager
+(void)startUpdatingLocation;
+(void)stopUpdatingLocation;
+(CLLocation *)currentLocation;
+(CLLocation *)defaultLoaction;
+(CLLocation *)previousLoaction;
//#endif



#pragma mark - General

+(UIImage *)screenshot;

+(UIViewController *)topMostController;

+(BOOL)isNewApplciaitonVersionInstalled;
+(BOOL)isNewInstallation;

+(NSString*)applicationName;


-(NSString *)userAgent;


#pragma mark - Keychain

+(void)setKeychainObject:(id)value forKey:(NSString *)key;
+(id)keychainObjectForKey:(NSString *)key;

+(void)setKeychain:(NSString *)value forKey:(NSString *)key;
+(void)removeKeychainForKey:(NSString *)key;
+(NSString *)keychainForKey:(NSString *)key;



+(NSString *)uniqueIdentifier;

+(NSString *)appID;

+(NSString *)deviceToken;
+(void)setDeviceToken:(NSString *)deviceToken;
+(void)removeDeviceToken;

+(NSString *)accessToken;
+(void)setAccessToken:(NSString *)accessToken;
+(void)removeAccessToken;

+(NSString *)userId;
+(void)setUserId:(id)userId;
+(void)removeUserId;


#pragma mark - UIApplication Blocks

+ (void)applicationDidReceiveMemoryWarning:(Block)block;
+ (void)applicationDidBecomeActive:(Block)block;
+ (void)applicationWillResignActive:(Block)block;
+ (void)applicationDidEnterBackground:(Block)block;
+ (void)applicationWillEnterForeground:(Block)block;
+ (void)applicationWillTerminate:(Block)block;



@end
