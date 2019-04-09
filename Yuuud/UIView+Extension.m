//
//  UIView+Extension.m
//  Master
//
//  Created by mac-0001 on 08/12/14.
//  Copyright (c) 2014 mac-0001. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

+ (void)addBorder:(UIView *)view withWidth:(BorderWidth)width withRadius:(BorderRadius)radius
{
    [self addBorder:view withWidth:width withRadius:radius withColour:[UIColor blackColor]];
}

+ (void)addBorder:(UIView *)view withWidth:(BorderWidth)width withColour:(UIColor *)colour
{
    [self addBorder:view withWidth:width withRadius:BORDER_RADIUS withColour:colour];
}

+ (void)addBorder:(UIView *)view withWidth:(BorderWidth)width withRadius:(BorderRadius)radius withColour:(UIColor *)colour
{
    [[view layer] setBorderColor:[colour CGColor]];
    [[view layer] setBorderWidth:width];
    [[view layer] setCornerRadius:radius];
}

+ (void)addShadow:(UIView *)view withRadius:(BorderRadius)radius withOffset:(CGSize)offset withColour:(UIColor *)colour withOpacity:(float)opacity
{
    [[view layer] setShadowRadius:radius];
    [[view layer] setShadowOffset:offset];
    [[view layer] setShadowColor:[colour CGColor]];
    [[view layer] setShadowOpacity:opacity];
}

+ (void)addUnderline:(UIView *)view
{
    [self addUnderline:view withColour:[UIColor blackColor]];
}


+ (void)addUnderline:(UIView *)view withColour:(UIColor *)colour
{
    [self addUnderline:view withThickness:UNDERLINE_THIN withColour:colour];
}

+ (void)addUnderline:(UIView*)view withThickness:(UnderlineWidth)thickness
{
    [self addUnderline:view withThickness:thickness withColour:[UIColor lightGrayColor]];
}

+ (void)addUnderline:(UIView *)view withThickness:(UnderlineWidth)thickness withColour:(UIColor*)colour
{
    CGSize mainViewSize = view.bounds.size;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mainViewSize.height-thickness, mainViewSize.width, thickness)];
    
    bottomView.opaque = YES;
    bottomView.backgroundColor = colour;
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    [view addSubview:bottomView];
}

+ (void)addOverline:(UIView *)view withThickness:(UnderlineWidth)thickness withColour:(UIColor*)colour
{
    CGSize mainViewSize = view.bounds.size;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainViewSize.width, thickness)];
    
    bottomView.opaque = YES;
    bottomView.backgroundColor = colour;
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [view addSubview:bottomView];
}

+ (void)addRightBorder:(UIView*)view withColour:(UIColor*)colour
{
    [self addRightBorder:view withThickness:BORDER_WIDTH withColour:colour];
}

+ (void)addRightBorder:(UIView*)view withThickness:(BorderWidth)thickness
{
    [self addRightBorder:view withThickness:thickness withColour:[UIColor lightGrayColor]];
}

+ (void)addRightBorder:(UIView*)view withThickness:(BorderWidth)thickness withColour:(UIColor*)colour
{
    CGSize mainViewSize = view.bounds.size;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(mainViewSize.width-thickness, 0, thickness, mainViewSize.height)];
    
    rightView.opaque = YES;
    rightView.backgroundColor = colour;
    rightView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    
    [view addSubview:rightView];
}

+ (void)addLeftBorder:(UIView*)view withColour:(UIColor*)colour
{
    [self addLeftBorder:view withThickness:BORDER_WIDTH withColour:colour];
}

+ (void)addLeftBorder:(UIView*)view withThickness:(BorderWidth)thickness
{
    [self addLeftBorder:view withThickness:thickness withColour:[UIColor lightGrayColor]];
}

+ (void)addLeftBorder:(UIView*)view withThickness:(BorderWidth)thickness withColour:(UIColor*)colour
{
    CGSize mainViewSize = view.bounds.size;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, thickness, mainViewSize.height)];
    
    leftView.opaque = YES;
    leftView.backgroundColor = colour;
    leftView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    [view addSubview:leftView];
}


+ (void)fillButton:(UIButton*)button
{
    [self fillButton:button withColour:[UIColor blackColor]];
}

+ (void)fillButton:(UIButton*)button withColour:(UIColor*)colour
{
    [self fillButton:button withWidth:BORDER_WIDTH_MEDIUM withRadius:BORDER_RADIUS withColour:colour];
}

+ (void)fillButton:(UIButton*)button withWidth:(BorderWidth)width withRadius:(BorderRadius)radius
{
    [self fillButton:button withWidth:width withRadius:radius withColour:[UIColor blackColor]];
}

+ (void)fillButton:(UIButton*)button withWidth:(BorderWidth)width withRadius:(BorderRadius)radius withColour:(UIColor *)colour
{
    [button setBackgroundColor:colour];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addBorder:button withWidth:width withRadius:radius withColour:colour];
    
}


@end
