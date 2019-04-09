//
//  MIQuery.m
//  Master
//
//  Created by mac-0001 on 13/03/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import "MIQuery.h"

#import <CoreData/CoreData.h>

//#import <AFNetworking/AFNetworking.h>


typedef NS_ENUM(NSInteger, JsonOperator) {
    JsonOperatorEqual,
    JsonOperatorNotEqual,
    JsonOperatorLessThan,
    JsonOperatorLessThanOrEqualTo,
    JsonOperatorGreaterThan,
    JsonOperatorGreaterThanOrEqualTo,
    JsonOperatorIN,
    JsonOperatorNotIN,
    JsonOperatorLikes,
    JsonOperatorBegins,
    JsonOperatorEnds,
};




#import "PPLoader.h"

@interface MIQuery ()


@property (nonatomic,strong) NSPredicate *predicate;

@property (nonatomic,strong) NSMutableDictionary *_arrConditions;

@property (nonatomic,strong) NSMutableArray *_arrKeys;

@property (nonatomic,strong) NSMutableArray *_arrSortingOrders;

@property (nonatomic,strong) NSMutableArray *_arrSortDescriptors;

@property (nonatomic,strong) NSMutableArray *_arrPredicates;


@end



@implementation MIQuery

@synthesize predicate;

@synthesize className;
@synthesize limit,offset;
@synthesize _arrPredicates,_arrConditions,_arrKeys,_arrSortingOrders,_arrSortDescriptors;

@synthesize dataSource;

+ (MIQuery *)queryWithClassName:(NSString *)className
{
    return [MIQuery queryWithClassName:className predicate:nil];
}

+ (MIQuery *)queryWithClassName:(NSString *)className predicate:(NSPredicate *)predicate
{
    return [[MIQuery alloc] initWithClassName:className predicate:predicate];
}

- (instancetype)initWithClassName:(NSString *)newClassName
{
    return [self initWithClassName:newClassName predicate:nil];
}

- (instancetype)initWithClassName:(NSString *)newClassName predicate:(NSPredicate *)newPredicate
{
    self = [super init];
    if (self) {
        self.className = newClassName;
        self.predicate = newPredicate;
    }
    
    return self;
}

- (NSPredicate *)predicate
{
    return self.predicate;
}

#pragma mark - Data Storage

-(NSMutableArray *)arrPredicates
{
    if (!_arrPredicates)
        _arrPredicates = [[NSMutableArray alloc] init];
    
    return _arrPredicates;
}

-(NSMutableArray *)arrKeys
{
    if (!_arrKeys)
        _arrKeys = [[NSMutableArray alloc] init];
    
    return _arrKeys;
}

-(NSMutableArray *)arrSortingOrders
{
    if (!_arrSortingOrders)
        _arrSortingOrders = [[NSMutableArray alloc] init];
    
    return _arrSortingOrders;
}

-(NSMutableArray *)arrSortDescriptors
{
    if (!_arrSortDescriptors)
        _arrSortDescriptors = [[NSMutableArray alloc] init];
    
    return _arrSortDescriptors;
}

-(NSMutableDictionary *)arrConditions
{
    if (!_arrConditions)
        _arrConditions = [[NSMutableDictionary alloc] init];
    
    return _arrConditions;
}


#pragma mark - Keys To Fetch

- (void)includeKey:(NSString *)key
{

}

- (void)selectKeys:(NSArray *)keys
{
    [self.arrKeys addObjectsFromArray:keys];
}


#pragma mark - Predicates And Conditions

-(NSPredicate *)generatePredicate:(NSString *)predicateFormat forKey:(NSString *)key withData:(id)object
{
    id value = [[NSManagedObject classForKey:self.className] convertValue:object ForAttribute:key];
    return [NSPredicate predicateWithFormat:predicateFormat argumentArray:@[key,value]];
}

