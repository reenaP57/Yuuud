//
//  NSManagedObject+Helper.m
//  MI API Example
//
//  Created by mac-0001 on 9/19/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "NSManagedObject+Helper.h"

#import "NSManagedObject+Mapping.h"



@interface Store ()

@property (nonatomic,strong) NSMutableDictionary *primaryKeys;

@end



@implementation NSManagedObject (Helper)

+(NSString *)entity
{
    return [[NSStringFromClass([self class]) componentsSeparatedByString:@"."] lastObject];
}

+(NSEntityDescription *)entityDescription
{
    return [NSEntityDescription entityForName:[self entity] inManagedObjectContext:[[Store sharedInstance] mainManagedObjectContext]];
}


-(instancetype)editableObject
{
    if (self.managedObjectContext == self.entityContext)
        return self;
    else
       return [[self class] convertObject:self];
}

+(NSManagedObjectContext *)entityContext
{
    if ([[[Store sharedInstance] primaryKeys] objectForKey:[self entity]])
        return [[[Store sharedInstance] primaryKeys] objectForKey:[self entity]];
    else
    {
        NSManagedObjectContext *context = [[Store sharedInstance] newChildContext];
        [[[Store sharedInstance] primaryKeys] setObject:context forKey:[self entity]];
        return context;
    }
}

-(NSManagedObjectContext *)entityContext
{
    return [[self class] entityContext];
}

+(void)performBlock:(MIVoidBlock)block
{
    [[self entityContext] performSafeBlock:^{
        block();
    }];
}

+(void)performBlockAndWait:(MIVoidBlock)block
{
    [[self entityContext] performBlockAndWait:^{
        block();
    }];
}

+(instancetype)convertObject:(NSManagedObject *)object
{
    if ([self entityContext] == object.managedObjectContext)
        return object;

    
    if ([object.objectID isTemporaryID])
    {
        [object.managedObjectContext obtainPermanentIDsForObjects:@[object] error:nil];
        return [self.entityContext objectWithID:object.objectID];
    }
    else
        return [self.entityContext objectWithID:object.objectID];
}

#pragma mark - Types Conversion

+(id)convertValue:(id)value ForAttribute:(NSString *)attribute
{
    NSAttributeType attributeType = [[[[self entityDescription] attributesByName] objectForKey:attribute] attributeType];
    
    if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
        value = [value stringValue];
    } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
        value = [NSNumber numberWithInteger:[value  integerValue]];
    } else if (((attributeType == NSFloatAttributeType) || (attributeType == NSDecimalAttributeType) || (attributeType == NSDoubleAttributeType)) && ([value isKindOfClass:[NSString class]])) {
        value = [NSNumber numberWithDouble:[value doubleValue]];
    }

    return value;
}

-(void)setValue:(id)value forAttribute:(NSString *)attribute
{
    if (value == nil)
        return;
    
    [self setValue:[[self class] convertValue:value ForAttribute:attribute] forKey:attribute];
}

- (void)setConvertedValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes)
    {
        [self setValue:[keyedValues objectForKey:attribute] forAttribute:attribute];
    }
}

#pragma mark - Enumerate

+(void)enumerateAndSaveObjects:(NSArray *)array
{
    [self enumerateObjects:array inBlock:nil waitUntilDone:NO completed:nil];
}

+(void)enumerateAndSaveObjects:(NSArray *)array waitUntilDone:(BOOL)waitUntilDone completed:(MIArrayResultBlock)completion
{
    [self enumerateObjects:array inBlock:nil waitUntilDone:waitUntilDone completed:completion];
}

+(void)enumerateObjects:(NSArray *)array inBlock:(ObjectsEnumeration)block
{
    [self enumerateObjects:array inBlock:block waitUntilDone:NO completed:nil];
}

+(void)enumerateObjects:(NSArray *)array inBlock:(ObjectsEnumeration)block waitUntilDone:(BOOL)waitUntilDone completed:(MIArrayResultBlock)completion
{
    [self enumerateObjects:array modelPrimaryKey:[self primaryKey] arrayPrimaryKey:[self mappingKeyForAttribute:[self primaryKey]] waitUntilDone:waitUntilDone inBlock:block completed:completion];
}

