//
//  PushNotificationManager.h
//  MI API Example
//
//  Created by mac-0001 on 25/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Master.h"

typedef BOOL (^CanNotificaitonHandledWithBlock)(NSDictionary *notification, UIApplicationState state);

@interface PushNotificationManager : NSObject

+ (instancetype)sharedInstance;

- (void)disableRemoteNotification;
- (void)enableRemoteNotification;

@end


/*
 /// Required Framewors
 
 AudioToolbox.framework
 CFNetwork.framework
 CoreGraphics.framework
 CoreLocation.framework
 libz.dylib
 MobileCoreServices.framework
 QuartzCore.framework
 Security.framework
 StoreKit.framework
 SystemConfiguration.framework
 
 */

