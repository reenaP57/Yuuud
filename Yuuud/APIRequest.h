//
//  APIRequest.h
//  AFNetworking iOS Example
//
//  Created by mac-0001 on 5/11/14.
//  Copyright (c) 2014 uVite LLC. All rights reserved.
//

// Staus/Response Constants
// Framework

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIImageView+AFNetworking.h"



@interface APIRequest : NSObject

+ (id)request;

#pragma mark - LRF
#pragma mark -

- (void)signupWithUserName:(NSString *)username completion:(void (^)(id responseObject,NSError *error))completion;

- (void)editUsername:(NSString *)username completion:(void(^)(id responseObject, NSError *error))completion;

- (void)addYuuudWithName:(NSString *)yuuud_name andYuuud_audio:(NSData *)yuuud_audio duration:(double)duration frequency:(NSArray *)frequency  completion:(void (^)(id responseObject, NSError *error))completion;

- (NSURLSessionDataTask*)getYuuudList:(NSInteger)iLimit offset:(NSInteger)iOffset refreshControl:(UIRefreshControl *)refreshControl completion:(void (^)(id responseObject, NSError *error))completion;

- (NSURLSessionDataTask*)getCommentList:(NSString *)yuuud_id andOffset:(NSInteger)iOffset andLimit:(NSInteger)iLimit completion:(void(^)(id responseObject, NSError *error))completion;

- (void)getYuuudDetailWithID:(NSString *)yuuud_id completion:(void(^)(id responseObject, NSError *error))completion;

- (void)addYuuudCommentWithID:(NSString *)yuuud_id andComment:(NSString *)comment completion:(void (^)(id responseObject,NSError *error))completion;

- (NSURLSessionDataTask*)likeYuuudWithYuuudID:(NSString *)yuuud_id andLikeStatus:(NSInteger)like_status completion:(void (^)(id responseObject, NSError *error))completion;

- (NSURLSessionDataTask*)likeCommentWithID:(NSString *)comment_id andYuuudID:(NSString *)yuuud_id andLikeStatus:(NSInteger)like_status completion:(void (^)(id responseObject, NSError *error))completion;

- (void)registerUserDeviceID:(NSString *)device_id completion:(void (^)(id responseObject,NSError *error))completion;

- (NSURLSessionDataTask*)updateNotificationSetting:(NSNumber *)type status:(NSNumber *)status completion:(void (^)(id responseObject,NSError *error))completion;


@end