+(void)enumerateObjects:(NSArray *)array modelPrimaryKey:(NSString *)modelPrimaryKey arrayPrimaryKey:(NSString *)primaryKey inBlock:(ObjectsEnumeration)block
{
    [self enumerateObjects:array modelPrimaryKey:modelPrimaryKey arrayPrimaryKey:primaryKey waitUntilDone:NO inBlock:block completed:nil];
}

+(void)enumerateObjects:(NSArray *)array modelPrimaryKey:(NSString *)modelPrimaryKey arrayPrimaryKey:(NSString *)primaryKey waitUntilDone:(BOOL)waitUntilDone inBlock:(ObjectsEnumeration)block completed:(MIArrayResultBlock)completion
{
    
    if (waitUntilDone)
    {
        [self performBlockAndWait:^{
            NSArray *arrayResults = [self processEnumerateObjects:array modelPrimaryKey:modelPrimaryKey arrayPrimaryKey:primaryKey inBlock:block];
            if (completion)
                completion(arrayResults,nil);
        }];
    }
    else
    {
        [self performBlock:^{
            [self processEnumerateObjects:array modelPrimaryKey:modelPrimaryKey arrayPrimaryKey:primaryKey inBlock:block];
        }];
    }
}

+(NSArray *)processEnumerateObjects:(NSArray *)array modelPrimaryKey:(NSString *)modelPrimaryKey arrayPrimaryKey:(NSString *)primaryKey inBlock:(ObjectsEnumeration)block
{
    if (![array isKindOfClass:[NSArray class]])
        array = [NSArray arrayWithObject:array];
    
    
    NSMutableArray *arrProcessedObjects = [[NSMutableArray alloc] init];
    
    __block NSMutableDictionary *arrRelationShipItems;
    
    if (!block)         // SubEntities Items Processing
    {
        [[[self entityDescription] relationshipsByName] enumerateKeysAndObjectsUsingBlock:^(NSString *attribute, NSRelationshipDescription *relationShip, BOOL *stop) {
            
            NSString *mappingKey = [self mappingKeyForAttribute:attribute];
            
            NSMutableArray *relationShipData = [NSMutableArray arrayWithArray:[array valueForKeyPath:mappingKey]];
            [relationShipData removeObject:[NSNull null]]; // Because valueForKeyPath: is also fetching null objects
            
            if (relationShipData && relationShipData.count>0)
            {
                if (!arrRelationShipItems)
                    arrRelationShipItems = [[NSMutableDictionary alloc] init];

                
                if(relationShip.isToMany)
                {
                    NSMutableArray *arraySubArrays = [[NSMutableArray alloc] init];
                    for (NSArray *array in relationShipData)
                    {
                        [arraySubArrays addObjectsFromArray:array];
                    }

                    relationShipData = arraySubArrays;
                }
                
                 [NSClassFromString(relationShip.destinationEntity.name) enumerateAndSaveObjects:[[NSSet setWithArray:relationShipData] allObjects] waitUntilDone:YES completed:^(NSArray *objects, NSError *error) {
                     [arrRelationShipItems setValue:objects forKey:attribute];
                 }];
            }
            
        }];
    }
    
    
    
    
    NSArray *editableObjects = [self fetch:[NSPredicate predicateWithFormat:@"%K in %@",modelPrimaryKey,[array valueForKeyPath:primaryKey]] orderBy:nil ascending:YES context:[self entityContext]];
    
    NSPredicate *primaryPredicate = [NSPredicate predicateWithFormat:@"%K == $VALUE",modelPrimaryKey];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        NSManagedObject *item;
        
        NSPredicate *predicate = [primaryPredicate predicateWithSubstitutionVariables:@{@"VALUE":[self convertValue:[obj valueForKey:primaryKey] ForAttribute:modelPrimaryKey]}];
        
        NSArray *arrTemp = [editableObjects filteredArrayUsingPredicate:predicate];
        
        item = [arrTemp firstObject];
        
        if (!item)
            item = [self create:nil context:[self entityContext]];
        
        if (block)
            block(item,obj,idx,stop);
        else
        {
            [obj enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
                
                NSString *relationShipName = [self attributeNameForKey:key];
                
                if ([arrRelationShipItems objectForKey:relationShipName]) // SubEntities Saving
                {
                    NSRelationshipDescription *relationShip = [[[self entityDescription] relationshipsByName] objectForKey:relationShipName];
                    
                    NSString *relationPrimaryKey = [NSClassFromString(relationShip.destinationEntity.name) primaryKey];
                    NSString *relationPrimaryKeyMappingKey = [self mappingKeyForAttribute:relationPrimaryKey];
                    
                    if (!relationShip.isToMany)
                    {
                        NSManagedObject *object = [[[arrRelationShipItems objectForKey:relationShipName] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@",relationPrimaryKey,[value valueForKey:relationPrimaryKeyMappingKey]]] firstObject];
                        
                        [item setValue:[self convertObject:object] forKey:relationShipName];
                    }
                    else if(relationShip.isToMany)
                    {
                        NSMutableArray *arrSubEntityItems = [[NSMutableArray alloc] init];
                        
                        NSArray *arrSubEntitiyObjects = [arrRelationShipItems objectForKey:relationShipName];
                        
                        for (NSDictionary *dic in value)
                        {
                            NSPredicate *predicate123  = [NSPredicate predicateWithFormat:@"%K == %@",relationPrimaryKey,[dic valueForKey:relationPrimaryKeyMappingKey]];
                            [arrSubEntityItems addObject:[self convertObject:[[arrSubEntitiyObjects filteredArrayUsingPredicate:predicate123] firstObject]]];
                        }
                        
                        [item setValue:[NSSet setWithArray:arrSubEntityItems] forKey:relationShipName];
                    }
                }
                else
                {
                    // To check auto saving method from dictionary when there is no mapping required.
                    
                    if ([[[[self entityDescription] attributesByName] allKeys] containsObject:relationShipName])   // To store only attributes which are NSManagedObject having, ignpring extra data of json.
                    {
                        [item setValue:value forAttribute:relationShipName];
                    }
                }
                
            }];
        }
        
        [arrProcessedObjects addObject:item];
    }];
    
    [[self entityContext] save];
 
    
    return arrProcessedObjects;
}