-(void)generateJSONPredicateForAttribute:(NSString*)key withValue:(id)value forOperator:(JsonOperator)operator
{
    id object;
    
    NSString *format;
    
    switch (operator)
    {
        case JsonOperatorEqual:
            format = @"%K == %@";
            object = value;
            break;
        case JsonOperatorNotEqual:
            format = @"%K != %@";
            object = @{@"ne":value};
            break;
        case JsonOperatorLessThan:
            format = @"%K < %@";
            object = @{@"lt":value};
            break;
        case JsonOperatorLessThanOrEqualTo:
            format = @"%K <= %@";
            object = @{@"lte":value};
            break;
        case JsonOperatorGreaterThan:
            format = @"%K > %@";
            object = @{@"gt":value};
            break;
        case JsonOperatorGreaterThanOrEqualTo:
            format = @"%K >= %@";
            object = @{@"gte":value};
            break;
        case JsonOperatorIN:
            format = @"%K IN %@";
            object = @{@"in":value};
            break;
        case JsonOperatorNotIN:
            format = @"NOT %K IN %@";
            object = @{@"nin":value};
            break;
        case JsonOperatorLikes:
            format = @"%K CONTAINS[cd] %@";
            object = @{@"like":value};
            break;
        case JsonOperatorBegins:
            format = @"%K BEGINSWITH[cd] %@";
            object = @{@"begin":value};
            break;
        case JsonOperatorEnds:
            format = @"%K ENDSWITH[cd] %@";
            object = @{@"end":value};
            break;
        default:
            break;
    }
    
    
    [self.arrPredicates addObject:[self generatePredicate:format forKey:key withData:value]];
    [self.arrConditions setObject:object forKey:[[NSManagedObject classForKey:self.className] mappingKeyForAttribute:key]];
}






- (void)whereKeyExists:(NSString *)key
{
    
}

- (void)whereKeyDoesNotExist:(NSString *)key
{
    
}


- (void)whereKey:(NSString *)key equalTo:(id)object
{
    [self generateJSONPredicateForAttribute:key withValue:object forOperator:JsonOperatorEqual];

    if ([object isKindOfClass:[NSManagedObject class]])
    {
        // For Json Conditions, Because PHP MYSql using foreign key as relationship
        [self.arrConditions setObject:[object valueForKey:[[object class] primaryKey]] forKey:[[NSManagedObject classForKey:self.className] mappingKeyForAttribute:key]];
    }
}

- (void)whereKey:(NSString *)key notEqualTo:(id)object
{
    [self generateJSONPredicateForAttribute:key withValue:object forOperator:JsonOperatorNotEqual];

    if ([object isKindOfClass:[NSManagedObject class]])
    {
        // For Json Conditions, Because PHP MYSql using foreign key as relationship
        [self.arrConditions setObject:@{@"ne":[object valueForKey:[[object class] primaryKey]]} forKey:[[NSManagedObject classForKey:self.className] mappingKeyForAttribute:key]];
    }
}



- (void)whereKey:(NSString *)key lessThan:(id)object
{
    [self generateJSONPredicateForAttribute:key withValue:object forOperator:JsonOperatorLessThan];
}

- (void)whereKey:(NSString *)key lessThanOrEqualTo:(id)object
{
    [self generateJSONPredicateForAttribute:key withValue:object forOperator:JsonOperatorLessThanOrEqualTo];
}

- (void)whereKey:(NSString *)key greaterThan:(id)object
{
    [self generateJSONPredicateForAttribute:key withValue:object forOperator:JsonOperatorGreaterThan];
}

- (void)whereKey:(NSString *)key greaterThanOrEqualTo:(id)object
{
    [self generateJSONPredicateForAttribute:key withValue:object forOperator:JsonOperatorGreaterThanOrEqualTo];
}



- (void)whereKey:(NSString *)key containedIn:(NSArray *)array
{
    [self generateJSONPredicateForAttribute:key withValue:array forOperator:JsonOperatorIN];
}

- (void)whereKey:(NSString *)key notContainedIn:(NSArray *)array
{
    [self generateJSONPredicateForAttribute:key withValue:array forOperator:JsonOperatorNotIN];
}

