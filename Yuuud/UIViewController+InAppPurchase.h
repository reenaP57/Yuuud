//
//  UIViewController+InAppPurchase.h
//  MI API Example
//
//  Created by mac-0001 on 10/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>


@interface UIViewController (InAppPurchase)

-(void)purchaseInApp:(NSString *)inAppIdentifier quantity:(NSInteger)quantity;
-(void)purchaseInApp:(NSString *)inAppIdentifier;
-(void)restoreInApp;

@end
