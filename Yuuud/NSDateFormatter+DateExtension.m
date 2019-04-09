//
//  NSDateFormatter+DateExtension.m
//  Only Appointment
//
//  Created by mac-00015 on 8/4/15.
//  Copyright (c) 2015 mac-0009. All rights reserved.
//

#import "NSDateFormatter+DateExtension.h"

@implementation NSDateFormatter (DateExtension)

+ (id)initWithDateFormat:(NSString *)dateFormat
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        
//TODO: Identify not crashing in 24 hours  and 12 hours format as well
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];

        NSLog(@"First time allocated");
    });

    [dateFormatter setDateFormat:dateFormat];
    return dateFormatter;
}



@end