- (void)whereKey:(NSString *)key containsAllObjectsInArray:(NSArray *)array
{
    
}


- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex
{
    
}

- (void)whereKey:(NSString *)key matchesRegex:(NSString *)regex modifiers:(NSString *)modifiers
{
    
}

- (void)whereKey:(NSString *)key containsString:(NSString *)substring;
{
    [self generateJSONPredicateForAttribute:key withValue:substring forOperator:JsonOperatorLikes];
}

- (void)whereKey:(NSString *)key hasPrefix:(NSString *)prefix
{
    [self generateJSONPredicateForAttribute:key withValue:prefix forOperator:JsonOperatorBegins];
}

- (void)whereKey:(NSString *)key hasSuffix:(NSString *)suffix
{
    [self generateJSONPredicateForAttribute:key withValue:suffix forOperator:JsonOperatorEnds];
}




#pragma mark - Sorting Orders

-(void)generateSortingOrdersFromKey:(NSString *)key ascengin:(BOOL)ascending
{
    [self.arrSortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascending]];
    [self.arrSortingOrders addObject:[NSString stringWithFormat:@"%@%@",ascending?@"":@"-",[[NSManagedObject classForKey:self.className] mappingKeyForAttribute:key]]];
}


- (void)orderByAscending:(NSString *)key
{
    [self generateSortingOrdersFromKey:key ascengin:YES];
}

- (void)addAscendingOrder:(NSString *)key
{
    [self generateSortingOrdersFromKey:key ascengin:YES];
}

- (void)orderByDescending:(NSString *)key
{
    [self generateSortingOrdersFromKey:key ascengin:NO];
}

- (void)addDescendingOrder:(NSString *)key
{
    [self generateSortingOrdersFromKey:key ascengin:NO];
}

- (void)orderBySortDescriptor:(NSSortDescriptor *)sortDescriptor
{
    [self generateSortingOrdersFromKey:sortDescriptor.key ascengin:sortDescriptor.ascending];
}

- (void)orderBySortDescriptors:(NSArray *)sortDescriptors
{
    for (NSSortDescriptor *sortDescriptor in sortDescriptors)
    {
        [self orderBySortDescriptor:sortDescriptor];
    }
}


#pragma mark - Generate Query

-(NSDictionary *)bodyForRequest
{
    NSMutableDictionary *body = [[NSMutableDictionary alloc] init];
    
    [body setValue:className forKey:@"classes"];
    
    if (_arrConditions)
        [body setObject:_arrConditions forKey:@"where"];

// To-Do Optimize multiple conditions on same key, Ex: lt,lte,gt,gte
// To-Do think on predicate orders, because its matters a lot.
    
    
    if (_arrKeys)
        [body setObject:_arrKeys forKey:@"select"];
    
    if (_arrSortingOrders)
        [body setObject:_arrSortingOrders forKey:@"order"];
    
    if (limit>0)
    {
        [body setObject:[NSNumber numberWithInteger:limit] forKey:@"limit"];
    }
    
    if (offset>0)
    {
        [body setObject:[NSNumber numberWithInteger:offset] forKey:@"skip"];
    }
    
    return body;
}

-(NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([NSManagedObject classForKey:self.className])];
    
    if (_arrPredicates)
        [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:_arrPredicates]];
    
    //    [request setPropertiesToFetch:arrKeys];
    
    if (_arrSortDescriptors)
        [request setSortDescriptors:_arrSortDescriptors];
    
    
    // This will set first time api limit as batch size in fetchedresultscontroller
    if (limit>0)
        [request setFetchBatchSize:limit];
    
    // This will set first time api offset as fetchoffset in fetchedresultscontroller
    [request setFetchOffset:offset];
    
    return request;
}


#pragma mark - Perform Query

- (void)findObjects:(MIArrayResultBlock)block
{
    [[PPLoader sharedLoader] ShowHudLoaderWithText:@"Loading..."];
    
    [self findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [[PPLoader sharedLoader] HideHudLoader];
        
        if (block)
            block(objects,error);
    }];
}

