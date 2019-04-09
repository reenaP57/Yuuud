//
//  NSFetchedResultsController+Extension.m
//  Master
//
//  Created by mac-0001 on 25/06/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import "NSFetchedResultsController+Extension.h"

@implementation NSFetchedResultsController (Extension)

-(NSUInteger)objectsCount
{
    if (self.sections.count>1)
        NSAssert(nil, @"You hav multiple sections, Please use \"objectsCountInSection:\"");
    
    return [self objectsCountInSection:0];
}

-(NSUInteger)objectsCountInSection:(NSUInteger)section
{
    if (self.sections.count==0)
        return 0;

    return [[self.sections objectAtIndex:section] numberOfObjects];
}


@end
