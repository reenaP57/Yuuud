//
//  NSManagedObject+Mapping.m
//  
//
//  Created by Mehul Rajput on 31/07/15.
//
//

#import "NSManagedObject+Mapping.h"

#import "Store.h"

#import "MIQuery.h"

#import "NSManagedObject+Helper.h"


static NSString *const CLASSKEY = @"CLASSKEY";
static NSString *const PRIMARYKEY = @"PRIMARYKEY";
static NSString *const MAPPING = @"MAPPING";


@interface Store ()

@property (nonatomic,strong) NSMutableDictionary *primaryKeys;

@end




@implementation NSManagedObject (Mapping)


+ (MIQuery *)query
{
    return [MIQuery queryWithClassName:[self className]];
}

+ (MIQuery *)queryWithPredicate:(NSPredicate *)predicate
{
    return [MIQuery queryWithClassName:[self className] predicate:predicate];
}






+(void)setClassName:(NSString *)className
{
    [[[Store sharedInstance] primaryKeys] setObject:className forKey:[CLASSKEY stringByAppendingString:NSStringFromClass(self)]];
}

+(NSString *)className
{
    return [[[Store sharedInstance] primaryKeys] objectForKey:[CLASSKEY stringByAppendingString:NSStringFromClass(self)]]?:NSStringFromClass(self);
}

+(Class)classForKey:(NSString *)className
{
    NSArray *arrayKeys = [[[[Store sharedInstance] primaryKeys] allKeysForObject:className] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith %@",CLASSKEY]];
    
    if (arrayKeys.count==1)
    {
        NSString *className = [[arrayKeys firstObject] stringByReplacingOccurrencesOfString:CLASSKEY withString:@""];
        return NSClassFromString(className);
    }
    
    return NSClassFromString(className);
}





+(void)setPrimaryKey:(NSString *)key
{
    [[[Store sharedInstance] primaryKeys] setObject:key forKey:[PRIMARYKEY stringByAppendingString:NSStringFromClass(self)]];
}

+(NSString *)primaryKey
{
    return [[[Store sharedInstance] primaryKeys] objectForKey:[PRIMARYKEY stringByAppendingString:NSStringFromClass(self)]]?:[[[[self entityDescription] attributesByName] allKeys] containsObject:@"id"]?@"id":nil;
}




+(void)setMappingDictionary:(NSDictionary *)jsonDictionary
{
    [[[Store sharedInstance] primaryKeys] setObject:jsonDictionary forKey:[MAPPING stringByAppendingString:NSStringFromClass(self)]];
}

+(NSDictionary *)mappingDictionary
{
    return [[[Store sharedInstance] primaryKeys] objectForKey:[MAPPING stringByAppendingString:NSStringFromClass(self)]];
}


+(NSString *)mappingKeyForAttribute:(NSString *)attribute
{
    return [self mappingDictionary]?[[self mappingDictionary] valueForKey:attribute]?:attribute:attribute;
}

+(NSString *)attributeNameForKey:(NSString *)key
{
    return [self mappingDictionary]?[[self mappingDictionary] allKeysForObject:key].count>0?[[[self mappingDictionary] allKeysForObject:key] firstObject]:key:key;
}



@end
