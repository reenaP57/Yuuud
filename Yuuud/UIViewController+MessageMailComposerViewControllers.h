//
//  UIViewController+MessageMailComposerViewControllers.h
//  MI API Example
//
//  Created by mac-0001 on 11/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Master.h"

typedef void (^MailCompletionHandler)(MFMailComposeResult result);
typedef void (^MessageCompletionHandler)(MessageComposeResult result);


@interface UIViewController (MessageMailComposerViewControllers) <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

-(void)openMailComposer:(NSString *)subject recepients:(NSArray *)recepients body:(NSString *)body isHTML:(BOOL)isHtml completion:(MailCompletionHandler)completion;
-(void)openMailComposer:(NSString *)subject recepients:(NSArray *)recepients body:(NSString *)body isHTML:(BOOL)isHtml;

-(void)openMessageComposer:(NSString *)subject recepients:(NSArray *)recepients body:(NSString *)body completion:(MessageCompletionHandler)completion;
-(void)openMessageComposer:(NSString *)subject recepients:(NSArray *)recepients body:(NSString *)body;


@end



// To-Do Add Methods with delegate block