#pragma mark - Find Or Create

+(NSArray *)objectsForKey:(NSString *)key fromData:(NSArray *)arrOfKeys delete:(BOOL)shouldDelete
{
    return [self objectsForKey:key fromData:arrOfKeys deletePredicate:shouldDelete?[NSPredicate predicateWithFormat:@"NOT %K IN %@",key,arrOfKeys]:nil];
}

+(void)objectsForKey:(NSString *)key fromData:(NSArray *)arrOfKeys delete:(BOOL)shouldDelete completionBlock:(MIArrayResultBlock)completion
{
    [self objectsForKey:key fromData:arrOfKeys deletePredicate:shouldDelete?[NSPredicate predicateWithFormat:@"NOT %K IN %@",key,arrOfKeys]:nil completionBlock:completion];
}

+(NSArray *)objectsForKey:(NSString *)key fromData:(NSArray *)arrOfKeys deletePredicate:(NSPredicate *)predicate
{
    [self deleteObjects:predicate];
    return [self objectsForKey:key forData:arrOfKeys context:nil];
}

+(void)objectsForKey:(NSString *)key fromData:(NSArray *)arrOfKeys deletePredicate:(NSPredicate *)predicate completionBlock:(MIArrayResultBlock)completion
{
    [self deleteObjects:predicate completionBlock:nil];
    [self objectsForKey:key forData:arrOfKeys context:nil completionBlock:completion];
}

+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys
{
    return [self objectsForKey:key forData:arrOfKeys context:nil];
}

+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys completionBlock:(MIArrayResultBlock)completion
{
    [self objectsForKey:key forData:arrOfKeys context:nil completionBlock:completion];
}

+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys context:(NSManagedObjectContext *)context
{
    return [self objectsForKey:key forData:arrOfKeys predicate:[NSPredicate predicateWithFormat:@"%K IN %@",key,arrOfKeys] context:context];
}

+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion
{
    [self objectsForKey:key forData:arrOfKeys predicate:[NSPredicate predicateWithFormat:@"%K IN %@",key,arrOfKeys] context:context completionBlock:completion];
}

+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate
{
    return [self objectsForKey:key forData:arrOfKeys predicate:predicate context:nil];
}

+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate completionBlock:(MIArrayResultBlock)completion
{
    [self objectsForKey:key forData:arrOfKeys predicate:predicate context:nil completionBlock:completion];
}

+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    return [self objectsForKey:key forData:arrOfKeys predicate:predicate sortedBy:key ascending:YES context:context];
}

