//
//  MIQuery.h
//  Master
//
//  Created by mac-0001 on 13/03/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#import "Master.h"

@interface MIQuery : NSObject

+ (MIQuery *)queryWithClassName:(NSString *)className;
+ (MIQuery *)queryWithClassName:(NSString *)className predicate:(NSPredicate *)predicate; // It is not implemented yet.

- (instancetype)initWithClassName:(NSString *)newClassName;
- (instancetype)initWithClassName:(NSString *)newClassName predicate:(NSPredicate *)predicate;

@property (nonatomic, strong) NSString *className;
- (NSPredicate *)predicate;


@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;







- (void)includeKey:(NSString *)key;
- (void)selectKeys:(NSArray *)keys;


- (void)whereKeyExists:(NSString *)key;
- (void)whereKeyDoesNotExist:(NSString *)key;
- (void)whereKey:(NSString *)key equalTo:(id)object;
- (void)whereKey:(NSString *)key notEqualTo:(id)object;
- (void)whereKey:(NSString *)key lessThan:(id)object;
- (void)whereKey:(NSString *)key lessThanOrEqualTo:(id)object;
- (void)whereKey:(NSString *)key greaterThan:(id)object;
- (void)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object;
- (void)whereKey:(NSString *)key containedIn:(NSArray *)array;
- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array;
- (void)whereKey:(NSString *)key containsAllObjectsInArray:(NSArray *)array;
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex;
- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex modifiers:(NSString *)modifiers;
- (void)whereKey:(NSString *)key containsString:(NSString *)substring;;
- (void)whereKey:(NSString *)key hasPrefix:(NSString *)prefix;
- (void)whereKey:(NSString *)key hasSuffix:(NSString *)suffix;





- (void)orderByAscending:(NSString *)key;
- (void)addAscendingOrder:(NSString *)key;
- (void)orderByDescending:(NSString *)key;
- (void)addDescendingOrder:(NSString *)key;
- (void)orderBySortDescriptor:(NSSortDescriptor *)sortDescriptor;
- (void)orderBySortDescriptors:(NSArray *)sortDescriptors;






@property (nonatomic,strong) FetchedResultsTableDataSource *dataSource;

-(NSFetchRequest *)fetchRequest;

- (void)findObjects:(MIArrayResultBlock)block;
- (void)findObjectsInBackground;
- (void)findObjectsInBackgroundWithBlock:(MIArrayResultBlock)block;

- (void)findAndSaveObjects:(MIArrayResultBlock)block;
- (void)findAndSaveObjectsInBackground;
- (void)findAndSaveObjectsInBackgroundWithBlock:(MIArrayResultBlock)block;

- (void)countObjects:(MIArrayResultBlock)block;
- (void)countObjectsInBackground;
- (void)countObjectsInBackgroundWithBlock:(MIArrayResultBlock)block;




-(void)setFetchedResultsTableDataSource:(FetchedResultsTableDataSource *)datasource;
- (void)loadSaveAndDisplayOnTableView:(UITableView *)tableview usingCellIdentifier:(NSString *)cellIdentifier onCell:(CellForRowAtIndexPath)cell;
- (void)loadSaveAndNotify:(MIVoidBlock)block withUpdates:(NSFetchedResultsControllerDelegateBlock)changedObjects;


@end
