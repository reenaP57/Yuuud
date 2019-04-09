//
//  NSManagedObject+Helper.h
//  MI API Example
//
//  Created by mac-0001 on 9/19/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "Master.h"


typedef NS_ENUM(NSInteger, NSManagedObjectChanges) {
    NSManagedObjectInserted,
    NSManagedObjectUpdated,
    NSManagedObjectDeleted,
    NSManagedObjectChangesAll,
};

typedef void (^ObjectsChanged)(NSArray *changedObjects,NSManagedObjectChanges type);

typedef void (^ObjectsEnumeration)(NSManagedObject *item,NSDictionary *object, NSUInteger idx, BOOL *stop);


@interface NSManagedObject (Helper)


+(NSEntityDescription *)entityDescription;

+(NSManagedObjectContext *)entityContext;


-(instancetype)editableObject;

+(instancetype)convertObject:(NSManagedObject *)object;

+(void)performBlock:(MIVoidBlock)block;
+(void)performBlockAndWait:(MIVoidBlock)block;



+(void)enumerateObjects:(NSArray *)array inBlock:(ObjectsEnumeration)block;
+(void)enumerateObjects:(NSArray *)array modelPrimaryKey:(NSString *)modelPrimaryKey arrayPrimaryKey:(NSString *)primaryKey inBlock:(ObjectsEnumeration)block;
+(void)enumerateAndSaveObjects:(NSArray *)array;



+(id)convertValue:(id)value ForAttribute:(NSString *)attribute;
- (void)setConvertedValuesForKeysWithDictionary:(NSDictionary *)keyedValues;







+(NSArray *)objectsForKey:(NSString *)key fromData:(NSArray *)arrOfKeys delete:(BOOL)shouldDelete;
+(NSArray *)objectsForKey:(NSString *)key fromData:(NSArray *)arrOfKeys deletePredicate:(NSPredicate *)predicate;



+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys;
+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate;

+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys context:(NSManagedObjectContext *)context;
+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate  context:(NSManagedObjectContext *)context;
+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate sortedBy:(NSString *)sorting ascending:(BOOL)asc context:(NSManagedObjectContext *)context;
+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context;

+(void)objectsForKey:(NSString *)key fromData:(NSArray *)arrOfKeys delete:(BOOL)shouldDelete completionBlock:(MIArrayResultBlock)completion;
+(void)objectsForKey:(NSString *)key fromData:(NSArray *)arrOfKeys deletePredicate:(NSPredicate *)predicate completionBlock:(MIArrayResultBlock)completion;
+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys completionBlock:(MIArrayResultBlock)completion;
+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion;
+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate completionBlock:(MIArrayResultBlock)completion;
+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion;
+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate sortedBy:(NSString *)sorting ascending:(BOOL)asc context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion;
+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion;







+(instancetype)create:(NSDictionary *)dic;
+(instancetype)create:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

+(void)create:(NSDictionary *)dic completionBlock:(MIObjectResultBlock)completion;
+(void)create:(NSDictionary *)dic context:(NSManagedObjectContext *)context completionBlock:(MIObjectResultBlock)completion;





+(instancetype)findOrCreate:(NSDictionary *)dic;
+(instancetype)findOrCreate:(NSDictionary *)dic context:(NSManagedObjectContext *)context;

+(instancetype)findOrCreateNSManagedObject:(NSPredicate *)predicate;
+(instancetype)findOrCreateNSManagedObject:(NSPredicate *)predicate withData:(NSDictionary *)dic;
+(instancetype)findOrCreateNSManagedObject:(NSPredicate *)predicate withData:(NSDictionary *)dic context:(NSManagedObjectContext *)context;


+(void)findOrCreate:(NSDictionary *)dic completionBlock:(MIObjectResultBlock)completion;
+(void)findOrCreate:(NSDictionary *)dic context:(NSManagedObjectContext *)context completionBlock:(MIObjectResultBlock)completion;

+(void)findOrCreateNSManagedObject:(NSPredicate *)predicate completionBlock:(MIObjectResultBlock)completion;
+(void)findOrCreateNSManagedObject:(NSPredicate *)predicate withData:(NSDictionary *)dic completionBlock:(MIObjectResultBlock)completion;
+(void)findOrCreateNSManagedObject:(NSPredicate *)predicate withData:(NSDictionary *)dic context:(NSManagedObjectContext *)context completionBlock:(MIObjectResultBlock)completion;
+(void)findOrCreateNSManagedObject:(NSDictionary *)dic predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context completionBlock:(MIObjectResultBlock)completion;