+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion
{
    [self objectsForKey:key forData:arrOfKeys predicate:predicate sortedBy:key ascending:YES context:context completionBlock:completion];
}

+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate sortedBy:(NSString *)sorting ascending:(BOOL)asc context:(NSManagedObjectContext *)context
{
    return [self objectsForKey:key forData:arrOfKeys predicate:predicate sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:sorting ascending:asc]] context:context];
}

+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate sortedBy:(NSString *)sorting ascending:(BOOL)asc context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion
{
    [self objectsForKey:key forData:arrOfKeys predicate:predicate sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:sorting ascending:asc]] context:context completionBlock:completion];
}

+(NSArray *)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];
        
    NSMutableArray *arrFinalObjects = [[NSMutableArray alloc] init];
    
    NSArray *arrManagedObjects = [self fetch:predicate sortedBy:sortingDescriptors context:context];


    int objectIteration = 0;

    for (int i=0; i<[arrOfKeys count]; i++)
    {
        NSManagedObject *obj;
        
        if (objectIteration<[arrManagedObjects count])
            obj = [arrManagedObjects objectAtIndex:objectIteration];
        
        if (obj && [[NSString stringWithFormat:@"%@",[arrOfKeys objectAtIndex:i]] isEqualToString:[NSString stringWithFormat:@"%@",[obj valueForKey:key]]])
        {
            [arrFinalObjects addObject:obj];
            objectIteration++;
        }
        else
        {
            obj = [self create:@{key:[arrOfKeys objectAtIndex:i]} context:context];
            [arrFinalObjects addObject:obj];
        }
    }
    
    return arrFinalObjects;
}

+(void)objectsForKey:(NSString *)key forData:(NSArray *)arrOfKeys predicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

    [context performSafeBlock:^{
    
        NSArray *result = [self objectsForKey:key forData:arrOfKeys predicate:predicate sortedBy:sortingDescriptors context:context];
        
        if (completion)
            completion(result,nil);
        
    }];
}


#pragma mark - Create

+(instancetype)create:(NSDictionary *)dic
{
    return [self createNSManagedObject:dic context:nil];
}

+(void)create:(NSDictionary *)dic completionBlock:(MIObjectResultBlock)completion
{
    [self createNSManagedObject:dic context:nil completionBlock:completion];
}

+(instancetype)create:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    return [self createNSManagedObject:dic context:context];
}

+(void)create:(NSDictionary *)dic context:(NSManagedObjectContext *)context completionBlock:(MIObjectResultBlock)completion
{
    [self createNSManagedObject:dic context:context completionBlock:completion];
}

+(instancetype)createNSManagedObject:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

    NSManagedObject *obj;
    obj = [NSEntityDescription insertNewObjectForEntityForName:[self entity] inManagedObjectContext:context];

    [obj setConvertedValuesForKeysWithDictionary:dic];
    
    return obj;
}

+(void)createNSManagedObject:(NSDictionary *)dic context:(NSManagedObjectContext *)context completionBlock:(MIObjectResultBlock)completion
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

    [context performSafeBlock:^{
    
        NSManagedObject *object = [self createNSManagedObject:dic context:context];
        
        if (completion)
            completion(object,nil);
        
    }];
}

#pragma mark - Find Or Create

+(instancetype)findOrCreate:(NSDictionary *)dic
{
    return [self findOrCreate:dic context:nil];
}

+(void)findOrCreate:(NSDictionary *)dic completionBlock:(MIObjectResultBlock)completion
{
    [self findOrCreate:dic context:nil completionBlock:completion];
}

+(instancetype)findOrCreate:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    NSManagedObject *obj;
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    if (dic)
    {
        for (NSString *key in [dic allKeys])
        {
            [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",key,[dic valueForKey:key]]];
        }
    }
    
    obj = [self findOrCreateNSManagedObject:dic predicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates] context:context];
    
    return obj;
}

+(void)findOrCreate:(NSDictionary *)dic context:(NSManagedObjectContext *)context completionBlock:(MIObjectResultBlock)completion
{
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    if (dic)
    {
        for (NSString *key in [dic allKeys])
        {
            [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",key,[dic valueForKey:key]]];
        }
    }
    
    [self findOrCreateNSManagedObject:dic predicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates] context:context completionBlock:completion];
}

