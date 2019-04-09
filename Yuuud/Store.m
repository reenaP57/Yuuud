//
//  Store.m
//  TransitDataImport
//
//  Created by Chris Eidhof on 6/16/13.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import "Store.h"

#import "Master.h"


@interface Store ()
{
    NSMutableArray *arrChangesObserver;
}


@property (nonatomic,strong) NSMutableDictionary *primaryKeys;


@property (nonatomic,strong,readwrite) NSManagedObjectContext* mainManagedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@property (nonatomic,strong,readwrite) NSManagedObjectContext* privateWriterContext;

@end

@implementation Store

@synthesize modelName,databaseFileName,databaseFileDirectory,initializedWithSqliteFile,iCloudDataDirectoryName,iCloudLogsDirectoryName,iCloudEnabledAppId;

@synthesize privateWriterContext;


@synthesize primaryKeys;

+ (instancetype)sharedInstance
{
    static Store *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Store alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        primaryKeys = [[NSMutableDictionary alloc] init];
        
//        [self setModelName:@"Model"];
        [self setDatabaseFileName:@"Data.sqlite"];
        [self setInitializedWithSqliteFile:@"Data"];
        [self setDatabaseFileDirectory:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]];
        [self setICloudDataDirectoryName:@"Data.nosync"];
        [self setICloudLogsDirectoryName:@"Logs"];

        [self setupSaveNotification];
    }

    return self;
}

-(NSURL *)storeURL
{
    return [NSURL fileURLWithPath:[databaseFileDirectory stringByAppendingPathComponent:databaseFileName]];
}

- (void)setupSaveNotification
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification* note) {

                                                      NSManagedObjectContext *moc = self.mainManagedObjectContext;
                                                      
                                                      NSManagedObjectContext *notificationContext = (NSManagedObjectContext *)note.object;
                                                      
                                                      if (moc.persistentStoreCoordinator == notificationContext.persistentStoreCoordinator && notificationContext.parentContext == nil && notificationContext != moc)
                                                      {
                                                          [moc performBlockAndWait:^{
                                                              [moc mergeChangesFromContextDidSaveNotification:note];
                                                          }];
                                                          [self observeChangesOnNotificaiton:note];
                                                      }
                                                      else if (notificationContext == moc)
                                                      {
                                                          [self observeChangesOnNotificaiton:note];
                                                      }
                                                      
                                                  }];

}

-(NSMutableArray *)arrChangesObserver
{
    if (!arrChangesObserver)
        arrChangesObserver = [[NSMutableArray alloc] init];
    
    return arrChangesObserver;
}

-(void)observeChangesOnNotificaiton:(NSNotification *)notificaiton
{
    NSArray *arr = arrChangesObserver;
    
    if (arr && arr.count>0)
    {
        [self performBlock:^{
            
            for (NSString *entity in [[NSSet setWithArray:[[arr valueForKeyPath:@"entity"] copy]] allObjects])
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"entity.name = %@",entity];
                NSArray *arrUpdated = [[[notificaiton.userInfo objectForKey:@"updated"] allObjects] filteredArrayUsingPredicate:predicate];
                NSArray *arrInserted = [[[notificaiton.userInfo objectForKey:@"inserted"] allObjects] filteredArrayUsingPredicate:predicate];
                NSArray *arrDeleted = [[[notificaiton.userInfo objectForKey:@"deleted"] allObjects] filteredArrayUsingPredicate:predicate];
                
                if (arrUpdated.count>0 || arrInserted.count>0 || arrDeleted.count>0)
                {
                    for (NSDictionary *dic in [arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity = %@",entity]])
                    {
                        ObjectsChanged block = [dic valueForKey:@"block"];
                        NSPredicate *predicate = [dic valueForKey:@"predicate"];
                        NSManagedObjectChanges type = [[dic valueForKey:@"type"] integerValue];
                        MIVoidBlock observer = [dic valueForKey:@"observer"];
                        NSPredicate *changesPredicate = [dic valueForKey:@"changes"];
                        
                        
                        NSArray *arrChangedObjects;
                        
                        if (!predicate)
                            predicate = [NSPredicate predicateWithFormat:@"1 == 1"];

                        switch (type) {
                            case NSManagedObjectInserted:
                                    arrChangedObjects = [arrInserted filteredArrayUsingPredicate:predicate];
                                break;
                            case NSManagedObjectUpdated:
                                    arrChangedObjects = [arrUpdated filteredArrayUsingPredicate:predicate];
                                break;
                            case NSManagedObjectDeleted:
                                    arrChangedObjects = [arrDeleted filteredArrayUsingPredicate:predicate];
                                break;
                            case NSManagedObjectChangesAll:
                            {
                                NSMutableArray *arrResults = [[NSMutableArray alloc] init];
                                
                                [arrResults addObjectsFromArray:[arrInserted filteredArrayUsingPredicate:predicate]];
                                
                                if (!(observer && arrResults.count>0))
                                    [arrResults addObjectsFromArray:[arrUpdated filteredArrayUsingPredicate:predicate]];

                                if (!(observer && arrResults.count>0))
                                    [arrResults addObjectsFromArray:[arrDeleted filteredArrayUsingPredicate:predicate]];
                                
                                arrChangedObjects = arrResults;
                            }
                                break;
                        }
                        
                        if (changesPredicate)
                            arrChangedObjects = [arrChangedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"changedValues IN %@",[[arrChangedObjects valueForKeyPath:@"changedValues"] filteredArrayUsingPredicate:changesPredicate]]];
                        
                        if (arrChangedObjects.count>0)
                        {
                            [self performBlockOnMainThread:^{
                                if (observer)
                                    observer();
                                else if (block)
                                {
                                    NSMutableArray *arrayMainContextValues = [[NSMutableArray alloc] init];
                                    
                                    for (NSManagedObject *object in arrChangedObjects)
                                    {
                                        [arrayMainContextValues addObject:[[[Store sharedInstance] mainManagedObjectContext] objectWithID:object.objectID]];
                                    }
                                    
                                    block(arrayMainContextValues,type);
                                }
                            }];
                        }
                    }
                    
                }
                
            }
        }];
    }
}



