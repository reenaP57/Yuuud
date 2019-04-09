//
//  NSString+MIExtension.m
//  VLB
//
//  Created by mac-0001 on 7/16/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "NSString+MIExtension.h"

@implementation NSString (MIExtension)

#pragma mark -- Path and URL


- (NSString *)bundlePath
{
    return [[NSBundle mainBundle] pathForResource:self ofType:nil];
}

-(NSURL *)bundleURLForImage
{
    return [[self bundlePath] urlForString];
}

-(BOOL)isServerURL
{
    if ([self rangeOfString:@"http:"].location==NSNotFound && [self rangeOfString:@"https:"].location==NSNotFound)
        return NO;
    else
        return YES;
}

-(BOOL)isLocalURL
{
    if ([self isServerURL])
        return NO;
    else
        return YES;
}

- (NSURL *)urlForString
{
    if ([self isServerURL])
        return [NSURL URLWithString:self];
    else
        return [NSURL fileURLWithPath:self];
}

- (void)deleteFileFromPath
{
    NSError *error = nil;
    if(![[NSFileManager defaultManager] removeItemAtPath:self error:&error])
    {
        NSLog(@"File Delete failed:%@",error);
    }
    else
    {
        NSLog(@"File removed: %@",self);
    }
}



#pragma mark -- Validations


-(BOOL)isValidEmailAddress
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSInteger num_matches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    if (num_matches == 1)
        return YES;
    else
        return NO;
}

-(BOOL)isBlankValidationPassed
{
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0)
        return YES;
    
    return NO;
}

-(BOOL)isNonZeroNumber
{
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0)
    {
        if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue]>0)
            return YES;
        else
            return NO;
    }
    
    return NO;
}

- (BOOL)isValidUrl
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self];
}

#pragma mark -- Other

-(NSString *)stringWithFirstLetterCapital
{
    return [NSString stringWithFormat:@"%@%@",[[self substringToIndex:1] uppercaseString],[self substringFromIndex:1]];
}

@end