+(instancetype)findOrCreateNSManagedObject:(NSPredicate *)predicate
{
    return [self findOrCreateNSManagedObject:nil predicate:predicate context:nil];
}

+(void)findOrCreateNSManagedObject:(NSPredicate *)predicate completionBlock:(MIObjectResultBlock)completion
{
    [self findOrCreateNSManagedObject:nil predicate:predicate context:nil completionBlock:completion];
}

+(instancetype)findOrCreateNSManagedObject:(NSPredicate *)predicate withData:(NSDictionary *)dic
{
    return [self findOrCreateNSManagedObject:dic predicate:predicate context:nil];
}

+(void)findOrCreateNSManagedObject:(NSPredicate *)predicate withData:(NSDictionary *)dic completionBlock:(MIObjectResultBlock)completion
{
    [self findOrCreateNSManagedObject:dic predicate:predicate context:nil completionBlock:completion];
}

+(instancetype)findOrCreateNSManagedObject:(NSPredicate *)predicate withData:(NSDictionary *)dic context:(NSManagedObjectContext *)context
{
    return [self findOrCreateNSManagedObject:dic predicate:predicate context:context];
}

+(void)findOrCreateNSManagedObject:(NSPredicate *)predicate withData:(NSDictionary *)dic context:(NSManagedObjectContext *)context completionBlock:(MIObjectResultBlock)completion
{
    [self findOrCreateNSManagedObject:dic predicate:predicate context:context completionBlock:completion];
}

+(instancetype)findOrCreateNSManagedObject:(NSDictionary *)dic predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

    NSManagedObject *obj;
   
    if (predicate)
        obj = [[context executeFetchRequest:[self fetchRequest:predicate sortedBy:nil fetchLimit:1] error:nil] lastObject];
    
    if (!obj)
        obj = [self create:dic context:context];
    
    return obj;
}

+(void)findOrCreateNSManagedObject:(NSDictionary *)dic predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context completionBlock:(MIObjectResultBlock)completion
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

    [context performSafeBlock:^{
    
        NSManagedObject *object = [self findOrCreateNSManagedObject:dic predicate:predicate context:context];
        
        if (completion)
            completion(object,nil);
        
    }];
}

#pragma mark - Count

+(NSUInteger)count:(NSPredicate *)predicate
{
    return [self count:predicate context:nil];
}

+(void)count:(NSPredicate *)predicate completionBlock:(MIIntegerResultBlock)completion
{
    [self count:predicate context:nil completionBlock:completion];
}

+(NSUInteger)count:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

	NSError *error = nil;
	NSUInteger count = [context countForFetchRequest:[self fetchRequest:predicate sortedBy:nil fetchLimit:0] error:&error];
	
	if (error) {
		NSLog(@"Core Data Select Error: %@", [error description]);
	}
	
	return count;
}

+(void)count:(NSPredicate *)predicate context:(NSManagedObjectContext *)context completionBlock:(MIIntegerResultBlock)completion
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

    [context performSafeBlock:^{

        NSUInteger count = [self count:predicate context:nil];

        if (completion)
            completion(count,nil);
        
    }];
}

#pragma mark - Delete

+(void)deleteAllObjects
{
    [self deleteAllObjects:nil];
}

+(void)deleteAllObjectsInBackground:(MIVoidBlock)completion
{
    [self deleteAllObjects:nil completionBlock:completion];
}

+(void)deleteAllObjects:(NSManagedObjectContext *)context
{
    [self deleteObjects:nil context:context];
}

+(void)deleteAllObjects:(NSManagedObjectContext *)context completionBlock:(MIVoidBlock)completion
{
    [self deleteObjects:nil context:context completionBlock:completion];
}

+(void)deleteObjects:(NSPredicate *)predicate
{
    [self deleteObjects:predicate context:[[Store sharedInstance] mainManagedObjectContext]];
}

+(void)deleteObjects:(NSPredicate *)predicate completionBlock:(MIVoidBlock)completion
{
    [self deleteObjects:predicate context:[[Store sharedInstance] mainManagedObjectContext] completionBlock:completion];
}

+(void)deleteObjects:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

    NSError *error = nil;
    NSFetchRequest *fetchRequest = [self fetchRequest:predicate sortedBy:nil fetchLimit:0];
    
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in fetchedObjects)
    {
    	[context deleteObject:managedObject];
    }

    [context save];
}