-(NSManagedObjectContext*)privateWriterContext
{
    if (privateWriterContext != nil)
        return privateWriterContext;

    privateWriterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [privateWriterContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    return privateWriterContext;
}

- (NSManagedObjectContext*)newChildContext
{
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.parentContext = [self privateWriterContext];
    return context;
}


- (NSManagedObjectContext*)newPrivateContext
{
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return context;
}


- (NSManagedObjectContext *)mainManagedObjectContext
{
    if (_mainManagedObjectContext != nil)
        return _mainManagedObjectContext;

    if (![NSThread isMainThread])
    {
        syncMain(^{
            [self mainManagedObjectContext];
        });
        
        if (_mainManagedObjectContext != nil)
            return _mainManagedObjectContext;
    }
    
    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainManagedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    return _mainManagedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [self storeURL];
    
    if (initializedWithSqliteFile && ![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
    {
        NSString *preloadPath = [[NSBundle mainBundle] pathForResource:initializedWithSqliteFile ofType:@"sqlite"];

        if ([[NSFileManager defaultManager] fileExistsAtPath:preloadPath])
        {
            NSError* err = nil;
            
            if (![[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:preloadPath] toURL:storeURL error:&err])
                NSLog(@"Oops, could copy preloaded data");
        }
    }
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setObject:NSFileProtectionNone forKey:NSFileProtectionKey];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    

    if (iCloudEnabledAppId)
    {
        NSFileManager *fileManager=[[NSFileManager alloc]init];
        
        NSURL *iCloudRoot = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        if (iCloudRoot)
        {
            
            NSURL *iCloudLogsPath = [NSURL fileURLWithPath:[[iCloudRoot path] stringByAppendingPathComponent:iCloudLogsDirectoryName]];
            
            if([fileManager fileExistsAtPath:[[iCloudRoot path] stringByAppendingPathComponent:iCloudDataDirectoryName]] == NO)
            {
                NSError *fileSystemError;
                [fileManager createDirectoryAtPath:[[iCloudRoot path] stringByAppendingPathComponent:iCloudDataDirectoryName]
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:&fileSystemError];
                if(fileSystemError != nil)
                {
                    NSLog(@"Error creating database directory %@", fileSystemError);
                }
            }
            
            NSString *iCloudData = [[[iCloudRoot path] stringByAppendingPathComponent:iCloudDataDirectoryName] stringByAppendingPathComponent:databaseFileName];
            
            [options setObject:iCloudEnabledAppId forKey:NSPersistentStoreUbiquitousContentNameKey];
            [options setObject:iCloudLogsPath forKey:NSPersistentStoreUbiquitousContentURLKey];
            
            storeURL = [NSURL fileURLWithPath:iCloudData];
        }
    }
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSAssert(nil, @"Unresolved error %@", error);
    }
    
    return _persistentStoreCoordinator;
}

-(void)save
{
    [self.mainManagedObjectContext save];
}

-(void)saveInBackground
{
    [self.mainManagedObjectContext saveInBackground];
}

-(void)truncate
{
    NSManagedObjectContext *context = [self newPrivateContext];
    
    for (NSEntityDescription *entitiy in [self.managedObjectModel entities])
    {
        id class = NSClassFromString(entitiy.managedObjectClassName);
        [class deleteAllObjects:context completionBlock:nil];
    }
    
    [context saveInBackground];
}

@end
