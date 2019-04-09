//
// Created by chris on 6/16/13.
//

#import "FetchedResultsTableDataSource.h"

#import "Master.h"



#import "NSObject+NewProperty.h"

@interface UITableViewCell (Extension)

-(void)setItem:(NSManagedObject *)item;
-(NSManagedObject *)item;

@end

@implementation UITableViewCell (Extension)

-(void)setItem:(NSManagedObject *)item
{
    [self setObject:item forKey:@"item"];
}

-(NSManagedObject *)item
{
    return [self objectForKey:@"item"];
}

@end


@interface UICollectionViewCell (Extension)

-(void)setItem:(NSManagedObject *)item;
-(NSManagedObject *)item;

@end

@implementation UICollectionViewCell (Extension)

-(void)setItem:(NSManagedObject *)item
{
    [self setObject:item forKey:@"item"];
}

-(NSManagedObject *)item
{
    return [self objectForKey:@"item"];
}

@end








@interface FetchedResultsTableDataSource () <NSFetchedResultsControllerDelegate>
{
    NSMutableArray *arrayRelationShipKeyPaths;
    
    BOOL isLoaded;
    
    
    NSMutableArray *_arrayInserted;
    NSMutableArray *_arrayUpdated;
    NSMutableArray *_arrayDeleted;
}


@property (nonatomic, strong) MIVoidBlock updaeCallback;
@property (nonatomic, strong) NSFetchedResultsControllerDelegateBlock updateBlock;



@property (nonatomic, strong) UITableView *tableViewDataSource;
@property (nonatomic, strong) UICollectionView *collectionViewDataSource;
@end

@implementation FetchedResultsTableDataSource

@synthesize fetchedResultsController;

@synthesize tableViewDataSource,collectionViewDataSource;
@synthesize numberOfSections,numberOfRowsInSection;
@synthesize heightForHeaderInSection,heightForFooterInSection,heightForRowAtIndexPath,heightForItemAtIndexPath;
@synthesize identifierForHeaderInSection,identifierForFooterInSection,identifierForRowAtIndexPath;
@synthesize cellForRowAtIndexPath,cellForRowAtIndexPathWithSection,viewForHeaderInSection,viewForFooterInSection;
@synthesize cellIdentifier,sectionHeaderIdentifier,sectionFooterIdentifier;
@synthesize sectionHeaderSize,sectionFooterSize;
@synthesize indexingEnabled;

@synthesize updaeCallback;
@synthesize updateBlock;

- (id)initWithTableView:(UIView *)tableView fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController withUpdateBlock:(NSFetchedResultsControllerDelegateBlock)updates withNotifyBlock:(MIVoidBlock)notifyBlock
{
    self = [super init];
    if(self)
    {
        if (tableView)
        {
            if ([tableView isKindOfClass:[UITableView class]])
            {
                self.tableViewDataSource = (UITableView *) tableView;
                
                if (self.tableViewDataSource.rowHeight==0 && self.tableViewDataSource.estimatedRowHeight==0)
                    [self.tableViewDataSource setEstimatedRowHeight:44];
                if (self.tableViewDataSource.sectionHeaderHeight==0 && self.tableViewDataSource.estimatedSectionHeaderHeight==0)
                    [self.tableViewDataSource setEstimatedSectionHeaderHeight:30];
            }
            else if ([tableView isKindOfClass:[UICollectionView class]])
                self.collectionViewDataSource = (UICollectionView *) tableView;
        }
        
        self.updateBlock = updates;
        self.updaeCallback = notifyBlock;

        if (aFetchedResultsController)
        {
            self.fetchedResultsController = aFetchedResultsController;
            [self.fetchedResultsController addDelegate:self];
        }
        
    }
    return self;
}

- (id)initWithTableView:(UIView *)tableView fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController
{
    return [self initWithTableView:tableView fetchedResultsController:aFetchedResultsController withUpdateBlock:nil withNotifyBlock:nil];
}

