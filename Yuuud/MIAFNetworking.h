//
//  MIAFNetworking.h
//  AFNetworking
//
//  Created by mac-0001 on 14/03/15.
//  Copyright (c) 2015 mac-0001. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"


#ifndef _MIAFNetworking_H
    #define MIAFNetworking_H
#endif



#define AFNETWORKING_VERSION @"2.0"


@interface MIAFNetworking : NSObject


@property (nonatomic,strong) NSString *baseURL;

@property (nonatomic,assign) BOOL disableTracing;

@property (nonatomic,assign) BOOL disableCustomHeaders;


@property (nonatomic,assign) NSTimeInterval apiResponseTimeNotificaiton;

+ (instancetype)sharedInstance;

- (AFHTTPSessionManager *)sessionManager;


- (void)cancelAllRequests;


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


-(void)setParser:(void (^)(void))parser forAPIErrorCode:(NSInteger)errorcode;

- (NSURLSessionDataTask *)uploadFile:(NSString *)URLString
                          parameters:(id)parameters
           constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



@end


// ================================================================================================================

// Version Changes

// ================================================================================================================

/*
 
 // 2.0
 
 - Remove Rechability Status Checking Code
 - Remove NSURLCache Initialization Code.
 
 
 - Add common MIAFNetworknig session with custom headers
 - Add AFNetworking Logger
 ## - Add gzip Compression, Not used it yet.
 
 */




