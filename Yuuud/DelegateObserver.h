//
//  DelegateObserver.h
//  Bread and Bagels
//
//  Created by mac-0007 on 02/01/15.
//  Copyright (c) 2015 MI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+InAppPurchase.h"

@interface DelegateObserver : NSObject <UIPickerViewDelegate,UIPickerViewDataSource,SKPaymentTransactionObserver,SKProductsRequestDelegate,AVCaptureMetadataOutputObjectsDelegate,UITextFieldDelegate,UITextViewDelegate>

+ (DelegateObserver *)sharedInstance;

- (NSMutableDictionary *)content;

@end