- (id)initWithBlock:(MIVoidBlock)block updates:(NSFetchedResultsControllerDelegateBlock)updates fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController
{
    return [self initWithTableView:nil fetchedResultsController:aFetchedResultsController withUpdateBlock:updates withNotifyBlock:block];
}

- (id)initWithBlock:(MIVoidBlock)block fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController
{
    return [self initWithBlock:block updates:nil fetchedResultsController:aFetchedResultsController];
}




-(void)dealloc
{
    self.fetchedResultsController = nil;
    self.tableViewDataSource = nil;
    self.collectionViewDataSource = nil;
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
    if (aSelector == @selector(tableView:heightForRowAtIndexPath:))
    {
        if (self.heightForRowAtIndexPath || self.heightForItemAtIndexPath)
            return YES;
        else
            return NO;
    }
    else if (aSelector == @selector(tableView:heightForHeaderInSection:))
    {
        if (self.heightForHeaderInSection)
            return YES;
        else
            return NO;
    }
    else if (aSelector == @selector(tableView:heightForFooterInSection:))
    {
        if (self.heightForFooterInSection)
            return YES;
        else
            return NO;
    }
    else if (aSelector == @selector(tableView:sectionForSectionIndexTitle:atIndex:) || aSelector == @selector(sectionIndexTitlesForTableView:))
    {
        if (self.indexingEnabled)
            return YES;
        else
            return NO;
    }
    else if (aSelector == @selector(tableView:viewForHeaderInSection:))
    {
        if (self.viewForHeaderInSection)
            return YES;
        else
            return NO;
    }
    else if (aSelector == @selector(tableView:viewForFooterInSection:))
    {
        if (self.viewForFooterInSection)
            return YES;
        else
            return NO;
    }
    else if (aSelector == @selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:))
    {
        if (self.updateBlock)
            return YES;
        else
            return NO;
    }

    return [super respondsToSelector:aSelector];
}

#pragma mark - NSFetchedResultscontroller Additions

-(NSMutableArray *)arrayRelationShipKeyPaths
{
    if (!arrayRelationShipKeyPaths)
        arrayRelationShipKeyPaths = [[NSMutableArray alloc] init];
        
    return arrayRelationShipKeyPaths;
}

-(void)setRelationshipKeyPathsWhichShouldReloadData:(NSArray *)keyPaths
{
    [self setRelationshipKeyPathsWhichShouldReloadSections:keyPaths shouldReloadData:NO];
}

-(void)setRelationshipKeyPathWhichShouldReloadPredicate:(NSArray *)predicateKeyPaths
{
    [self setRelationshipKeyPathsWhichShouldReloadSections:predicateKeyPaths shouldReloadData:YES];
}

-(void)setRelationshipKeyPathWhichShouldReloadSortDescriptors:(NSArray *)sortDescriptors
{
    NSMutableArray *keyPaths = [[NSMutableArray alloc] init];
    
    for (NSSortDescriptor *sortDescriptor in sortDescriptors)
    {
        if ([[sortDescriptor.key componentsSeparatedByString:@"."] count]>1)
            [keyPaths addObject:sortDescriptor.key];
    }
    
    [self setRelationshipKeyPathsWhichShouldReloadSections:keyPaths shouldReloadData:YES];
}

