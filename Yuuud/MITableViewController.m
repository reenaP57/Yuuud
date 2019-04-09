//
//  MITableViewController.m
//  MI API Example
//
//  Created by mac-0001 on 02/03/15.
//  Copyright (c) 2015 MI. All rights reserved.
//

#import "MITableViewController.h"

// Implement Pause/Resume Functionality
// Based on primaryKey - Implement Load More data


@interface MITableViewController ()
{
    FetchedResultsTableDataSource *dataSource;

    
    UIRefreshControl *refreshControl;
}
@end

@implementation MITableViewController

@synthesize shouldDisableRefreshControl,shouldDisableOffsetLoading;

@synthesize query,sectionKeyPath,localDataExpireCondition,refreshQuery,primaryKey;

@synthesize tableView,collectionView,searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (shouldDisableRefreshControl)
    {
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(reloadContent:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:refreshControl];
    }

    
    
    
    [query findAndSaveObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
    }];
    
    
    
    {
        NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:query.fetchRequest managedObjectContext:[[Store sharedInstance] mainManagedObjectContext] sectionNameKeyPath:sectionKeyPath cacheName:nil];
    
        dataSource = [[FetchedResultsTableDataSource alloc] initWithTableView:tableView?tableView:collectionView?collectionView:nil fetchedResultsController:fetchedResultsController];
    }
        // Check and Update FetchedResultsTableDataSource for NSDictionary instead of NSManagedObject
    
}

-(void)reloadContent:(UIRefreshControl *)sender
{
    if (sender.isRefreshing)
        return;
    
    [refreshQuery?refreshQuery:query findAndSaveObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [sender endRefreshing];
    }];
}

@end