+(void)deleteObjects:(NSPredicate *)predicate context:(NSManagedObjectContext *)context completionBlock:(MIVoidBlock)completion
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

    [context performSafeBlock:^{

        [self deleteObjects:predicate context:nil];
        
        if (completion)
            completion();
        
    }];
}

- (void)deleteObject
{
    [[self managedObjectContext] deleteObject:self];
    [[self managedObjectContext] save];
}

- (void)deleteObject:(MIVoidBlock)completion
{
    [[self managedObjectContext] performSafeBlock:^{

        [self deleteObject];
        
        if (completion)
            completion();
    }];
}



#pragma mark - Fetch

+(NSArray *)fetchAllObjects
{
    return [self fetch:nil sortedBy:nil];
}

+(void)fetchAllObjects:(MIArrayResultBlock)completion
{
    [self fetch:nil sortedBy:nil completionBlock:completion];
}

+(NSArray *)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc
{
    return [self fetch:predicate orderBy:column ascending:asc context:nil fetchLimit:0];
}

+(void)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc completionBlock:(MIArrayResultBlock)completion
{
    [self fetch:predicate orderBy:column ascending:asc context:nil fetchLimit:0 completionBlock:completion];
}

+(NSArray *)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc fetchLimit:(NSUInteger)fetchLimit
{
    return [self fetch:predicate orderBy:column ascending:asc context:nil fetchLimit:fetchLimit];
}

+(void)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc fetchLimit:(NSUInteger)fetchLimit completionBlock:(MIArrayResultBlock)completion
{
    [self fetch:predicate orderBy:column ascending:asc context:nil fetchLimit:fetchLimit completionBlock:completion];
}

+(NSArray *)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc context:(NSManagedObjectContext *)context
{
    return [self fetch:predicate sortedBy:column?@[[NSSortDescriptor sortDescriptorWithKey:column ascending:asc]]:nil context:context fetchLimit:0];
}

+(void)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion
{
    [self fetch:predicate sortedBy:column?@[[NSSortDescriptor sortDescriptorWithKey:column ascending:asc]]:nil context:context fetchLimit:0 completionBlock:completion];
}

+(NSArray *)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc context:(NSManagedObjectContext *)context fetchLimit:(NSUInteger)fetchLimit
{
    return [self fetch:predicate sortedBy:column?@[[NSSortDescriptor sortDescriptorWithKey:column ascending:asc]]:nil context:context fetchLimit:fetchLimit];
}

+(void)fetch:(NSPredicate *)predicate orderBy:(NSString *)column ascending:(BOOL)asc context:(NSManagedObjectContext *)context fetchLimit:(NSUInteger)fetchLimit completionBlock:(MIArrayResultBlock)completion
{
    [self fetch:predicate sortedBy:column?@[[NSSortDescriptor sortDescriptorWithKey:column ascending:asc]]:nil context:context fetchLimit:fetchLimit completionBlock:completion];
}

+(NSArray *)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors
{
    return [self fetch:predicate sortedBy:sortingDescriptors context:nil fetchLimit:0];
}

+(void)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors completionBlock:(MIArrayResultBlock)completion
{
    [self fetch:predicate sortedBy:sortingDescriptors context:nil fetchLimit:0 completionBlock:completion];
}

+(NSArray *)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors fetchLimit:(NSUInteger)fetchLimit
{
    return [self fetch:predicate sortedBy:sortingDescriptors context:nil fetchLimit:fetchLimit];
}

+(void)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors fetchLimit:(NSUInteger)fetchLimit completionBlock:(MIArrayResultBlock)completion
{
    [self fetch:predicate sortedBy:sortingDescriptors context:nil fetchLimit:fetchLimit completionBlock:completion];
}

+(NSArray *)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context
{
    return [self fetch:predicate sortedBy:sortingDescriptors context:context fetchLimit:0];
}

+(void)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion
{
    [self fetch:predicate sortedBy:sortingDescriptors context:context fetchLimit:0 completionBlock:completion];
}

+(NSArray *)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context fetchLimit:(NSUInteger)fetchLimit
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:[self fetchRequest:predicate sortedBy:sortingDescriptors fetchLimit:fetchLimit] error:&error];
    
    if (error) {
        NSLog(@"Core Data Select Error: %@", [error description]);
    }
    
    return result;
}