-(void)setRelationshipKeyPathsWhichShouldReloadSections:(NSArray *)sectionKeyPaths shouldReloadData:(BOOL)shouldReload
{
    NSEntityDescription *mainEntity = self.fetchedResultsController.fetchRequest.entity;
    NSEntityDescription *entityToCheck = mainEntity;
        
    for (NSString *keyPath in sectionKeyPaths)
    {
        NSArray *array = [keyPath componentsSeparatedByString:@"."];
        
        if (array.count<=1)
            return;

        NSRelationshipDescription *relationship = nil;
        NSString *attribute = nil;
        
        for (int i=0; i<[array count]; i++)
        {
            NSPropertyDescription *property = [[entityToCheck propertiesByName] valueForKey:[array objectAtIndex:i]];
            
            if ([property isKindOfClass:[NSRelationshipDescription class]])
            {
                relationship = (NSRelationshipDescription *) property;
                entityToCheck = relationship.destinationEntity;
            }
            else if([property isKindOfClass:[NSAttributeDescription class]])
            {
                attribute = [array objectAtIndex:i];
            }
            
            if(i==[array count]-1)
            {
                NSArray *arrResult = [self.arrayRelationShipKeyPaths filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity == %@",relationship.destinationEntity.name]];
                
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

                if(arrResult && arrResult.count>0)
                {
                    [dictionary setDictionary:[arrResult firstObject]];
                    [self.arrayRelationShipKeyPaths removeObject:dictionary];
                }

                if (attribute)
                {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != nil",attribute];
                    
                    [dictionary setValue:relationship.destinationEntity.name forKey:@"entity"];
                    
                    if (shouldReload)
                        [dictionary setValue:@YES forKey:@"reloadData"];
                    
                    if (arrResult && arrResult.count>0)
                    {
                        NSDictionary *dic = [arrResult firstObject];
                        
                        [dictionary setValue:[dic valueForKey:@"changes"]?[NSCompoundPredicate orPredicateWithSubpredicates:@[[dic valueForKey:@"changes"],predicate]]:predicate forKey:@"changes"];
                    }
                    else
                    {
                        [dictionary setValue:predicate forKey:@"changes"];
                    }
                }
                
                [self.arrayRelationShipKeyPaths addObject:dictionary];
            }
        }
    }
}

-(void)setObserverForRelationshipUpdates
{
// Think on removing previously registerd observers
    
    NSArray *arrayObservers = self.arrayRelationShipKeyPaths;
    
    for (NSDictionary *dic in arrayObservers)
    {
        NSPredicate *changesPredicate = [dic valueForKey:@"changes"];
        NSString *entity = [dic valueForKey:@"entity"];
        NSNumber *reloadData = [dic valueForKey:@"reloadData"];
        
            [NSClassFromString(entity) changedObjects:NSManagedObjectUpdated predicate:nil callback:^{
                
                if (reloadData)
                    [self loadData];
                else
                {
                    NSArray *visibleItems = [self.tableViewDataSource indexPathsForVisibleRows];
                    
                    for (NSIndexPath *indexpath in visibleItems)
                    {
                        NSManagedObject *item = [self itemAtIndexPath:indexpath];
                        
                        [item.managedObjectContext refreshObject:item mergeChanges:NO];
                        
                        break;
                    }
                }
                
            } type:@"observer" chnagedValuesPredicate:changesPredicate];
    }
    
}

#pragma mark - Update Query

-(void)changeFetchLimit:(NSUInteger)fetchLimit
{
    if (self.fetchedResultsController.fetchRequest.fetchLimit == fetchLimit)
        return;
    
    NSFetchRequest* fetchRequest = self.fetchedResultsController.fetchRequest;
    fetchRequest.fetchLimit = fetchLimit;
    
    if (self.fetchedResultsController.cacheName)
        [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];

    [self loadData];
}

- (void)changePredicate:(NSPredicate*)predicate
{
    NSFetchRequest* fetchRequest = self.fetchedResultsController.fetchRequest;
    NSPredicate *predicateOld = fetchRequest.predicate;
    if ([predicateOld isEqual:predicate])
        return;
    fetchRequest.predicate = predicate;
    
    if (self.fetchedResultsController.cacheName)
        [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];

    [self loadData];
}

- (void)changeEntity:(NSString*)entityName andPredicate:(NSPredicate *)predicate
{
    NSFetchRequest* fetchRequest = self.fetchedResultsController.fetchRequest;
    NSEntityDescription *entityDescription = fetchRequest.entity;
    NSEntityDescription *entityNew = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    NSPredicate *predicateOld = fetchRequest.predicate;
    
    if ([entityDescription isEqual:entityNew] && [predicateOld isEqual:predicate])
        return;
    
    fetchRequest.entity = entityNew;
    fetchRequest.predicate = predicate;
    
    if (self.fetchedResultsController.cacheName)
        [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    
    [self loadData];
}

- (void)changeSortDesciptors:(NSArray*)sort
{
    NSFetchRequest* fetchRequest = self.fetchedResultsController.fetchRequest;
    
    if ([sort isEqual:fetchRequest.sortDescriptors])
        return;
    
    fetchRequest.sortDescriptors = sort;
    
    if (self.fetchedResultsController.cacheName)
        [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    
    [self loadData];
    
    [self setRelationshipKeyPathWhichShouldReloadSortDescriptors:self.fetchedResultsController.fetchRequest.sortDescriptors];
}

- (void)changeEntity:(NSString*)entityName andPredicate:(NSPredicate *)predicate sortDesciptors:(NSArray*)sort cellIdentifier:(NSString *)cellIdentifierl
{
    NSFetchRequest* fetchRequest = self.fetchedResultsController.fetchRequest;
    NSEntityDescription *entityDescription = fetchRequest.entity;
    NSEntityDescription *entityNew = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    NSPredicate *predicateOld = fetchRequest.predicate;
    
    if ([entityDescription isEqual:entityNew] && [predicateOld isEqual:predicate] && [sort isEqual:fetchRequest.sortDescriptors])
        return;
    
    fetchRequest.sortDescriptors = sort;
    
    fetchRequest.entity = entityNew;
    fetchRequest.predicate = predicate;
    
    cellIdentifier = cellIdentifierl;

    if (self.fetchedResultsController.cacheName)
        [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
    
    [self loadData];
    
    [self setRelationshipKeyPathWhichShouldReloadSortDescriptors:self.fetchedResultsController.fetchRequest.sortDescriptors];
}


#pragma mark Load Data

-(void)loadData
{
        [self.fetchedResultsController.managedObjectContext performSafeBlock:^{

            [self.fetchedResultsController performFetch:NULL];

            [self reloadData];

        }];
    
    
    if(!isLoaded)
    {
        if (self.fetchedResultsController.sectionNameKeyPath)
            [self setRelationshipKeyPathsWhichShouldReloadSections:@[self.fetchedResultsController.sectionNameKeyPath] shouldReloadData:YES];
        [self setRelationshipKeyPathWhichShouldReloadSortDescriptors:self.fetchedResultsController.fetchRequest.sortDescriptors];
        [self setObserverForRelationshipUpdates];
        isLoaded = YES;
    }
}

-(void)reloadData
{
        if (self.updateBlock && (_arrayInserted || _arrayUpdated || _arrayDeleted))
            self.updateBlock(_arrayInserted,_arrayUpdated,_arrayDeleted);
        else if (self.updaeCallback)
            self.updaeCallback();

    
    
    if (self.tableViewDataSource || self.collectionViewDataSource)
    {
        [self.tableViewDataSource addDataSource:self];
        [self.tableViewDataSource addDelegate:self];
        [self.collectionViewDataSource addDataSource:self];
        [self.collectionViewDataSource addDelegate:self];
        
        
        asyncMain(^{
            
            [self.tableViewDataSource reloadData];
            [self.collectionViewDataSource reloadData];
            
        });
    }
}

#pragma mark DataSource From FetchedResultsController

- (id)itemAtIndexPath:(NSIndexPath*)path
{
    if(self.fetchedResultsController)
    {
        NSManagedObject *objectId = nil;

        @try {
            objectId = [self.fetchedResultsController objectAtIndexPath:path];
        }
        @catch (NSException *exception) {
            NSLog(@"Catch Exception - itemAtIndexPath");
            return nil;
        }
        @finally {
            if (objectId)
                return objectId;
            else
                return nil;
        }
    }
    else
        return nil;
}

- (id)sectionInfoAtIndexPath:(NSInteger)sectionIndex
{
    if(self.fetchedResultsController)
    {
        id section = nil;
        
        @try {
            section = [self.fetchedResultsController sections][sectionIndex];
        }
        @catch (NSException *exception) {
            NSLog(@"Catch Exception - sectionInfoAtIndexPath");
            return nil;
        }
        @finally {
            return section;
        }
    }
    else
        return nil;
}

- (id)selectedItem
{
    if (self.tableViewDataSource)
        return [self itemAtIndexPath:[self.tableViewDataSource indexPathForSelectedRow]];
    else if(self.collectionViewDataSource)
        return [self itemAtIndexPath:[[self.collectionViewDataSource indexPathsForSelectedItems] firstObject]];
    else
        return nil;
}

#pragma mark Values

-(NSUInteger)numberOfSectionsOfDataSource
{
    if (self.numberOfSections)
        return self.numberOfSections();
    else if(self.fetchedResultsController)
    {
        NSUInteger count = 0;

        @try {
            count = self.fetchedResultsController.sections.count;
        }
        @catch (NSException *exception) {
            NSLog(@"Catch Exception - numberOfSectionsOfDataSource");
            return count;
        }
        @finally {
            return count;
        }
    }
    else
        return 0;
}

-(NSUInteger)numberOfRowsOfDataSource:(NSUInteger)section
{
    if (self.numberOfRowsInSection)
        return self.numberOfRowsInSection([self sectionInfoAtIndexPath:section],section);
    else
        return [[self sectionInfoAtIndexPath:section] numberOfObjects];
}

-(NSString *)cellIdentifierForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.identifierForRowAtIndexPath)
        return self.identifierForRowAtIndexPath([self itemAtIndexPath:indexPath],indexPath);
    else
        return self.cellIdentifier;;
}

-(NSString *)sectionIdentifierForHeaderInSection:(NSInteger)section
{
    if (self.identifierForHeaderInSection)
        return self.identifierForHeaderInSection([self sectionInfoAtIndexPath:section],section);
    else
        return self.sectionHeaderIdentifier;
}

-(NSString *)sectionIdentifierForFooterInSection:(NSInteger)section
{
    if (self.identifierForFooterInSection)
        return self.identifierForFooterInSection([self sectionInfoAtIndexPath:section],section);
    else
        return self.sectionFooterIdentifier;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)aTableView
{
    return [self numberOfSectionsOfDataSource];
}

- (NSInteger)tableView:(UITableView*)aTableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsOfDataSource:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.heightForHeaderInSection)
        return self.heightForHeaderInSection([self sectionInfoAtIndexPath:section], section);
    else
        return tableView.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.heightForFooterInSection)
        return self.heightForFooterInSection([self sectionInfoAtIndexPath:section], section);
    else
        return tableView.sectionFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightForRowAtIndexPath)
        return self.heightForRowAtIndexPath(indexPath);
    else if (self.heightForItemAtIndexPath)
        return self.heightForItemAtIndexPath([self itemAtIndexPath:indexPath], indexPath);
    else
        return tableView.rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[self sectionIdentifierForHeaderInSection:section]];
    
    if (self.viewForHeaderInSection)
        self.viewForHeaderInSection(sectionView, [self sectionInfoAtIndexPath:section], section);

    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[self sectionIdentifierForFooterInSection:section]];
    
    if (self.viewForFooterInSection)
        self.viewForFooterInSection(sectionView, [self sectionInfoAtIndexPath:section], section);
    
    return sectionView;
}

