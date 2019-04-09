//
// Created by chris on 6/16/13.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "Store.h"

#import "Constants.h"

typedef NSInteger (^NumberOfSections)(void);
typedef NSInteger (^NumberOfRowsInSection)(id <NSFetchedResultsSectionInfo> info, NSInteger sectionIndex);

typedef CGFloat (^HeightForHeaderInSection)(id <NSFetchedResultsSectionInfo> info,NSInteger sectionIndex);
typedef CGFloat (^HeightForRowAtIndexPath)(NSIndexPath *indexPath);
typedef CGFloat (^HeightForItemAtIndexPath)(id item, NSIndexPath *indexPath);

typedef NSString* (^IdentifierForHeaderInSection)(id <NSFetchedResultsSectionInfo> info,NSInteger sectionIndex);
typedef NSString* (^IdentifierForRowAtIndexPath)(id item, NSIndexPath *indexPath);

typedef void (^CellForRowAtIndexPath)(id cell, id item, NSIndexPath *indexPath);
typedef void (^CellForRowAtIndexPathWithSection)(id cell, id item, NSIndexPath *indexPath, id section, id <NSFetchedResultsSectionInfo> info);
typedef void (^ViewForHeaderInSection)(id section, id <NSFetchedResultsSectionInfo> info, NSInteger sectionIndex);

typedef void (^DidSelectRowAtIndexPath)(id cell, id item, NSIndexPath *indexPath);



typedef void (^NSFetchedResultsControllerDelegateBlock)(NSArray *arrInserted,NSArray *arrUpdated,NSArray *arrDeleted);



@interface FetchedResultsTableDataSource : NSObject <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>




@property (nonatomic, copy) NumberOfSections numberOfSections;
@property (nonatomic, copy) NumberOfRowsInSection numberOfRowsInSection;

@property (nonatomic, copy) HeightForHeaderInSection heightForHeaderInSection;
@property (nonatomic, copy) HeightForHeaderInSection heightForFooterInSection;
@property (nonatomic, copy) HeightForRowAtIndexPath heightForRowAtIndexPath;
@property (nonatomic, copy) HeightForItemAtIndexPath heightForItemAtIndexPath;

@property (nonatomic, copy) IdentifierForHeaderInSection identifierForHeaderInSection;
@property (nonatomic, copy) IdentifierForHeaderInSection identifierForFooterInSection;
@property (nonatomic, copy) IdentifierForRowAtIndexPath identifierForRowAtIndexPath;

@property (nonatomic, copy) CellForRowAtIndexPath cellForRowAtIndexPath;
@property (nonatomic, copy) CellForRowAtIndexPathWithSection cellForRowAtIndexPathWithSection;
@property (nonatomic, copy) ViewForHeaderInSection viewForHeaderInSection;
@property (nonatomic, copy) ViewForHeaderInSection viewForFooterInSection;

@property (nonatomic, copy) DidSelectRowAtIndexPath didSelectRowAtIndexPath;



@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSString *sectionHeaderIdentifier;
@property (nonatomic, strong) NSString *sectionFooterIdentifier;

@property (nonatomic, assign) CGSize sectionHeaderSize;
@property (nonatomic, assign) CGSize sectionFooterSize;


@property (nonatomic,assign) BOOL indexingEnabled;

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;


- (id)initWithTableView:(UIView*)tableView fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController;
- (id)initWithBlock:(MIVoidBlock)block updates:(NSFetchedResultsControllerDelegateBlock)updates fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController;
- (id)initWithBlock:(MIVoidBlock)block fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController;



-(void)changeFetchLimit:(NSUInteger)fetchLimit;
- (void)changePredicate:(NSPredicate*)predicate;
- (void)changeEntity:(NSString*)entityName andPredicate:(NSPredicate *)predicate;
- (void)changeEntity:(NSString*)entityName andPredicate:(NSPredicate *)predicate sortDesciptors:(NSArray*)sort cellIdentifier:(NSString *)cellIdentifierl;
- (void)changeSortDesciptors:(NSArray*)sort;

- (id)selectedItem;
- (id)itemAtIndexPath:(NSIndexPath*)path;
- (id)sectionInfoAtIndexPath:(NSInteger)sectionIndex;

-(void)loadData;
-(void)reloadData;

-(void)setRelationshipKeyPathsWhichShouldReloadData:(NSArray *)keyPaths;
-(void)setRelationshipKeyPathWhichShouldReloadPredicate:(NSArray *)predicateKeyPaths;


@end


// To-Do Check logic for default Section with Title
// To-Do Test new methods