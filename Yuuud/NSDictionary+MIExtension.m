//
//  NSDictionary+MIExtension.m
//  MI API Example
//
//  Created by mac-0001 on 8/6/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "NSDictionary+MIExtension.h"

@implementation NSDictionary (MIExtension)

-(id)valueForJSON:(NSString *)key {
    
    id value = [self valueForKey:key];
    
    if (value == [NSNull null]) {
        value = nil;
    }
    
    return value;
}

-(NSString *)stringValueForJSON:(NSString *)key {
    
    id value = [self valueForKey:key];
    
    if (value == [NSNull null]) {
        value = nil;
    }
    
    
    if (![value isKindOfClass:[NSString class]])
        value = [value stringValue];
    
    
    return value;
}


-(NSNumber *)numberForJson:(NSString *)key
{
    if ([[self objectForKey:key] isKindOfClass:[NSString class]] || [[self objectForKey:key] isKindOfClass:[NSNull class]])
        return [NSNumber numberWithInt:[[self stringValueForJSON:key] intValue]];

    return [self objectForKey:key];
}




-(NSNumber *)numberForInt:(NSString *)key
{
    return [NSNumber numberWithInt:[[self stringValueForJSON:key] intValue]];
}

-(NSNumber *)numberForDouble:(NSString *)key
{
    return [NSNumber numberWithDouble:[[self stringValueForJSON:key] doubleValue]];
}

-(NSNumber *)numberForFloat:(NSString *)key
{
    return [NSNumber numberWithFloat:[[self stringValueForJSON:key] floatValue]];
}



@end
