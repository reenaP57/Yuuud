//
//  UIViewController+MessageMailComposerViewControllers.m
//  MI API Example
//
//  Created by mac-0001 on 11/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIViewController+MessageMailComposerViewControllers.h"

#import "NSObject+NewProperty.h"


static NSString *const MFMailComposeViewControllerHandler = @"MFMailComposeViewControllerHandler";
static NSString *const MFMessageComposeViewControllerHandler = @"MFMessageComposeViewControllerHandler";

@implementation UIViewController (MessageMailComposerViewControllers)

#pragma mark - Mail Composer

-(void)openMailComposer:(NSString *)subject recepients:(NSArray *)recepients body:(NSString *)body isHTML:(BOOL)isHtml completion:(MailCompletionHandler)completion
{
    [self setObject:completion forKey:MFMailComposeViewControllerHandler];
    [self openMailComposer:subject recepients:recepients body:body isHTML:isHtml];
}

-(void)openMailComposer:(NSString *)subject recepients:(NSArray *)recepients body:(NSString *)body isHTML:(BOOL)isHtml
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        composeViewController.navigationBar.tintColor = CNavigationBarColor;
        [composeViewController setSubject:subject];
        [composeViewController setMessageBody:body isHTML:isHtml];
        [composeViewController setToRecipients:recepients];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else
    {
        [[PPAlerts sharedAlerts] showAlertWithType:0 withMessage:MILocalizedString(@"MFMailComposeViewControllerCanNotSendMail", @"Can not send Mail")];
    }

}
    
#pragma mark - MFMailComposeViewControllerDelegate
    
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error)
        NSLog(@"MFMailComposeViewController Error === %@", error);
    else
        NSLog(@"MFMailComposeViewController Result === %u", result);
    
    
    [self dismissViewControllerAnimated:YES completion:^{

        MailCompletionHandler handler = [self objectForKey:MFMailComposeViewControllerHandler];
        if (handler)
            handler(result);
    }];
}

#pragma mark - Message Composer

-(void)openMessageComposer:(NSString *)subject recepients:(NSArray *)recepients body:(NSString *)body completion:(MessageCompletionHandler)completion
{
    [self setObject:completion forKey:MFMessageComposeViewControllerHandler];
    [self openMessageComposer:subject recepients:recepients body:body];
}

-(void)openMessageComposer:(NSString *)subject recepients:(NSArray *)recepients body:(NSString *)body
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *composeViewController = [[MFMessageComposeViewController alloc] init];
        composeViewController.messageComposeDelegate = self;
        
        [composeViewController setSubject:subject];
        [composeViewController setBody:body];
        [composeViewController setRecipients:recepients];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else
    {
        [[PPAlerts sharedAlerts] showAlertWithType:0 withMessage:MILocalizedString(@"MFMessageComposeViewControllerCanNotSendMail",@"Can not send Message")];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"MFMessageComposeViewController Result === %u", result);
    
    [self dismissViewControllerAnimated:YES completion:^{

        MessageCompletionHandler handler = [self objectForKey:MFMessageComposeViewControllerHandler];
        
        if (handler)
            handler(result);
    }];
}



@end
