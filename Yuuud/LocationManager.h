//
//  LocationManager.h
//  MI API Example
//
//  Created by mac-0006 on 11/18/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


typedef NS_ENUM(NSInteger, LocationType) {
    LocationTypeCurrent,
    LocationTypePrevious,
    LocationTypeDefault,
    LocationTypeInvalid,
};

typedef NS_ENUM(NSInteger, LocationManagerStatus) {
    LocationManagerStatusRunning,
    LocationManagerStatusFailed,
    LocationManagerStatusDisabled,
    LocationManagerStatusRequestedForPermission,
    LocationManagerStatusNotRunning,
    LocationManagerStatusFailedAndRefetching,
};


typedef void (^LocatioUpdateHandler)(CLLocation *location,LocationType type,LocationManagerStatus status,NSError *error);
typedef void (^Routes)(MKDirectionsResponse *directions);


#import "UIViewController+LocationManager.h"





@interface LocationManager : NSObject <CLLocationManagerDelegate>


@property (nonatomic,strong) CLLocationManager *manager;

@property (nonatomic,assign) BOOL isUpdatingLocation;

+ (instancetype)sharedInstance;

-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;

-(CLLocation *)currentLocation;
-(CLLocation *)defaultLoaction;
-(CLLocation *)previousLoaction;
-(void)setdefaultLoaction:(CLLocation *)location;


-(void)setLocationHandler:(LocatioUpdateHandler)handler;
-(void)removeLocationHandler:(LocatioUpdateHandler)handler;


+(void)drawRouteOnMap:(MKMapView*)map sourceLocation:(CLLocationCoordinate2D)source destinationLocation:(CLLocationCoordinate2D)destination;
+(void)findRoute:(MKMapItem*)source destination:(MKMapItem*)destination completion:(Routes)routeHandler;

@end



// To-Do ---- Apply two boolean variables which can used to store - shouldUseDefaultLocation  - shouldUsePreviousLoctaion
// To-Do ---- Apply expiration time for previous stored location.
// To-Do ---- Prompt Alert If Location service is disabled. Only if Access prompt is allready prompted to user for permission.