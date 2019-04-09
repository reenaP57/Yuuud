//
//  NSDictionary+MIExtension.h
//  MI API Example
//
//  Created by mac-0001 on 8/6/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MIExtension)

-(id)valueForJSON:(NSString *)key;
-(NSString *)stringValueForJSON:(NSString *)key;

-(NSNumber *)numberForJson:(NSString *)key;



-(NSNumber *)numberForInt:(NSString *)key;
-(NSNumber *)numberForDouble:(NSString *)key;
-(NSNumber *)numberForFloat:(NSString *)key;

@end
