//
//  NSObject+Extension.m
//  Master
//
//  Created by mac-0001 on 20/05/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import "NSObject+Extension.h"
#import "NSObject+NewProperty.h"


static NSString *const MULTICASTDELEGATE = @"MULTICASTDELEGATE";
static NSString *const MULTICASTDATASOURCE = @"MULTICASTDATASOURCE";


@implementation NSObject (Extension)

#pragma mark - Multiple Delegate

- (SHCMulticastDelegate *)multicastDelegate
{
    id multicastDelegate = [self objectForKey:MULTICASTDELEGATE];
    if (multicastDelegate == nil) {
        multicastDelegate = [[SHCMulticastDelegate alloc] init];

        [self setObject:multicastDelegate forKey:MULTICASTDELEGATE];
    }
    
    return multicastDelegate;
}

- (SHCMulticastDelegate *)multicastDatasource
{
    id multicastDatasource = [self objectForKey:MULTICASTDATASOURCE];
    if (multicastDatasource == nil) {
        multicastDatasource = [[SHCMulticastDelegate alloc] init];
        
        [self setObject:multicastDatasource forKey:MULTICASTDATASOURCE];
    }
    
    return multicastDatasource;
}


-(void)addDelegate:(id)delegate
{
    [self.multicastDelegate addDelegate:delegate];

    UITextField *text = (UITextField *) self;
    text.delegate = self.multicastDelegate;
}

-(void)addDataSource:(id)datasource
{
    [self.multicastDatasource addDelegate:datasource];
    UITableView *text = (UITableView *) self;
    text.dataSource = self.multicastDatasource;
}



#pragma mark - Other

-(void)performBlockOnMainThread:(MIVoidBlock)block afterDelay:(int)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), GCDMainThread, ^{
        block();
    });
}

-(void)performBlockInBackground:(MIVoidBlock)block afterDelay:(int)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), GCDBackgroundThread, ^{
        block();
    });
}

-(void)performBlockOnMainThread:(MIVoidBlock)block
{
    dispatch_async(GCDMainThread,^{
        block();
    });
}

-(void)performBlock:(MIVoidBlock)block
{
    dispatch_async(GCDBackgroundThread,^{
        block();
    });
}

-(void)performBlockWithHighPriority:(MIVoidBlock)block
{
    dispatch_async(GCDBackgroundThreadHighPriority,^{
        block();
    });
}

-(void)performBlockWithLowPriority:(MIVoidBlock)block
{
    dispatch_async(GCDBackgroundThreadLowPriority,^{
        block();
    });
}


@end
