//
//  UIView+Extension.h
//  Master
//
//  Created by mac-0001 on 08/12/14.
//  Copyright (c) 2014 mac-0001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BorderWidth)
{
    BORDERLESS = 0,
    BORDER_WIDTH_THINNEST = 1,
    BORDER_WIDTH_THIN = 2,
    BORDER_WIDTH_MEDIUM = 4,
    BORDER_WIDTH_THICK = 15,
    BORDER_WIDTH = 6
};

typedef NS_ENUM(NSInteger, BorderRadius)
{
    BORDER_RADIUS_NONE = 0,
    BORDER_RADIUS_ROUNDED = 15,
    BORDER_RADIUS_SMOOTH = 50,
    BORDER_RADIUS_CIRCLE = 60,
    BORDER_RADIUS_ROUNDER = 22,
    BORDER_RADIUS = 15,
    BORDER_RADIUS_SMALL = 10
};

typedef NS_ENUM(NSInteger, UnderlineWidth)
{
    UNDERLINE_NONE = 0,
    UNDERLINE_THINEST = 1,
    UNDERLINE_THIN = 2,
    UNDERLINE_THICK = 5
};

@interface UIView (Extension)

+(void)addBorder:(UIView *)view withWidth:(BorderWidth)width withRadius:(BorderRadius)radius;
+(void)addBorder:(UIView *)view withWidth:(BorderWidth)width withColour:(UIColor *)colour;
+(void)addBorder:(UIView *)view withWidth:(BorderWidth)width withRadius:(BorderRadius)radius withColour:(UIColor *)colour;

+(void)fillButton:(UIButton*)button;
+(void)fillButton:(UIButton*)button withColour:(UIColor*)colour;
+(void)fillButton:(UIButton*)button withWidth:(BorderWidth)width withRadius:(BorderRadius)radius;
+(void)fillButton:(UIButton*)button withWidth:(BorderWidth)width withRadius:(BorderRadius)radius withColour:(UIColor *)colour;

+(void)addShadow:(UIView *)view withRadius:(BorderRadius)radius withOffset:(CGSize)offset withColour:(UIColor *)colour withOpacity:(float)opacity;

+(void)addUnderline:(UIView*)view;

+(void)addUnderline:(UIView*)view withColour:(UIColor*)colour;
+(void)addUnderline:(UIView*)view withThickness:(UnderlineWidth)thickness;
+(void)addUnderline:(UIView*)view withThickness:(UnderlineWidth)thickness withColour:(UIColor *)colour;

+(void)addOverline:(UIView *)view withThickness:(UnderlineWidth)thickness withColour:(UIColor*)colour;

+(void)addRightBorder:(UIView*)view withColour:(UIColor*)colour;
+(void)addRightBorder:(UIView*)view withThickness:(BorderWidth)thickness;
+(void)addRightBorder:(UIView*)view withThickness:(BorderWidth)thickness withColour:(UIColor *)colour;

+(void)addLeftBorder:(UIView*)view withColour:(UIColor*)colour;
+(void)addLeftBorder:(UIView*)view withThickness:(BorderWidth)thickness;
+(void)addLeftBorder:(UIView*)view withThickness:(BorderWidth)thickness withColour:(UIColor *)colour;

@end
