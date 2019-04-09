//
//  LocationManager.m
//  MI API Example
//
//  Created by mac-0006 on 11/18/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "LocationManager.h"

#import "Master.h"


static NSString *const DEFAULTLOCATION = @"defaultLocation";
static NSString *const PREVIOUSTLOCATION = @"previousLocation";
static NSString *const LATITUDE = @"latitude";
static NSString *const LONGITUDE = @"longitude";


@interface LocationManager ()
{
    NSMutableArray *arrLocationHandlers;
}
@end


@implementation LocationManager

@synthesize manager,isUpdatingLocation;

+ (instancetype)sharedInstance
{
    static LocationManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LocationManager alloc] init];
    });
    
    return _sharedInstance;
}

-(void)intialize
{
    if (!self.manager)
    {
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        
        if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            if ([CBundleDictionary objectForKey:NSLocationAlwaysUsageDescription])
                [self.manager performSelector:@selector(requestAlwaysAuthorization)];
            else if ([CBundleDictionary objectForKey:NSLocationWhenInUseUsageDescription])
                [self.manager performSelector:@selector(requestWhenInUseAuthorization)];
            else
                NSAssert(nil, @"Please add Location Usage Key (NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription) on Info.plist");
        }
    }
}

-(void)startUpdatingLocation
{
    if (![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"### CLLocationManager === Location service is disabled");
    }
    
    [self intialize];
    [self.manager startUpdatingLocation];
    isUpdatingLocation = YES;
}

-(void)stopUpdatingLocation
{
    [self.manager stopUpdatingLocation];
    isUpdatingLocation = NO;
}

-(CLLocation *)currentLocation
{
//    if (!isUpdatingLocation)
//        [self startUpdatingLocation];
//        
    return [self.manager location];
}

-(CLLocation *)defaultLoaction
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTLOCATION];
    return [[CLLocation alloc] initWithLatitude:[[dic objectForKey:LATITUDE] doubleValue] longitude:[[dic objectForKey:LONGITUDE] doubleValue]];
}

-(CLLocation *)previousLoaction
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:PREVIOUSTLOCATION];
    return [[CLLocation alloc] initWithLatitude:[[dic objectForKey:LATITUDE] doubleValue] longitude:[[dic objectForKey:LONGITUDE] doubleValue]];
}

-(void)setdefaultLoaction:(CLLocation *)location
{
    [[NSUserDefaults standardUserDefaults] setObject:@{LATITUDE:[NSNumber numberWithDouble:location.coordinate.latitude],LONGITUDE:[NSNumber numberWithDouble:location.coordinate.longitude]} forKey:DEFAULTLOCATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Update Handlers

-(void)setLocationHandler:(LocatioUpdateHandler)handler
{
    CLLocation *location = nil;
    LocationType type = LocationTypeInvalid;
    LocationManagerStatus status = 0;
    NSError *error = nil;


    if ([CLLocationManager authorizationStatus] == (kCLAuthorizationStatusRestricted | kCLAuthorizationStatusDenied))
        status = LocationManagerStatusDisabled;
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        status = LocationManagerStatusRequestedForPermission;
    
    
    if (!arrLocationHandlers)
        arrLocationHandlers = [[NSMutableArray alloc] init];
    [arrLocationHandlers addObject:handler];


    if (status==0)
    {
        if (isUpdatingLocation)
            status = LocationManagerStatusRunning;
        else
            status = LocationManagerStatusNotRunning;
    }
    
    

    if (!isUpdatingLocation)
        [self startUpdatingLocation];

    
    
    if ([self previousLoaction])
    {
        location = [self previousLoaction];
        type = LocationTypePrevious;
    }
    else if([self defaultLoaction])
    {
        location = [self defaultLoaction];
        type = LocationTypeDefault;
    }

    
    
    handler(location,type,status,error);
}

-(void)removeLocationHandler:(LocatioUpdateHandler)handler
{
    if (arrLocationHandlers)
    {
        [arrLocationHandlers removeObject:handler];
        
        if (arrLocationHandlers.count == 0)
            [self stopUpdatingLocation];
    }
}

-(void)callHandlers:(CLLocation *)location type:(LocationType)type status:(LocationManagerStatus)status error:(NSError*)error
{
    for (int i=0; i<[arrLocationHandlers count]; i++)
    {
        LocatioUpdateHandler handler = [arrLocationHandlers objectAtIndex:i];
        handler(location,type,status,error);
    }
}

#pragma mark - Delegate Methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self callHandlers:newLocation type:LocationTypeCurrent status:LocationManagerStatusRunning error:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@{LATITUDE:[NSNumber numberWithDouble:newLocation.coordinate.latitude],LONGITUDE:[NSNumber numberWithDouble:newLocation.coordinate.longitude]} forKey:PREVIOUSTLOCATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self callHandlers:nil type:LocationTypeInvalid status:LocationManagerStatusFailedAndRefetching error:error];
    
    NSLog(@"locationManager:(CLLocationManager *)manager didFailWithError:  == %@",error);
}


#pragma mark - MapKit

+(void)drawRouteOnMap:(MKMapView*)map sourceLocation:(CLLocationCoordinate2D)source destinationLocation:(CLLocationCoordinate2D)destination
{
    MKPlacemark *sourcePlaceMark  = [[MKPlacemark alloc] initWithCoordinate:source addressDictionary:nil];
    MKPlacemark *destPlaceMark  = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    
    [self findRoute:[[MKMapItem alloc] initWithPlacemark:sourcePlaceMark] destination:[[MKMapItem alloc] initWithPlacemark:destPlaceMark] completion:^(MKDirectionsResponse *response) {
        
        [map addOverlay:[response.routes firstObject] level:MKOverlayLevelAboveRoads];
        [map setCenterCoordinate:response.source.placemark.location.coordinate animated:YES];
        
    }];
}

+(void)findRoute:(MKMapItem*)source destination:(MKMapItem*)destination completion:(Routes)routeHandler
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:source];
    [request setDestination:destination];
    [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
    [request setRequestsAlternateRoutes:NO]; // Gives you several route options.
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error)
        {
                if (routeHandler)
                    routeHandler(response);

//                [mapAllTrace addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
                // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
        }
        else
            NSLog(@"Error in finiding route between points: %@",error);
    }];
}

@end
