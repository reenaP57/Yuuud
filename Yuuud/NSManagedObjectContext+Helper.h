//
//  NSManagedObjectContext+Helper.h
//  MI API Example
//
//  Created by mac-0001 on 9/19/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "Master.h"

@interface NSManagedObjectContext (Helper)

-(void)save;
-(void)saveInBackground;

-(void)performSafeBlock:(MIVoidBlock)block;

@end
