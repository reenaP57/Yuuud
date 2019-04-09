
//
//  APIRequest.m
//  AFNetworking iOS Example
//
//  Created by mac-0001 on 5/11/14.
//  Copyright (c) 2014 uVite LLC. All rights reserved.
//

#import "APIRequest.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIImageView+AFNetworking.h"
#import "MIAFNetworking.h"
#import "Config.h"

#define CLogin              @"login"
#define CSignup             @"signup"
#define CEditUser           @"editUser"
#define CAddYuuud           @"addYuuud"
#define CAddComment         @"addComment"
#define CLikeYuuud          @"likeYuuud"
#define CLikeComment        @"likeComment"
#define CUserDevice         @"userDevice"
#define CYuuudList          @"yuuudList"
#define CCommentList        @"commentList"
#define CYuuudDetail        @"yuuudDetail"
#define CNotificationSettings    @"updateNotification"

static APIRequest *request = nil;

@implementation APIRequest

+ (id)request
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
     {
         request = [[APIRequest alloc] init];
         [[MIAFNetworking sharedInstance] setBaseURL:BASEURL];
    
         NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] initWithIndexSet:[[[[MIAFNetworking sharedInstance] sessionManager] responseSerializer] acceptableStatusCodes]];
        
         [indexSet addIndex:400];
         
         [[[MIAFNetworking sharedInstance] sessionManager] responseSerializer].acceptableStatusCodes = indexSet;
     });
    
    if([CUserDefaults valueForKey:CToken])
    {
        [[[[MIAFNetworking sharedInstance] sessionManager] requestSerializer] setValue:[UIApplication userId] forHTTPHeaderField:@"token"];
    }
    else
        [[[[MIAFNetworking sharedInstance] sessionManager] requestSerializer] setValue:@"" forHTTPHeaderField:@"token"];
    
    return request;
}


#pragma mark - Signup

- (void)signupWithUserName:(NSString *)username completion:(void (^)(id responseObject,NSError *error))completion
{
    [[PPLoader sharedLoader] ShowHudLoader];
    
    [[MIAFNetworking sharedInstance]POST:CSignup parameters:@
     {
         @"username":username
     }
                                 success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CSignup])
         {
             NSDictionary *dicData = [responseObject objectForKey:CJsonData];
             
             if([dicData objectForKey:@"token"] && [[dicData objectForKey:@"token"] isKindOfClass:[NSString class]])
             {
                 NSString *strToken = [dicData objectForKey:@"token"];
                 [CUserDefaults setObject:strToken forKey:CToken];
                 [CUserDefaults synchronize];
                 
                 [UIApplication setUserId:strToken];
                 
                 if([CUserDefaults objectForKey:CFCMToken])
                 {
                     [[APIRequest request] registerUserDeviceID:[CUserDefaults objectForKey:CFCMToken] completion:^(id responseObject, NSError *error) {
                         
                         NSLog(@"Response : %@",responseObject);
                         
                     }];
                 }
             }
             
             if(completion)
                 completion(responseObject, nil);
         }
     }
                                 failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self actionOnAPIFailure:error showAlert:YES api:CSignup];
     }];
}

#pragma mark - Edit Username

- (void)editUsername:(NSString *)username completion:(void(^)(id responseObject, NSError *error))completion
{
    [[PPLoader sharedLoader] ShowHudLoader];
    
    [[MIAFNetworking sharedInstance] POST:CEditUser parameters:@
     {
         @"username":username
     }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CEditUser])
         {
             if(completion)
                 completion(responseObject, nil);
         }
     }
                                  failure:^(NSURLSessionDataTask *task, NSError *error)
     
     {
         [self actionOnAPIFailure:error showAlert:YES api:CEditUser];
     }];
}

#pragma mark - Add Audio(Yuuud)