+(void)fetch:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors context:(NSManagedObjectContext *)context fetchLimit:(NSUInteger)fetchLimit completionBlock:(MIArrayResultBlock)completion
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];

    [context performSafeBlock:^{
        
        NSArray *result = [self fetch:predicate sortedBy:sortingDescriptors context:context fetchLimit:0];

        if (completion)
            completion(result,nil);
        
    }];
}


+(NSFetchRequest *)fetchRequest:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors fetchLimit:(NSUInteger)fetchLimit
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[self entity]];
    
    if (predicate)
        [fetchRequest setPredicate:predicate];
    
    if (sortingDescriptors) {
        [fetchRequest setSortDescriptors:sortingDescriptors];
    }
    
    [fetchRequest setFetchLimit:fetchLimit];
    
    return fetchRequest;
}


#pragma mark - Fetch Asynchronously  - ios8+

+(void)fetchAsynchronously:(NSPredicate *)predicate sortedBy:(NSArray *)sortingDescriptors fetchLimit:(NSUInteger)fetchLimit context:(NSManagedObjectContext *)context completionBlock:(MIArrayResultBlock)completion
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];
    
    if (NSClassFromString(@"NSAsynchronousFetchRequest"))
    {
        NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:[self fetchRequest:predicate sortedBy:sortingDescriptors fetchLimit:fetchLimit] completionBlock:^(NSAsynchronousFetchResult *result) {
            if (completion)
                completion(result.finalResult,nil);
        }];
        
        [context performSafeBlock:^{
            NSError *asynchronousFetchRequestError = nil;
            NSAsynchronousFetchResult *asynchronousFetchResult = (NSAsynchronousFetchResult *)[context executeRequest:asynchronousFetchRequest error:&asynchronousFetchRequestError];
            
            if (asynchronousFetchRequestError)
                NSLog(@"Unable to execute asynchronous fetch result. - %@",asynchronousFetchRequestError);
            else
            {
                NSLog(@"result = %@",asynchronousFetchResult);
                // Add Progress on asynchronousFetchResult
            }
        }];
    }
    else
    {
        if (context.concurrencyType != NSPrivateQueueConcurrencyType)
            NSAssert(@"Use context with concurrencyType NSPrivateQueueConcurrencyType, otherwise it will not fetch data Asynchronously.",nil);
        
        [context performSafeBlock:^{
            
            NSArray *arrResults = [self fetch:predicate sortedBy:sortingDescriptors context:context fetchLimit:fetchLimit];
            
            if (completion)
                completion(arrResults,nil);
        }];
    }
}

#pragma mark - Batch Update  - ios8+

+(void)updateNSManagedObject:(NSDictionary *)dic predicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    if (!context)
        context = [[Store sharedInstance] mainManagedObjectContext];
    
    
    [context performSafeBlock:^{
        
        if (NSClassFromString(@"NSBatchUpdateRequest"))
        {
            NSBatchUpdateRequest *batchUpdateRequest = [[NSBatchUpdateRequest alloc] initWithEntityName:[self entity]];
            
            [batchUpdateRequest setResultType:NSUpdatedObjectIDsResultType];
            [batchUpdateRequest setPropertiesToUpdate:dic];
            
            if (predicate)
                [batchUpdateRequest setPredicate:predicate];
            
            NSError *batchUpdateRequestError = nil;
            NSBatchUpdateResult *batchUpdateResult = (NSBatchUpdateResult *)[context executeRequest:batchUpdateRequest error:&batchUpdateRequestError];
            
            if (batchUpdateRequestError)
                NSLog(@"Unable to execute batch update request. - %@",batchUpdateRequestError);
            else
            {
                NSArray *objectIDs = batchUpdateResult.result;
                
                for (NSManagedObjectID *objectID in objectIDs) {
                    NSManagedObject *managedObject = [context objectWithID:objectID];
                    
                    if (managedObject)
                        [context refreshObject:managedObject mergeChanges:NO];
                }
            }
        }
        else
        {
            NSArray *arrResults = [self fetch:predicate sortedBy:nil context:context];
            
            for (NSString *key in [dic allKeys])
            {
                [arrResults setValue:[dic valueForKey:key] forKeyPath:key];
            }
            
            [context save];
        }
        
    }];
}


