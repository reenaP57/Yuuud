//
//  NSManagedObjectContext+Helper.m
//  MI API Example
//
//  Created by mac-0001 on 9/19/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "NSManagedObjectContext+Helper.h"

#import "NSObject+NewProperty.h"


@implementation NSManagedObjectContext (Helper)

-(void)save
{
    [self saveInBackground];    
}

-(void)saveInBackground
{
    if ([self hasChanges])
    {
        [self performSafeBlock:^{
            __block NSError *error;
            if (![self save:&error])
                NSLog(@"Error while saving for context %@ == %@ == %@", self, error, [error localizedDescription]);
            else if ([self parentContext])
                [[self parentContext] saveInBackground];
        }];
    }
}

-(void)performSafeBlock:(MIVoidBlock)block
{
    NSThread *thread = [self objectForKey:@"thread"];
    
    if (self.concurrencyType == NSMainQueueConcurrencyType && [NSThread isMainThread])
        block();
    else if (thread == [NSThread currentThread])
        block();
    else
    {
        [self performBlock:^{
            
            if (!thread)
                [self setObject:[NSThread currentThread] forKey:@"thread"];
            
            block();
            
        }];
    }
}



@end
