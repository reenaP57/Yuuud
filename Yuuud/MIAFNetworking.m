//
//  MIAFNetworking.m
//  AFNetworking
//
//  Created by mac-0001 on 14/03/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import "MIAFNetworking.h"

#import "AFNetworkActivityLogger.h"
#import "AFURLSessionManager.h"
#import "AFURLConnectionOperation.h"

typedef NS_ENUM(NSInteger, APIResponseType) {
    APIResponseNoActionRequired =                       1,
    APIResponseDisplayToastAlert =                      2,
    APIResponseDisplayAlertViewWithOkButton =           3,
    APIResponseLogoutUserOnAlertViewAction =            4,
    APIResponseResetCoreDataOnAlertViewAction =         5,
    APIResponseDisableThisVersionOnAlertViewAction =    6,
    APIResponseDisableThisInstallerOnAlertViewAction =  7,
};


typedef NS_ENUM(NSInteger, ApplicationResponseType) {
    ApplicationResponseEnableAPIConsoleLog = 1001,
    ApplicationResponseDisableAPIConsoleLog = 1002,
    ApplicationResponseEnableCrashStorage = 2001,
    ApplicationResponseDisableCrashStorage = 2002,
    ApplicationResponseUploadCrashStorage = 2003,
    ApplicationResponseEnableConsoleLog = 3001,
    ApplicationResponseDisableConsoleLog = 3002,
    ApplicationResponseUploadConsoleLog = 3003,
    ApplicationResponseUploadCoreData = 3004,
};
// To add filters also, for which time periods files to be uploaded
// Also, add email address or server url where files to be uploaded.


#import <objc/runtime.h>




//#import <Master/NSObject+NewProperty.h>

@interface UIViewController ()

+(void)sendEmailToDeveloper:(NSString *)subject body:(NSString *)body completion:(id)completion;

@end


@interface NSObject ()

-(id)performSelectorFromStringWithReturnObject:(NSString *)selector;
-(id)performSelectorFromStringWithReturnObject:(NSString *)selector withObject:(id)object;

@end


@interface UIApplication ()

+(void)parseApplicaitonResponse:(NSDictionary*)responseDictionary;

@end




@interface MIAFNetworking ()

@property (nonatomic,strong) NSMutableDictionary *errorParsingBlocks;

@end



@implementation MIAFNetworking

static AFHTTPSessionManager *manager = nil;

@synthesize baseURL,disableTracing,disableCustomHeaders;

@synthesize apiResponseTimeNotificaiton;

@synthesize errorParsingBlocks;

+(void)load
{
        [AFNetworkActivityIndicatorManager sharedManager];
        
//        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//            NSLog(@"Network Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
//         }];
    
        [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
        [[AFNetworkActivityLogger sharedLogger] startLogging];
    
//        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:100 * 1024 * 1024 diskCapacity:100 * 1024 * 1024 diskPath:nil];
//        [NSURLCache setSharedURLCache:URLCache];
}

+ (instancetype)sharedInstance
{
    static MIAFNetworking *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MIAFNetworking alloc] init];
    });
    
    return _sharedInstance;
}

-(NSMutableDictionary *)parser
{
    if (!errorParsingBlocks)
        errorParsingBlocks = [[NSMutableDictionary alloc] init];
    
    return errorParsingBlocks;
}

-(void)setDisableTracing:(BOOL)disableTracingl
{
    disableTracing = disableTracingl;

    if (disableTracing)
    {
        [[AFNetworkActivityLogger sharedLogger] stopLogging];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    else
    {
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingOperationDidFinishNotification object:nil];
        
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
#endif
    }
}

static void * AFNetworkRequestStartDate = &AFNetworkRequestStartDate;

