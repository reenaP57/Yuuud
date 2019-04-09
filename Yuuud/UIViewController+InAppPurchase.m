//
//  UIViewController+InAppPurchase.m
//  MI API Example
//
//  Created by mac-0001 on 10/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIViewController+InAppPurchase.h"

//#import "DelegateObserver.h"

#import "Master.h"

@implementation UIViewController (InAppPurchase)

-(void)purchaseInApp:(NSString *)inAppIdentifier
{
    [self purchaseInApp:inAppIdentifier quantity:1];
}

-(void)purchaseInApp:(NSString *)inAppIdentifier quantity:(NSInteger)quantity
{
    [self checkDelegateIsImplementedOrNot];
    
    if ([SKPaymentQueue canMakePayments])
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [[[DelegateObserver sharedInstance] content] setObject:[NSNumber numberWithInteger:quantity] forKey:inAppIdentifier];
        
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:inAppIdentifier]];
        request.delegate = [DelegateObserver sharedInstance];
        [request start];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:MILocalizedString(@"InAppPurchaseCanNotMakePayments", @"You can not make purchase,Please check your purchase settings.") delegate:nil cancelButtonTitle:nil otherButtonTitles:MILocalizedString(@"AlertButtonOK", @"OK"), nil];
        [alert show];
    }
}

-(void)restoreInApp
{
    [self checkDelegateIsImplementedOrNot];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(BOOL)checkDelegateIsImplementedOrNot
{
    id delegate = [[UIApplication sharedApplication] delegate];
    if (![delegate canPerformAction:NSSelectorFromString(@"applicationDidCompleteTransaction:error:") withSender:nil])
        NSAssert(nil, @"Please define \"-(void)applicationDidCompleteTransaction:(SKPaymentTransaction *)transaction error:(NSError *)error\" in your appdelegate");
    
    
    return YES;
}





@end
