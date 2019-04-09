//
//  UIViewController+NSFetchedResultsController.m
//  MI API Example
//
//  Created by mac-0001 on 10/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UIViewController+NSFetchedResultsController.h"

#import "Master.h"

@implementation UIViewController (NSFetchedResultsController)

-(FetchedResultsTableDataSource *)setFetchResultsController:(UIView *)table cellIdentifier:(NSString *)cellIdentifier section:(NSInteger)sections row:(NSInteger)rows cell:(CellForRowAtIndexPath)cellBlock
{
    FetchedResultsTableDataSource *dataSource = [[FetchedResultsTableDataSource alloc] initWithTableView:table fetchedResultsController:nil];
    
    [dataSource setNumberOfSections:^NSInteger{
        return sections;
    }];
    
    [dataSource setNumberOfRowsInSection:^NSInteger(id <NSFetchedResultsSectionInfo> info, NSInteger sectionIndex){
         return rows;
     }];

    dataSource.cellForRowAtIndexPath = cellBlock;
    
    [dataSource setCellIdentifier:cellIdentifier];
    
    return dataSource;
}

-(FetchedResultsTableDataSource *)setFetchResultsController:(UIView *)table entity:(NSString *)entitiyName sortDesriptors:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate section:(NSString *)sectionKeyPath cellIdentifier:(NSString *)cellIdentifier batchSize:(NSUInteger)batch cell:(CellForRowAtIndexPath)cellBlock
{
    return [self setFetchResultsController:table entity:entitiyName sortDesriptors:sortDescriptors predicate:predicate section:sectionKeyPath cellIdentifier:cellIdentifier batchSize:batch cell:cellBlock context:nil];
}


-(FetchedResultsTableDataSource *)setFetchResultsController:(UIView *)table entity:(NSString *)entitiyName sortDesriptors:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate section:(NSString *)sectionKeyPath cellIdentifier:(NSString *)cellIdentifier batchSize:(NSUInteger)batch cell:(CellForRowAtIndexPath)cellBlock context:(NSManagedObjectContext *)context
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];
        
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entitiyName];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    [fetchRequest setFetchBatchSize:batch];

    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:sectionKeyPath cacheName:nil];
    
    FetchedResultsTableDataSource *dataSource = [[FetchedResultsTableDataSource alloc] initWithTableView:table fetchedResultsController:fetchedResultsController];
    
    [dataSource setCellIdentifier:cellIdentifier];
    
    dataSource.cellForRowAtIndexPath = cellBlock;
    
    return dataSource;
}

@end