- (void)networkRequestDidFinish:(NSNotification *)notification {
    
    NSError *error = AFNetworkErrorFromNotification(notification);
    
    if (error)
    {
        if ([[self parser] objectForKey:[NSString stringWithFormat:@"%ld",(long)error.code]])
        {
            typedef void (^Block) (void);
            Block block = [[self parser] objectForKey:[NSString stringWithFormat:@"%ld",(long)error.code]];
            block();
            
            return;
        }
        
        if ([NSClassFromString(@"UIViewController") respondsToSelector:NSSelectorFromString(@"sendEmailToDeveloper:body:completion:")])
        {
            [UIViewController sendEmailToDeveloper:@"API Error" body:[NSString stringWithFormat:@"Request = %@\n\n\nResponse = %@",[[AFNetworkActivityLogger sharedLogger] apiRequestString:notification],[[AFNetworkActivityLogger sharedLogger] apiResponseString:notification]] completion:nil];
        }
    }
    else
    {
        NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:objc_getAssociatedObject(notification.object, AFNetworkRequestStartDate)];

        if (apiResponseTimeNotificaiton > 0 && (elapsedTime/10000) > apiResponseTimeNotificaiton)
        {
            if ([NSClassFromString(@"UIViewController") respondsToSelector:NSSelectorFromString(@"sendEmailToDeveloper:body:completion:")])
            {
                [UIViewController sendEmailToDeveloper:@"API Error" body:[NSString stringWithFormat:@"Request = %@\n\n\nResponse = %@",[[AFNetworkActivityLogger sharedLogger] apiRequestString:notification],[[AFNetworkActivityLogger sharedLogger] apiResponseString:notification]] completion:nil];
            }
        }
    }
    
}

- (AFHTTPSessionManager *)sessionManager
{
    if (!manager)
    {
        manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:baseURL]];
        
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
//        if ([CUserDefaults valueForKey:UserDefaultLoginToken])
//            [manager.requestSerializer setValue:[CUserDefaults valueForKey:UserDefaultLoginToken] forHTTPHeaderField:@"token"];
    }

    if (NSClassFromString(@"BasicAppDelegate") && !disableCustomHeaders)
    {
        if ([[UIApplication sharedApplication] canPerformAction:NSSelectorFromString(@"userAgent") withSender:nil])
        {
            [manager.requestSerializer setValue:[[UIApplication sharedApplication] performSelectorFromStringWithReturnObject:@"userAgent"] forHTTPHeaderField:@"User-Agent"];
        }
        

        [manager.requestSerializer setValue:[UIApplication performSelectorFromStringWithReturnObject:@"uniqueIdentifier"] forHTTPHeaderField:@"Device-Identifier"];
        
        [manager.requestSerializer setValue:[UIApplication performSelectorFromStringWithReturnObject:@"appID"] forHTTPHeaderField:@"Applciaiton-Identifier"];
        [manager.requestSerializer setValue:[UIApplication performSelectorFromStringWithReturnObject:@"accessToken"] forHTTPHeaderField:@"Access-Token"];
        [manager.requestSerializer setValue:[UIApplication performSelectorFromStringWithReturnObject:@"userId"] forHTTPHeaderField:@"User-Identifier"];
        
//        if ([CUserDefaults valueForKey:UserDefaultLoginToken])
//            [manager.requestSerializer setValue:[CUserDefaults valueForKey:UserDefaultLoginToken] forHTTPHeaderField:@"token"];
    }
    
    return manager;
}

- (void)cancelAllRequests
{
        [[manager session] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            [self cancelTasksInArray:dataTasks];
            [self cancelTasksInArray:uploadTasks];
            [self cancelTasksInArray:downloadTasks];
        }];
}

- (void)cancelTasksInArray:(NSArray *)tasksArray
{
    for (NSURLSessionTask *task in tasksArray) {
            [task cancel];
    }
}


#pragma mark - Update File Upload Method for NSURLSession

- (NSURLSessionDataTask *)uploadFile:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    __block NSURLSessionUploadTask *uploadTask;
    
    NSURL* tmpFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]]]];
    
    NSMutableURLRequest *multipartRequest = [[[self sessionManager] requestSerializer] multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:[[self sessionManager] baseURL]] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    
    [[AFHTTPRequestSerializer serializer] requestWithMultipartFormRequest:multipartRequest
                                              writingStreamContentsToFile:tmpFileUrl
                                                        completionHandler:^(NSError *error) {

                                                            if (error) {
                                                                if (failure)
                                                                    failure(uploadTask, error);
                                                            } else
                                                            {
                                                                uploadTask = [[self sessionManager] uploadTaskWithRequest:multipartRequest fromFile:tmpFileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
                                                                    
                                                                    [[NSFileManager defaultManager] removeItemAtURL:tmpFileUrl error:nil];
                                                                    
                                                                    if (error) {
                                                                        if (failure)
                                                                            failure(uploadTask, error);
                                                                    } else {
                                                                        if (success)
                                                                            success(uploadTask, responseObject);
                                                                    }
                                                                    
                                                                }];
                                                                
                                                                [uploadTask resume];
                                                            }
                                                        }];
    
    return uploadTask;
}


