//
//  UIViewController+LocationManager.m
//  MI API Example
//
//  Created by mac-0006 on 11/18/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIViewController+LocationManager.h"

@implementation UIViewController (LocationManager)

-(void)fetchLocationUpdate:(LocatioUpdateHandler)handler
{
    [[LocationManager sharedInstance] setLocationHandler:handler];
}

-(void)getInstantLocationUpdates:(LocatioUpdateHandler)handler
{
    [[LocationManager sharedInstance] setLocationHandler:handler];
}

-(void)getCurrentLocationOnly:(LocatioUpdateHandler)handler
{
    LocatioUpdateHandler handler2 = ^(CLLocation *location, LocationType type, LocationManagerStatus status, NSError *error)
    {
        
        if (type == LocationTypeCurrent)
        {
            [[LocationManager sharedInstance] removeLocationHandler:handler2];
            handler(location,type,status,error);
        }
        else if (status == LocationManagerStatusDisabled)
        {
            if (location)
                handler(location,type,status,error);
        }
        
    };
    
    [[LocationManager sharedInstance] setLocationHandler:handler2];
}

@end
