//
//  NSManagedObject+Mapping.h
//  
//
//  Created by Mehul Rajput on 31/07/15.
//
//

#import <CoreData/CoreData.h>


@interface NSManagedObject (Mapping)


+ (id)query;
+ (id)queryWithPredicate:(NSPredicate *)predicate;



+(void)setClassName:(NSString *)className;
+(NSString *)className;
+(Class)classForKey:(NSString *)className;


+(void)setPrimaryKey:(NSString *)key;
+(NSString *)primaryKey;



+(void)setMappingDictionary:(NSDictionary *)jsonDictionary;
+(NSDictionary *)mappingDictionary;

+(NSString *)mappingKeyForAttribute:(NSString *)attribute;
+(NSString *)attributeNameForKey:(NSString *)attribute;

@end
