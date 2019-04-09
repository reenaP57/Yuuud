//
//  UIViewController+LocationManager.h
//  MI API Example
//
//  Created by mac-0006 on 11/18/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationManager.h"

@interface UIViewController (LocationManager)

-(void)fetchLocationUpdate:(LocatioUpdateHandler)handler;

-(void)getCurrentLocationOnly:(LocatioUpdateHandler)handler;

@end