- (UITableViewCell*)tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:[self cellIdentifierForRowAtIndexPath:indexPath] forIndexPath:indexPath];

    [cell setItem:[self itemAtIndexPath:indexPath]];

    if (self.cellForRowAtIndexPath)
        self.cellForRowAtIndexPath(cell, [self itemAtIndexPath:indexPath], indexPath);
    else if (self.cellForRowAtIndexPathWithSection)
        self.cellForRowAtIndexPathWithSection(cell, [self itemAtIndexPath:indexPath], indexPath, nil,[self sectionInfoAtIndexPath:indexPath.section]);

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRowAtIndexPath)
        self.didSelectRowAtIndexPath([tableView cellForRowAtIndexPath:indexPath],[self itemAtIndexPath:indexPath],indexPath);
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.indexingEnabled)
    {
        NSArray *sectionIndexTitles = nil;
        
        @try {
            sectionIndexTitles = self.fetchedResultsController.sectionIndexTitles;
        }
        @catch (NSException *exception) {
            NSLog(@"Catch Exception - sectionIndexTitlesForTableView");
            return sectionIndexTitles;
        }
        @finally {
            return sectionIndexTitles;
        }
    }
    else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger indexOfTitle = 0;
    
    @try {
        indexOfTitle = [self.fetchedResultsController.sectionIndexTitles indexOfObject:title];
    }
    @catch (NSException *exception) {
        NSLog(@"Catch Exception - sectionForSectionIndexTitle");
        return indexOfTitle;
    }
    @finally {
        return indexOfTitle;
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self numberOfSectionsOfDataSource];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfRowsOfDataSource:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifierForRowAtIndexPath:indexPath] forIndexPath:indexPath];
    
    [cell setItem:[self itemAtIndexPath:indexPath]];
    
    self.cellForRowAtIndexPath(cell, [self itemAtIndexPath:indexPath], indexPath);

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRowAtIndexPath)
        self.didSelectRowAtIndexPath([collectionView cellForItemAtIndexPath:indexPath],[self itemAtIndexPath:indexPath],indexPath);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return self.sectionFooterSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *sectionView;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (!self.sectionHeaderIdentifier && !self.identifierForHeaderInSection)
            return nil;
            
        sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self sectionIdentifierForHeaderInSection:indexPath.section] forIndexPath:indexPath];
        
        if (self.viewForHeaderInSection)
            self.viewForHeaderInSection(sectionView, [self sectionInfoAtIndexPath:indexPath.section], indexPath.section);
    }
    else if (kind == UICollectionElementKindSectionFooter)
    {
        if (!self.sectionFooterIdentifier && !self.identifierForFooterInSection)
            return nil;
        
        sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self sectionIdentifierForFooterInSection:indexPath.section] forIndexPath:indexPath];
        
        if (self.viewForFooterInSection)
            self.viewForFooterInSection(sectionView, [self sectionInfoAtIndexPath:indexPath.section], indexPath.section);
    }
    
    return sectionView;
}