- (void)findObjectsInBackground
{
    [self findObjectsInBackgroundWithBlock:nil];
}

- (void)findObjectsInBackgroundWithBlock:(MIArrayResultBlock)block
{
    NSAssert(NSClassFromString(@"AFHTTPSessionManager"), @"Please add AFNetworking Framework");
    
    
    if (self.dataSource)
        [self.dataSource loadData];
    
    
    //    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:@"http://www.magentodevelopments.com/api_structure/api/"]];
    //
    //    NSMutableDictionary *dicParameters = [[NSMutableDictionary alloc] initWithDictionary:[self bodyForRequest]];
    //
    //    [dicParameters setValue:@"globalselect" forKey:@"tag"];
    //    [dicParameters setValue:@"1" forKey:@"version"];
    //    [dicParameters setValue:@"1" forKey:@"useragent"];
    //
    //    [manager POST:@"" parameters:dicParameters success:^(NSURLSessionDataTask *task, id responseObject) {
    //
    //        if (block)
    //            block(responseObject,nil);
    //
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //
    //        if (block)
    //            block(nil,error);
    //
    //    }];
}


- (void)findAndSaveObjects:(MIArrayResultBlock)block
{
    [[PPLoader sharedLoader] ShowHudLoaderWithText:@"Loading..."];
    
    [self findAndSaveObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [[PPLoader sharedLoader] HideHudLoader];
        
        if (block)
            block(objects,error);
    }];
}

- (void)findAndSaveObjectsInBackground
{
    [self findAndSaveObjectsInBackgroundWithBlock:nil];
}

- (void)findAndSaveObjectsInBackgroundWithBlock:(MIArrayResultBlock)block
{
    [self findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        // To-Do Remove "valueForKey:@"data"" when php team updates api
        
        [[NSManagedObject classForKey:self.className] enumerateAndSaveObjects:[objects isKindOfClass:[NSArray class]]?objects:[NSArray arrayWithArray:[objects valueForKey:@"data"]]];
        
        if (block)
            block(objects,error);
    }];
}


- (void)countObjects:(MIArrayResultBlock)block
{
    [[PPLoader sharedLoader] ShowHudLoaderWithText:@"Loading..."];
    
    [self countObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [[PPLoader sharedLoader] HideHudLoader];
        
        if (block)
            block(objects,error);
    }];
}

- (void)countObjectsInBackground
{
    [self countObjectsInBackgroundWithBlock:nil];
}

- (void)countObjectsInBackgroundWithBlock:(MIArrayResultBlock)block
{
    NSLog(@"Not Implemented Yet.");
}


#pragma mark - MIFetchedResultsControler Integration

-(void)setFetchedResultsTableDataSource:(FetchedResultsTableDataSource *)datasource
{
    self.dataSource = datasource;
}

- (void)loadSaveAndDisplayOnTableView:(UITableView *)tableview usingCellIdentifier:(NSString *)cellIdentifier onCell:(CellForRowAtIndexPath)cell
{
// To-Do think on setRealtionshipKeyPaths setting from other properties.
    
    
    self.dataSource = [[FetchedResultsTableDataSource alloc] initWithTableView:tableview fetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[[Store sharedInstance] mainManagedObjectContext] sectionNameKeyPath:nil cacheName:nil]];
    [self.dataSource setCellIdentifier:cellIdentifier];
    self.dataSource.cellForRowAtIndexPath = cell;
    
    
    [self findAndSaveObjectsInBackground];
}

- (void)loadSaveAndNotify:(MIVoidBlock)block withUpdates:(NSFetchedResultsControllerDelegateBlock)changedObjects
{
    self.dataSource = [[FetchedResultsTableDataSource alloc] initWithBlock:block updates:changedObjects fetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[[Store sharedInstance] mainManagedObjectContext] sectionNameKeyPath:nil cacheName:nil]];
    
    [self findAndSaveObjectsInBackground];
}


#pragma mark - Perform Action on Server Call

- (void)cancel
{
    
}

- (void)pause
{
    
}

- (void)resume
{
    
}


@end
