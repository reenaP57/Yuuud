
#import "AppDelegate.h"

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#define CAdMobUnitID @"ca-app-pub-8782530512283806/9023596379"
#define Product_ID @"com.yuuud.ad.1"


#define CJsonStatus @"status"
#define CJsonMessage @"message"
#define CJsonTitle @"title"
#define CJsonData @"data"
#define CJsonResponse @"response"

#define CMessageWait @"Please Wait..."
#define CMessageSorry @"Sorry!"

#define CInternetNotAvailable @"Please connect to internet to proceed."
#define CUserId @"LoginUserId"
#define CFCMToken @"fcmtoken"

#pragma mark - Colors
// --------------------------------------
#define CScreenBackgroundColor  CRGB(255, 88, 61)
#define CNavigationBarColor  CRGB(255, 88, 61)

#pragma mark - Device Constants
// --------------------------------------
#define CDeviceHeight [UIScreen mainScreen].bounds.size.height
#define Is_iPhone_4 CDeviceHeight == 480
#define Is_iPhone_5 CDeviceHeight == 568
#define Is_iPhone_6 CDeviceHeight == 667
#define Is_iPhone_6_PLUS CDeviceHeight == 736


#pragma mark - User related constants
// --------------------------------------
#define CCurrentLatitude @"CurrentLatitude"
#define CCurrentLongitude @"CurrentLongitude"
#define CCurrentLocation @"CurrentLocation"

#pragma mark - Fonts
// --------------------------------------
#define CFontNotoSans(fontSize) [UIFont fontWithName:@"Noto Sans" size:fontSize]


#pragma mark - Common Constants

#define CCommentNotification @"CommentNotification"
#define CLikeNotification @"LikeNotification"
