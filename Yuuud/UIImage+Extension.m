//
//  UIImage+Extensiom.m
//  Master
//
//  Created by mac-0001 on 28/02/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import "UIImage+Extension.h"
#import "Master.h"
#import "NSObject+NewProperty.h"

@interface NSObject (_UIAssetManager)
- (UIImage *) imageNamed:(NSString *)name;
@end


@implementation UIImage (Extension)

// Defination of some fucntions Used in KeyboardManager Extension

+(UIImage *)leftImage
{
    if (IS_Ios8)
        return [UIImage imageNamed:@"UIButtonBarArrowLeft.png" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.uikit.Artwork"] compatibleWithTraitCollection:nil];
    else
    {
        id assetManager = [[NSClassFromString(@"_UIAssetManager") alloc] performSelectorFromStringWithReturnObject:@"initWithName:inBundle:idiom:" withObject:@"UIKit_NewArtwork" withObject:[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] withObject:nil];
        
        return [assetManager imageNamed:@"UIButtonBarArrowLeft.png"];
    }
    
    return nil;
}

+(UIImage *)rightImage
{
    if (IS_Ios8)
        return [UIImage imageNamed:@"UIButtonBarArrowRight.png" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.uikit.Artwork"] compatibleWithTraitCollection:nil];
    else
    {
        id assetManager = [[NSClassFromString(@"_UIAssetManager") alloc] performSelectorFromStringWithReturnObject:@"initWithName:inBundle:idiom:" withObject:@"UIKit_NewArtwork" withObject:[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] withObject:nil];
        
        return [assetManager imageNamed:@"UIButtonBarArrowRight.png"];
    }

    return nil;
}

+(UIImage *)backImage
{
    if (IS_Ios8)
        return [UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png" inBundle:[NSBundle bundleWithIdentifier:@"com.apple.uikit.Artwork"] compatibleWithTraitCollection:nil];
    else
    {
        id assetManager = [[NSClassFromString(@"_UIAssetManager") alloc] performSelectorFromStringWithReturnObject:@"initWithName:inBundle:idiom:" withObject:@"UIKit_NewArtwork" withObject:[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] withObject:nil];
        
        return [assetManager imageNamed:@"UINavigationBarBackIndicatorDefault.png"];
    }
    
    return nil;
}

+(UIImage *)safariGlymphImage
{
    if (IS_Ios8)
        return 	[UIImage imageNamed:@"SafariGlyph.png" inBundle:[NSBundle bundleWithPath:[[[[NSProcessInfo processInfo] environment] objectForKey:@"IPHONE_SIMULATOR_ROOT"] ?: @"/" stringByAppendingPathComponent:@"Applications/MobileSafari.app"]] compatibleWithTraitCollection:nil];
    
    return nil;
}


+(UIImage *)preferencesImage:(NSString *)image
{
    if (IS_Ios8)
        return [UIImage imageNamed:image inBundle:[NSBundle bundleWithPath:[[[[NSProcessInfo processInfo] environment] objectForKey:@"IPHONE_SIMULATOR_ROOT"] ?: @"/" stringByAppendingPathComponent:@"Applications/Preferences.app"]]  compatibleWithTraitCollection:nil];
    

    return nil;
}

@end

