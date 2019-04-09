//
//  UIButton+EventHandler.m
//  MI API Example
//
//  Created by mac-0001 on 12/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIButton+EventHandler.h"

#import "Master.h"
#import "NSObject+NewProperty.h"


static NSString *const BUTTONCALLBACKHANDLER = @"buttonHandler";


@implementation UIButton (EventHandler)

#pragma mark - Touch Up Inside Handler


-(void)touchUpInsideClicked:(TouchUpInsideHandler)clicked
{
    [self setObject:clicked forKey:BUTTONCALLBACKHANDLER];
    [self addTarget:self action:@selector(touchUpInsideClickedEventFired:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touchUpInsideClickedEventFired:(UIButton *)sender
{
    TouchUpInsideHandler obj = [self objectForKey:BUTTONCALLBACKHANDLER];
    
    if (obj)
    {
        obj();
    }
}



#pragma mark - Button with UIAlertView

-(void)showAlertOnTouchUpInsideClicked:(NSString *)title message:(NSString *)message otherButtons:(NSArray *)otherButtons clicked:(AlertViewButtonClickedHandler)clicked
{
    [self showAlertOnTouchUpInsideClicked:title message:message cancelButton:nil otherButtons:otherButtons clicked:clicked];
}

-(void)showAlertOnTouchUpInsideClicked:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel otherButtons:(NSArray *)otherButtons clicked:(AlertViewButtonClickedHandler)clicked
{
    [self touchUpInsideClicked:^{

        switch ([otherButtons count]) {
            case 0:
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil] show:clicked];
                break;
            case 1:
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:[otherButtons objectAtIndex:0],nil] show:clicked];
                break;
            case 2:
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:[otherButtons objectAtIndex:0],[otherButtons objectAtIndex:1],nil] show:clicked];
                break;
            case 3:
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:[otherButtons objectAtIndex:0],[otherButtons objectAtIndex:1],[otherButtons objectAtIndex:2],nil] show:clicked];
                break;
            case 4:
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:[otherButtons objectAtIndex:0],[otherButtons objectAtIndex:1],[otherButtons objectAtIndex:2],[otherButtons objectAtIndex:3],nil] show:clicked];
                break;
            case 5:
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:[otherButtons objectAtIndex:0],[otherButtons objectAtIndex:1],[otherButtons objectAtIndex:2],[otherButtons objectAtIndex:3],[otherButtons objectAtIndex:4],nil] show:clicked];
                break;
            default:
                NSAssert(nil, @"Please Edit this method to support more buttons on UIAlertView");
                break;
        }

    }];
}

@end
