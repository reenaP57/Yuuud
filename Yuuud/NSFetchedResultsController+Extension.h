//
//  NSFetchedResultsController+Extension.h
//  Master
//
//  Created by mac-0001 on 25/06/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (Extension)

-(NSUInteger)objectsCount;
-(NSUInteger)objectsCountInSection:(NSUInteger)section;

@end