#pragma mark NSFetchedResultsControllerDelegate

-(NSMutableArray *)arrayInserted
{
    if (!_arrayInserted)
        _arrayInserted = [[NSMutableArray alloc] init];

    return _arrayInserted;
}

-(NSMutableArray *)arrayUpdated
{
    if (!_arrayUpdated)
        _arrayUpdated = [[NSMutableArray alloc] init];
    
    return _arrayUpdated;
}

-(NSMutableArray *)arrayDeleted
{
    if (!_arrayDeleted)
        _arrayDeleted = [[NSMutableArray alloc] init];
    
    return _arrayDeleted;
}









- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [self.arrayInserted addObject:anObject];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.arrayUpdated addObject:anObject];
            break;
        case NSFetchedResultsChangeDelete:
            [self.arrayDeleted addObject:anObject];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self reloadData];
    

    if (!self.updateBlock)
        return;

    
    if (_arrayInserted)
    {
        [_arrayInserted removeAllObjects];
        _arrayInserted = nil;
    }

    if (_arrayUpdated)
    {
        [_arrayUpdated removeAllObjects];
        _arrayUpdated = nil;
    }

    if (_arrayDeleted)
    {
        [_arrayDeleted removeAllObjects];
        _arrayDeleted = nil;
    }
}

@end

// Update code to call reloadData only when view is appreared.