#pragma mark - Override Calling methods

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [[self sessionManager] GET:URLString parameters:parameters progress:nil success:[self parseSuccessBlock:success] failure:[self parseFailureBlock:failure]];
}


- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [[self sessionManager] HEAD:URLString parameters:parameters success:success failure:[self parseFailureBlock:failure]];
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [[self sessionManager] POST:URLString parameters:parameters progress:nil success:[self parseSuccessBlock:success] failure:[self parseFailureBlock:failure]];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self uploadFile:URLString parameters:parameters constructingBodyWithBlock:block success:[self parseSuccessBlock:success] failure:[self parseFailureBlock:failure]];

//  Error in image uplaoing in some devices (iPhone5) and some os (ios7)
//    return [[self sessionManager] POST:URLString parameters:parameters constructingBodyWithBlock:block success:[self parseSuccessBlock:success] failure:[self parseFailureBlock:failure]];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [[self sessionManager] PUT:URLString parameters:parameters success:[self parseSuccessBlock:success] failure:[self parseFailureBlock:failure]];
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [[self sessionManager] PATCH:URLString parameters:parameters success:[self parseSuccessBlock:success] failure:[self parseFailureBlock:failure]];
}


- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [[self sessionManager] DELETE:URLString parameters:parameters success:[self parseSuccessBlock:success] failure:[self parseFailureBlock:failure]];
}


#pragma mark - API Blocks Parsing

-(id)parseSuccessBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))success
{
    typedef void (^Success) (NSURLSessionDataTask *task, id responseObject);
    
    Success block= ^(NSURLSessionDataTask *task, id responseObject){
        [self parseAPIResponse:responseObject];

        if (success)
            success(task,responseObject);
    };
    
    return block;
}

// No use of this, right now. remove in future if no more used.
-(id)parseFailureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    typedef void (^Failure) (NSURLSessionDataTask *task, NSError *error);
    
    Failure block= ^(NSURLSessionDataTask *task, NSError *error){
        
        if (failure)
            failure(task,error);
    };
    
    return block;
}

-(void)setParser:(void (^)(void))parser forAPIErrorCode:(NSInteger)errorcode
{
    [[self parser] setObject:parser forKey:[NSString stringWithFormat:@"%ld",(long)errorcode]];
}

#pragma mark - API Response Parsing

-(void)parseAPIResponse:(NSDictionary *)response
{
    [self parseApplicationResponse:response];

    if (!NSClassFromString(@"BasicAppDelegate"))
        return;

    
    @try {
        
        NSDictionary *responseDictionary = [response objectForKey:@"APIResponse"];
        
        NSArray *arrayCodes = [responseDictionary objectForKey:@"codes"];
        
        NSString *message = [response valueForKey:@"message"];
        
        
        arrayCodes = [arrayCodes sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"SELF" ascending:YES]]];
        
        for (int i=0; i<[arrayCodes count]; i++)
        {
            NSInteger code = (NSInteger)[arrayCodes objectAtIndex:i];
            
            switch (code)
            {
                case APIResponseNoActionRequired:
                    break;
                case APIResponseDisplayToastAlert:
                    break;
                case APIResponseDisplayAlertViewWithOkButton:
                    break;
                case APIResponseLogoutUserOnAlertViewAction:
                    break;
                case APIResponseResetCoreDataOnAlertViewAction:
                    break;
                case APIResponseDisableThisVersionOnAlertViewAction:
                    break;
                case APIResponseDisableThisInstallerOnAlertViewAction:
                    break;
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)parseApplicationResponse:(NSDictionary *)response
{
    if (![NSClassFromString(@"UIApplication") respondsToSelector:NSSelectorFromString(@"parseApplicaitonResponse:")])
        return;

        
    @try {
        
        [UIApplication parseApplicaitonResponse:response];
        
    }
    @catch (NSException *exception) {
    
    }
}

@end