- (void)addYuuudWithName:(NSString *)yuuud_name andYuuud_audio:(NSData *)yuuud_audio duration:(double)duration frequency:(NSArray *)frequency  completion:(void (^)(id responseObject, NSError *error))completion
{
    //[[PPLoader sharedLoader] ShowHudLoader];
    
    NSString *strFormatted = [[NSString stringWithFormat:@"%@", frequency] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    strFormatted = [strFormatted stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    strFormatted = [strFormatted stringByReplacingOccurrencesOfString:@"(" withString:@"["];
    
    strFormatted = [strFormatted stringByReplacingOccurrencesOfString:@")" withString:@"]"];
    
    strFormatted = [strFormatted stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //NSString *strLocation = @"";
    
    [[MIAFNetworking sharedInstance] POST:CAddYuuud parameters:@
     {
         @"yuuud_name":yuuud_name,
         @"latitude":@([CUserDefaults doubleForKey:CCurrentLatitude]),
         @"longitude":@([CUserDefaults doubleForKey:CCurrentLongitude]),
         @"location_name":[CUserDefaults objectForKey:CCurrentLocation],
         //@"location_name":strLocation,
         @"yuuud_duration":@(duration),
         @"frequency": strFormatted
     }
                constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
//         [formData appendPartWithFileData:yuuud_audio name:@"yuuud_audio" fileName:[NSString stringWithFormat:@"%f%@.mp3", [[NSDate date] timeIntervalSince1970], @"audio"] mimeType:@"audio/mp3"];
         
         [formData appendPartWithFileData:yuuud_audio name:@"yuuud_audio" fileName:[NSString stringWithFormat:@"%f%@.wav", [[NSDate date] timeIntervalSince1970], @"audio"] mimeType:@"audio/wav"];
     }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CAddYuuud])
         {
             if(completion)
                 completion(responseObject, nil);
         }
     }
      failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}

#pragma mark - Yuuud List

- (NSURLSessionDataTask*)getYuuudList:(NSInteger)iLimit offset:(NSInteger)iOffset refreshControl:(UIRefreshControl *)refreshControl completion:(void (^)(id responseObject, NSError *error))completion;
{
    //[[PPLoader sharedLoader] ShowHudLoader];
    
    return [[MIAFNetworking sharedInstance] POST:[NSString stringWithFormat:@"%@/%@/%@", CYuuudList, @(iLimit), @(iOffset)]
                                      parameters:@
    {
//        @"lat" : @([CUserDefaults doubleForKey:CCurrentLatitude]),
//        @"lng" : @([CUserDefaults doubleForKey:CCurrentLongitude])
        
        @"lat" : @(appDelegate.dLat),
        @"lng" : @(appDelegate.dLong)
    }
                                         success:^(NSURLSessionDataTask *task, id responseObject)
            {
                //[refreshControl endRefreshing];
                
                if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CYuuudList])
                {
                    if(completion)
                        completion(responseObject, nil);
                }
            }
                                         failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                
                [self actionOnAPIFailure:error showAlert:NO api:CYuuudList];
            }];
}

#pragma mark - Get Comment List

- (NSURLSessionDataTask*)getCommentList:(NSString *)yuuud_id andOffset:(NSInteger)iOffset andLimit:(NSInteger)iLimit completion:(void(^)(id responseObject, NSError *error))completion
{
    return [[MIAFNetworking sharedInstance]POST:[NSString stringWithFormat:@"%@/%@/%@", CCommentList, @(iLimit), @(iOffset)] parameters:@
    {
        @"yuuud_id":yuuud_id
    }
            
                                        success:^(NSURLSessionDataTask *task, id responseObject)
            {
                if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CCommentList])
                {
                    if(completion)
                        completion(responseObject, nil);
                }
                
            }
                                        failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                
                if(completion)
                    completion(nil, error);
                
                [self actionOnAPIFailure:error showAlert:NO api:CCommentList];
            }];
}

#pragma mark - Yuuud Detail

- (void)getYuuudDetailWithID:(NSString *)yuuud_id completion:(void(^)(id responseObject, NSError *error))completion
{
    [[MIAFNetworking sharedInstance] POST:CYuuudDetail parameters:@
     {
         @"yuuud_id":yuuud_id,
     }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CYuuudDetail])
         {
             if(completion)
                 completion(responseObject, nil);
         }
     }
                                  failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self actionOnAPIFailure:error showAlert:YES api:CYuuudDetail];
     }];

}

#pragma mark - Add Comment

- (void)addYuuudCommentWithID:(NSString *)yuuud_id andComment:(NSString *)comment completion:(void (^)(id responseObject,NSError *error))completion
{
    [[PPLoader sharedLoader] ShowHudLoaderWithText:CMessageLoading];
    
    [[MIAFNetworking sharedInstance] POST:CAddComment parameters:@
     {
         @"yuuud_id":yuuud_id,
         @"comment":comment
     }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CAddComment])
         {
             if(completion)
                 completion(responseObject, nil);
         }
     }
                                  failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self actionOnAPIFailure:error showAlert:YES api:CAddComment];
     }];
}

#pragma mark - Like Yuuud

