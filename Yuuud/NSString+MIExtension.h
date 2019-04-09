//
//  NSString+MIExtension.h
//  VLB
//
//  Created by mac-0001 on 7/16/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MIExtension)


-(NSString *)bundlePath;
-(NSString *)stringWithFirstLetterCapital;
-(NSURL *)bundleURLForImage;


- (NSURL *)urlForString;

- (void)deleteFileFromPath;



-(BOOL)isServerURL;
-(BOOL)isLocalURL;
-(BOOL)isValidUrl;
-(BOOL)isValidEmailAddress;
-(BOOL)isBlankValidationPassed;
-(BOOL)isNonZeroNumber;


@end
