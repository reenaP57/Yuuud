//
//  MITableViewController.h
//  MI API Example
//
//  Created by mac-0001 on 02/03/15.
//  Copyright (c) 2015 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Master.h"

#import "MIQuery.h"

@interface MITableViewController : UIViewController
{
    
}

@property (nonatomic,assign) BOOL shouldDisableRefreshControl;
@property (nonatomic,assign) BOOL shouldDisableOffsetLoading;


@property (nonatomic,strong) MIQuery *query;
@property (nonatomic,strong) MIQuery *refreshQuery;


@property (nonatomic,strong) NSPredicate *localDataExpireCondition;
@property (nonatomic,strong) NSString *sectionKeyPath;
@property (nonatomic,strong) NSString *primaryKey;



@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UISearchBar *searchBar;


@end



// To-Do Add properties for fetchredresutltscontroller
// To-Do Add properties for searchbar
// To-Do add properties for SegmentedControl

// To-Do Add properties for Pull To Refresh
// To-Do Add properties for loadMore Data