+(NSUInteger)count:(NSPredicate *)predicate;
+(NSUInteger)count:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;

+(void)count:(NSPredicate *)predicate completionBlock:(MIIntegerResultBlock)completion;
+(void)count:(NSPredicate *)predicate context:(NSManagedObjectContext *)context completionBlock:(MIIntegerResultBlock)completion;




+(void)deleteAllObjects;
+(void)deleteAllObjects:(NSManagedObjectContext *)context;
+(void)deleteObjects:(NSPredicate *)predicate;
+(void)deleteObjects:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;
- (void)deleteObject;

+(void)deleteAllObjectsInBackground:(MIVoidBlock)completion;
+(void)deleteAllObjects:(NSManagedObjectContext *)context completionBlock:(MIVoidBlock)completion;
+(void)deleteObjects:(NSPredicate *)predicate completionBlock:(MIVoidBlock)completion;
+(void)deleteObjects:(NSPredicate *)predicate context:(NSManagedObjectContext *)context completionBlock:(MIVoidBlock)completion;
- (void)deleteObject:(MIVoidBlock)completion;




+(NSArray *)fetchAllObjects;
+(NSArray *)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc;
+(NSArray *)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc context:(NSManagedObjectContext *)context;
+(NSArray *)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors;
+(NSArray *)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context;

+(NSArray *)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc fetchLimit:(NSUInteger)fetchLimit;
+(NSArray *)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc context:(NSManagedObjectContext *)context fetchLimit:(NSUInteger)fetchLimit;
+(NSArray *)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors fetchLimit:(NSUInteger)fetchLimit;
+(NSArray *)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context fetchLimit:(NSUInteger)fetchLimit;


+(void)fetchAllObjects:(MIArrayResultBlock)completion;
+(void)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc completionBlock:(MIArrayResultBlock)completion;
+(void)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion;
+(void)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors completionBlock:(MIArrayResultBlock)completion;
+(void)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion;

+(void)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc fetchLimit:(NSUInteger)fetchLimit completionBlock:(MIArrayResultBlock)completion;
+(void)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc context:(NSManagedObjectContext *)context fetchLimit:(NSUInteger)fetchLimit completionBlock:(MIArrayResultBlock)completion;
+(void)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors fetchLimit:(NSUInteger)fetchLimit completionBlock:(MIArrayResultBlock)completion;
+(void)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context fetchLimit:(NSUInteger)fetchLimit completionBlock:(MIArrayResultBlock)completion;




+(void)changedObjects:(ObjectsChanged)changed;
+(void)changedObjects:(NSPredicate *)predicate objects:(ObjectsChanged)changed;
+(void)changedObjectsOfType:(NSManagedObjectChanges)type objects:(ObjectsChanged)changed;
+(void)changedObjects:(NSManagedObjectChanges)type predicate:(NSPredicate *)predicate objects:(ObjectsChanged)changed;

-(void)observeChanges:(MIVoidBlock)block;

+(void)changedObserver:(MIVoidBlock)changed;
+(void)changedObjects:(NSPredicate *)predicate block:(MIVoidBlock)changed;
+(void)changedObjectsOfType:(NSManagedObjectChanges)type block:(MIVoidBlock)changed;
+(void)changedObjects:(NSManagedObjectChanges)type predicate:(NSPredicate *)predicate block:(MIVoidBlock)block;


+(void)changedObjects:(NSManagedObjectChanges)type predicate:(NSPredicate *)predicate callback:(id)block type:(NSString *)key chnagedValuesPredicate:(NSPredicate *)changedValuesPredicate;

+(void)deleteObserver:(MIVoidBlock)block;
+(void)deleteObserverForObjects:(ObjectsChanged)block;
+(void)deleteObservers;







+(void)updateNSManagedObject:(NSDictionary *)dic predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;
+(void)fetchAsynchronously:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors fetchLimit:(NSUInteger)fetchLimit context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion;



@end


/*
 
 iOS 9 and later:
 
 iOS 9 added a new class called NSBatchDeleteRequest that allows you to easily delete objects matching a predicate without having to load them all in to memory. Here's how you'd use it:
 
 
 Swift 2
 
 let fetchRequest = NSFetchRequest(entityName: "Car")
 let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
 
 do {
 try myPersistentStoreCoordinator.executeRequest(deleteRequest, withContext: myContext)
 } catch let error as NSError {
 // TODO: handle the error
 }
 
 
 
 Objective-C
 
 NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Car"];
 NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
 
 NSError *deleteError = nil;
 [myPersistentStoreCoordinator executeRequest:delete withContext:myContext error:&deleteError];
 
*/
