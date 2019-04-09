//
//  UIImage+Extensiom.h
//  Master
//
//  Created by mac-0001 on 28/02/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+(UIImage *)leftImage;
+(UIImage *)rightImage;
+(UIImage *)backImage;

+(UIImage *)safariGlymphImage;
+(UIImage *)preferencesImage:(NSString *)image;

@end