#pragma mark - Observer for NSManagedObjects

-(void)observeChanges:(MIVoidBlock)block
{
    if (![[self managedObjectContext] isEqual:[[Store sharedInstance] mainManagedObjectContext]])
        NSAssert(nil,@"You should observer changes on mainManagedObjectContext Only.");
    
    if ([[self objectID] isTemporaryID])
        [[self managedObjectContext] save];

    
    [[self class] changedObjects:NSManagedObjectUpdated predicate:[NSPredicate predicateWithFormat:@"objectID = %@",self.objectID] block:^{
        block();
    }];
}

+(void)changedObjects:(ObjectsChanged)changed
{
    [self changedObjects:NSManagedObjectChangesAll predicate:nil objects:changed];
}

+(void)changedObjects:(NSPredicate *)predicate objects:(ObjectsChanged)changed
{
    [self changedObjects:NSManagedObjectChangesAll predicate:predicate objects:changed];
}

+(void)changedObjectsOfType:(NSManagedObjectChanges)type objects:(ObjectsChanged)changed
{
    [self changedObjects:type predicate:nil objects:changed];
}

+(void)changedObserver:(MIVoidBlock)changed
{
    [self changedObjects:NSManagedObjectChangesAll predicate:nil block:changed];
}

+(void)changedObjects:(NSPredicate *)predicate block:(MIVoidBlock)changed
{
    [self changedObjects:NSManagedObjectChangesAll predicate:predicate block:changed];
}

+(void)changedObjectsOfType:(NSManagedObjectChanges)type block:(MIVoidBlock)changed
{
    [self changedObjects:type predicate:nil block:changed];
}

+(void)changedObjects:(NSManagedObjectChanges)type predicate:(NSPredicate *)predicate objects:(ObjectsChanged)changed
{
    [self changedObjects:type predicate:predicate callback:changed type:@"block" chnagedValuesPredicate:nil];
}

+(void)changedObjects:(NSManagedObjectChanges)type predicate:(NSPredicate *)predicate forProperties:(NSArray *)properties objects:(ObjectsChanged)changed
{
    NSPredicate *changesPredicate = nil;
    
    for (NSString *property in properties)
    {
        NSPredicate *tempPredicate = [NSPredicate predicateWithFormat:@"%K != nil",property];
        
        if(!changesPredicate)
            changesPredicate = tempPredicate;
        else
            changesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[changesPredicate,tempPredicate]];
    }
    
    [self changedObjects:type predicate:predicate callback:changed type:@"block" chnagedValuesPredicate:changesPredicate];
}

+(void)changedObjects:(NSManagedObjectChanges)type predicate:(NSPredicate *)predicate block:(MIVoidBlock)block
{
    [self changedObjects:type predicate:predicate callback:block type:@"observer" chnagedValuesPredicate:nil];
}

+(void)changedObjects:(NSManagedObjectChanges)type predicate:(NSPredicate *)predicate callback:(id)block type:(NSString *)key chnagedValuesPredicate:(NSPredicate *)changedValuesPredicate
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:[self entity] forKey:@"entity"];
    
    if (predicate)
        [dic setValue:predicate forKey:@"predicate"];

    [dic setValue:[NSNumber numberWithInteger:type] forKey:@"type"];

    [dic setValue:block forKey:key];
    
    if (changedValuesPredicate)
        [dic setValue:changedValuesPredicate forKey:@"chnages"];
    
    if (![[[Store sharedInstance] arrChangesObserver] containsObject:dic])
        [[[Store sharedInstance] arrChangesObserver] addObject:dic];
}

+(void)deleteObserver:(MIVoidBlock)block
{
    [[[Store sharedInstance] arrChangesObserver] removeObjectsInArray:[[[Store sharedInstance] arrChangesObserver] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity == %@ && observer == %@",[self entity],block]]];
}

+(void)deleteObserverForObjects:(ObjectsChanged)block
{
    [[[Store sharedInstance] arrChangesObserver] removeObjectsInArray:[[[Store sharedInstance] arrChangesObserver] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity == %@ && block == %@",[self entity],block]]];
}

+(void)deleteObservers
{
    [[[Store sharedInstance] arrChangesObserver] removeObjectsInArray:[[[Store sharedInstance] arrChangesObserver] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity == %@",[self entity]]]];
}

@end
