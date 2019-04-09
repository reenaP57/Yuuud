
// # MI-r6
// Configuration settings will be stored

#define CBundleVersionOfLastInstalled @"BundleVersionOfLastInstalled"
#define CToken @"Token"
#define CUserName @"username"
#define CInAppPurchase @"apppurchase"

#define CNotificationsUserProfile @"notificationuserprofile"
#define CUserLoggedin @"userLoggedin"

#define CProductionMode 1

#if CProductionMode

#define CVersion @"1"

#define BASEURL @"http://35.176.73.184:1337/v1/"

#else

#define BASEURL @"http://mobicreation.in:1337/v1/"

#define CVersion @"1"

#endif
