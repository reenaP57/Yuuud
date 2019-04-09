//
//  DelegateObserver.m
//  Bread and Bagels
//
//  Created by mac-0007 on 02/01/15.
//  Copyright (c) 2015 MI. All rights reserved.
//

//#import "DelegateObserver.h"

#import "Master.h"
#import "NSObject+NewProperty.h"

//#import "JTSImageInfo.h"
//#import "JTSImageViewController.h"
//#import "JTSSimpleImageDownloader.h"
//#import "JTSAnimatedGIFUtility.h"
//#import "UIImage+JTSImageEffects.h"
//#import "UIApplication+JTSImageViewController.h"

@interface NSObject ()

- (void)applicationDidCompleteTransaction:(SKPaymentTransaction *)transaction error:(NSError *)error;

@end

@interface DelegateObserver ()
{
    NSMutableDictionary *_content;
}
@end

@implementation DelegateObserver

+ (DelegateObserver *)sharedInstance
{
    static DelegateObserver *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DelegateObserver alloc] init];
    });
    
    return _sharedInstance;
}

-(NSMutableDictionary *)content
{
    if (!_content)
        _content = [[NSMutableDictionary alloc] init];
    
    return _content;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [textField textFieldShouldBeginEditing:textField];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView textViewDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView textViewDidEndEditing:textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [textView textViewDidChange:textView];
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [[UITextField activePickerField] numberOfComponentsInPickerView:pickerView];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[UITextField activePickerField] pickerView:pickerView numberOfRowsInComponent:component];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[UITextField activePickerField] pickerView:pickerView titleForRow:row forComponent:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[UITextField activePickerField] pickerView:pickerView didSelectRow:row inComponent:component];
}


#pragma mark - UIImageView


- (void)imageTapped:(UITapGestureRecognizer *)sender
{
    UIImageView *imageView = (UIImageView *) sender.view;
    
// Create image info
//    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//    imageInfo.image = imageView.image;
//    imageInfo.referenceRect = imageView.frame;
//    imageInfo.referenceView = imageView.superview;
//    imageInfo.referenceContentMode = imageView.contentMode;
//    imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
//    
//    // Setup view controller
//    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
//                                           initWithImageInfo:imageInfo
//                                           mode:JTSImageViewControllerMode_Image
//                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
//    
//    // Present the view controller.
//    [imageViewer showFromViewController:[imageView viewController] transition:JTSImageViewControllerTransition_FromOriginalPosition];
}


#pragma mark - INAppPurchase

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSArray *myProducts = response.products;
    NSLog(@"Products = %@",myProducts);
    
    if ([myProducts count]>0)
    {
        SKProduct *product = myProducts[0];
        SKProduct *selectedProduct = product;
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:selectedProduct];
        [payment setQuantity:[[[DelegateObserver sharedInstance] content] integerForKey:product.productIdentifier]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                return;
                break;
        }
        
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
//        if (transaction.transactionState == SKPaymentTransactionStatePurchased)
//        {
//            if(transaction.originalTransaction)
//            {
//                //User has already made a transaction so as to restore it.
//                NSLog(@"Just restoring the transaction");
//            }
//            else
//            {
//                //User is making a transaction for the first time.
//                NSLog(@"First time transaction");
//            }
//        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:MILocalizedString(@"AlertButtonOK", @"OK"), nil];
    [alert show];
}


-(void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self setSuccessfullPurchaseOfInApp:transaction];
    
    [CUserDefaults setBool:YES forKey:CInAppPurchase];
    [CUserDefaults synchronize];
}

- (void)restoreTransaction: (SKPaymentTransaction *)transaction
{
    [self setSuccessfullPurchaseOfInApp:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:nil otherButtonTitles:MILocalizedString(@"AlertButtonOK", @"OK"), nil];
        [alert show];
    }

    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate applicationDidCompleteTransaction:transaction error:transaction.error];
}

-(void)setSuccessfullPurchaseOfInApp:(SKPaymentTransaction *)transaction
{
//    UIAlertView *objAlert = [[UIAlertView alloc] initWithTitle:@"Yay!!" message:@"You are now ad free, continue using yuuud without any distractions" delegate:nil cancelButtonTitle:@"AWESOME" otherButtonTitles:nil, nil];
//    
//    [objAlert show];

    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate applicationDidCompleteTransaction:transaction error:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        ScanCode block = [[UIApplication sharedApplication] objectForKey:@"scanningBlock"];
        
        if (block)
            block([metadataObj stringValue]);
        
        [UIViewController stopReading];
    }
}


@end
