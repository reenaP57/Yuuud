//
//  AppDelegate.h
//  Yuuud
//
//  Created by mac-00015 on 2/22/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "Firebase.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <sqlite3.h>


typedef void (^FIRAuthResultCallback)(FIRUser *user, NSError *error);
typedef void(^changeScreen)(UILongPressGestureRecognizer *);
typedef void(^startRecording)(UILongPressGestureRecognizer *);
typedef void(^dismissScreen)(UILongPressGestureRecognizer *);
typedef void(^locationPermission)(void);
typedef void(^refreshYuuuds)(void);
typedef void(^refreshComments)(void);

@interface AppDelegate : BasicAppDelegate <UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark - Variable Properties
#pragma mark -


@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic,assign) BOOL isRecordingScreen, shouldRefresh;

@property (copy, nonatomic) FIRAuthResultCallback firAuthCallback;

@property (assign, nonatomic) double dLat, dLong;

#pragma mark - Blocks
#pragma mark -

@property (nonatomic, copy) locationPermission configureLocationPermission;
@property (nonatomic, copy) changeScreen configureChangeScreen;
@property (nonatomic, copy) startRecording configureStartRecording;
@property (nonatomic, copy) dismissScreen configureDismissScreen;
@property (nonatomic, copy) refreshYuuuds configureRefreshYuuuds;
@property (nonatomic, copy) refreshComments configureRrefreshComments;

@property (nonatomic, assign) BOOL didFindLocation;
@property (nonatomic, assign) BOOL isCommentScreen;

#pragma mark - Functions
#pragma mark -

- (CGFloat)getAspectWidth:(CGFloat)baseWidth;
- (CGFloat)getAspectHeight:(CGFloat)baseHeight;
- (void)hideKeyboard;
- (NSString *)getSoundPath;
- (NSString *)convertLikeCountInShortForm:(NSNumber *)count;
@end

