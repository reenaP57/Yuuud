//
//  NSDate+MIExtension.h
//  VLB
//
//  Created by mac-0001 on 8/4/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TimeInterval(hours) hours*60*60
#define Hours(seconds) (int)(seconds/60/60)

@interface NSDate (MIExtension)

+(NSNumber *)currentTimestamp;
+(NSString *)currentTimestampString;
+(int)currentTimestampInteger;

-(BOOL)isFutureDate;



-(double)startTimestamp;
-(double)endTimestamp;


-(NSDate *)dateByAddingDay:(NSInteger)day;
-(NSDate *)dateByAddingMonth:(NSInteger)month;
-(NSDate *)dateByAddingYear:(NSInteger)year;

@end