- (NSURLSessionDataTask*)likeYuuudWithYuuudID:(NSString *)yuuud_id andLikeStatus:(NSInteger)like_status completion:(void (^)(id responseObject, NSError *error))completion
{
    return [[MIAFNetworking sharedInstance] POST:CLikeYuuud parameters:@
            {
                @"yuuud_id":yuuud_id,
                @"liked":@(like_status)
            }
            
                                         success:^(NSURLSessionDataTask *task, id responseObject)
            {
                if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CLikeYuuud])
                {
                    if(completion)
                        completion(responseObject, nil);
                }
            }
                                         failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                [self actionOnAPIFailure:error showAlert:NO api:CLikeYuuud];
            }];
}

#pragma mark - Like Comment

- (NSURLSessionDataTask*)likeCommentWithID:(NSString *)comment_id andYuuudID:(NSString *)yuuud_id andLikeStatus:(NSInteger)like_status completion:(void (^)(id responseObject, NSError *error))completion
{
    return [[MIAFNetworking sharedInstance] POST:CLikeComment parameters:@
    {
        @"yuuud_id":yuuud_id,
        @"comment_id":comment_id,
        @"liked":@(like_status)
    }
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CLikeComment])
         {
             if(completion)
                 completion(responseObject, nil);
         }
     }
                                  failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self actionOnAPIFailure:error showAlert:NO api:CLikeComment];
     }];
}

#pragma mark - Register User Device ID

- (void)registerUserDeviceID:(NSString *)device_id completion:(void (^)(id responseObject,NSError *error))completion
{
    if(![UIApplication userId])
        return;
    
   // [[PPLoader sharedLoader] ShowHudLoader];
    
    NSDictionary *dict = @
    {
        @"device_id":device_id,
        @"platform":@"0"
    };
    
    [[MIAFNetworking sharedInstance] POST:CUserDevice parameters:dict
     
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CUserDevice])
         {
             if(completion)
                 completion(responseObject, nil);
         }
         
     }
                                  failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self actionOnAPIFailure:error showAlert:YES api:CUserDevice];
     }];
}

- (NSURLSessionDataTask*)updateNotificationSetting:(NSNumber *)type status:(NSNumber *)status completion:(void (^)(id responseObject,NSError *error))completion
{
    NSDictionary *dict = @
    {
        @"notification_type":type,
        @"notification_status":status
    };
    
    return [[MIAFNetworking sharedInstance] POST:CNotificationSettings parameters:dict
     
                                  success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([self checkResponseStatusAndShowAlert:YES data:responseObject api:CNotificationSettings])
         {
             if ([responseObject objectForKey:CJsonData] && [[responseObject objectForKey:CJsonData] isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dicData = [responseObject objectForKey:CJsonData];
                 NSNumber *numType = [dicData numberForJson:@"notification_type"];
                 
                 if([numType isEqual:@1])
                     [CUserDefaults setBool:[[dicData numberForJson:@"notification_status"] isEqual:@1] forKey:CCommentNotification];
                 else
                     [CUserDefaults setBool:[[dicData numberForJson:@"notification_status"] isEqual:@1] forKey:CLikeNotification];
                 
                 [CUserDefaults synchronize];
             }
             
             if(completion)
                 completion(responseObject, nil);
         }
     }
                                  failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self actionOnAPIFailure:error showAlert:NO api:CNotificationSettings];
     }];
}

#pragma mark - Common Functions
#pragma mark -

-(BOOL)checkResponseStatusAndShowAlert:(BOOL)showAlert data:(NSDictionary *)responseobject api:(NSString *)api
{
    //NSLog(@"API Success = %@ == %@", api, responseobject);
    
    [[PPLoader sharedLoader] HideHudLoader];
    
    if (responseobject && [responseobject isKindOfClass:[NSDictionary class]])
    {
        if([[responseobject stringValueForJSON:CJsonStatus] isEqualToString:CStatusOne])
            return YES;
    }
    
    if (showAlert)
        [[PPAlerts sharedAlerts] showAlertWithType:0 withMessage:[responseobject stringValueForJSON:CJsonMessage] withTitle:CMessageSorry];
    
    return NO;
}

- (void)actionOnAPIFailure:(NSError *)error showAlert:(BOOL)showAlert api:(NSString *)api
{
    [[PPLoader sharedLoader] HideHudLoader];
    
    if (showAlert)
        [[PPAlerts sharedAlerts] showAlertWithType:0 withMessage:error.localizedDescription withTitle:CMessageSorry];
    
    NSLog(@"API Error = %@ == %@",api,error);
}


@end
