//
//  NSObject+Extension.h
//  Master
//
//  Created by mac-0001 on 20/05/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SHCMulticastDelegate.h"

#import "Master.h"

@interface NSObject (Extension)


#pragma mark - Multiple Delegate

- (SHCMulticastDelegate *)multicastDelegate;
- (SHCMulticastDelegate *)multicastDatasource;

-(void)addDelegate:(id)delegate;
-(void)addDataSource:(id)datasource;


#pragma mark - Other

-(void)performBlockOnMainThread:(MIVoidBlock)block afterDelay:(int)delay;
-(void)performBlockInBackground:(MIVoidBlock)block afterDelay:(int)delay;

-(void)performBlockOnMainThread:(MIVoidBlock)block;
-(void)performBlock:(MIVoidBlock)block;
-(void)performBlockWithHighPriority:(MIVoidBlock)block;
-(void)performBlockWithLowPriority:(MIVoidBlock)block;

@end
