//
//  NSDate+MIExtension.m
//  VLB
//
//  Created by mac-0001 on 8/4/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "NSDate+MIExtension.h"

@implementation NSDate (MIExtension)

+(NSNumber *)currentTimestamp
{
    return [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
}

+(NSString *)currentTimestampString
{
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
}

+(int)currentTimestampInteger
{
    return [[NSDate date] timeIntervalSince1970];
}

-(BOOL)isFutureDate
{
    if ([self startTimestamp]>[[NSDate currentTimestamp] doubleValue])
        return YES;
    else
        return NO;
}


-(double)startTimestamp
{
    return [self timestampForStart:YES];
}

-(double)endTimestamp
{
    return [self timestampForStart:NO];
}

-(double)timestampForStart:(BOOL)start
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];

        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    });

    
    NSString *dateString = [dateFormatter stringFromDate:self];
    

    
    static NSDateFormatter *dateFormatter2;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
        [dateFormatter2 setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });

    
    NSDate *startDate = [dateFormatter2 dateFromString:[dateString stringByAppendingString:start?@" 00:00:00":@" 23:59:59"]];
    
    return [startDate timeIntervalSince1970];
}



-(NSDate *)dateByAddingDay:(NSInteger)day
{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:offsetComponents.day+day];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

-(NSDate *)dateByAddingMonth:(NSInteger)month
{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:offsetComponents.month+month];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

-(NSDate *)dateByAddingYear:(NSInteger)year
{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:year];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

@end
