//
//  UIViewController+NSFetchedResultsController.h
//  MI API Example
//
//  Created by mac-0001 on 10/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FetchedResultsTableDataSource.h"

@interface UIViewController (NSFetchedResultsController)

-(FetchedResultsTableDataSource *)setFetchResultsController:(UIView *)table cellIdentifier:(NSString *)cellIdentifier section:(NSInteger)sections row:(NSInteger)rows cell:(CellForRowAtIndexPath)cellBlock;


-(FetchedResultsTableDataSource *)setFetchResultsController:(UIView *)table entity:(NSString *)entitiyName sortDesriptors:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate section:(NSString *)sectionKeyPath cellIdentifier:(NSString *)cellIdentifier batchSize:(NSUInteger)batch cell:(CellForRowAtIndexPath)cellBlock;

-(FetchedResultsTableDataSource *)setFetchResultsController:(UIView *)table entity:(NSString *)entitiyName sortDesriptors:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate section:(NSString *)sectionKeyPath cellIdentifier:(NSString *)cellIdentifier batchSize:(NSUInteger)batch cell:(CellForRowAtIndexPath)cellBlock context:(NSManagedObjectContext *)context;

@end
