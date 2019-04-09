//
//  Store.h
//  TransitDataImport
//
//  Created by Chris Eidhof on 6/16/13.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface Store : NSObject
{

}

@property (nonatomic,strong) NSString* modelName;  //          DEPRECATED_ATTRIBUTE       // Default: Model
@property (nonatomic,strong) NSString* databaseFileName;            // Default: Data.sqlite
@property (nonatomic,strong) NSString* databaseFileDirectory;       // Default: [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
@property (nonatomic,strong) NSString* initializedWithSqliteFile;   // Not used as default


@property (nonatomic,strong) NSString* iCloudDataDirectoryName;   // Data.nosync
@property (nonatomic,strong) NSString* iCloudLogsDirectoryName;   // Logs




@property (nonatomic,strong) NSString* iCloudEnabledAppId;   // Not used as default




@property (nonatomic,strong,readonly) NSManagedObjectContext* mainManagedObjectContext;



@property (nonatomic,strong,readonly) NSManagedObjectContext* privateWriterContext;



+ (instancetype)sharedInstance;


- (NSManagedObjectModel *)managedObjectModel;
//- (NSManagedObjectContext*)newPrivateContext;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

- (NSManagedObjectContext*)newChildContext;



-(NSURL *)storeURL;

-(void)save;
-(void)saveInBackground;

-(void)truncate;



-(NSMutableArray *)arrChangesObserver;
@end
