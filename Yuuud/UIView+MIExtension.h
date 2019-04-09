//
//  UIView+MIExtension.h
//  VLB
//
//  Created by mac-0001 on 7/10/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIPosition) {
    UIPositionTop          = 0,
    UIPositionBottom     = 1,
    UIPositionLeft = 2,
    UIPositionRight = 3,
};


@interface UIView (MIExtension)

+(id)loadOrInitializeView;
+(id)viewFromXib;           /// # MI-r7
+(id)viewWithNibName:(NSString*)nibName;

- (UIViewController*)viewController;

-(void)removeAllSubviews;                               /// # MI-r7
-(void)removeAllSubviewsOfClass:(NSString *)class;       /// # MI-r7
-(void)removeAllSubviewsOfTag:(NSInteger)tag;            /// # MI-r7

-(void)addBorder:(UIPosition)position color:(UIColor *)color width:(CGFloat)width;  /// # MI-r7


- (void)addBlurViewWithStyle:(NSInteger)blurStyle;

- (void)removeBlurView;

@end
