//
//  NetworkUtil.m
//  Stock_IOS
//
//  Created by yang yu on 9/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import "NetworkUtil.h"
#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import "ApiResp.h"

#define CLIENT_ID @"fooClientIdPassword"
#define CLIENT_SECRET @"secret"
#define BASE_URL @"http://localhost:8080"
#define OAUTH_PATH @"/oauth/token"
#define AUTH_STORE_KEY @"authStoreKey"

@interface NetworkUtil()
@property(strong, nonatomic) AFOAuth2Manager *manager;
@end


@implementation NetworkUtil

+ (id)sharedInstance {
    static NetworkUtil *util = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        util = [[self alloc] init];
    });
    return util;
}

- (id)init {
    self = [super init];
    if (self) {
        self.manager = [[AFOAuth2Manager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL] clientID:CLIENT_ID secret:CLIENT_SECRET];
    }
    
    return self;
}


+ (BOOL)isAuthorized {
    AFOAuthCredential *cred = [AFOAuthCredential retrieveCredentialWithIdentifier:AUTH_STORE_KEY];
    if (cred == nil) {
        return NO;
    }
    
    return !cred.isExpired;
}

+ (void)authWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(CompletionHandler)handler {
    AFOAuth2Manager *manager = [[self sharedInstance] manager];
    
    [manager authenticateUsingOAuthWithURLString:OAUTH_PATH username:userName password:password scope:nil success:^(AFOAuthCredential * _Nonnull credential) {
        if (![AFOAuthCredential storeCredential:credential withIdentifier:AUTH_STORE_KEY]) {
            NSAssert(0, @"can't save the credential object");
        }
        handler(YES, nil);
        
    } failure:^(NSError * _Nonnull error) {
        handler(NO, error);
    }];
}

+ (void)requestGetWithPath:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(CompletionhandlerWithObj)handler {
    if (![self isAuthorized]) {
        //todo jump to auth view controller
        handler(NO, @"Not Authorized", nil);
        return;
    }
    
    AFOAuthCredential *cred = [AFOAuthCredential retrieveCredentialWithIdentifier:AUTH_STORE_KEY];
    
    AFHTTPSessionManager *sessionMgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    [sessionMgr.requestSerializer setAuthorizationHeaderFieldWithCredential:cred];
    
    [sessionMgr GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {        
        handler(YES, nil, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handler(NO, error.localizedDescription, nil);
    }];
}

+ (void)requestPostWithPath:(NSString *)path paramaters:(NSDictionary *)parameters completionHandler:(CompletionhandlerWithObj)handler {
    if (![self isAuthorized]) {
        //
        handler(NO, nil, nil);
        return;
    }
    
    AFOAuthCredential *cred = [AFOAuthCredential retrieveCredentialWithIdentifier:AUTH_STORE_KEY];
    AFHTTPSessionManager *sessionMgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    [sessionMgr.requestSerializer setAuthorizationHeaderFieldWithCredential:cred];
    
    [sessionMgr POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        handler(YES, nil, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        handler(NO, error, nil);
    }];
    
}



+ (void)test {
    NSURL *baseURL = [NSURL URLWithString:@"http://127.0.0.1:8080"];
    AFOAuth2Manager *manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseURL clientID:@"fooClientIdPassword" secret:@"secret"];
    [manager authenticateUsingOAuthWithURLString:@"/oauth/token" username:@"tom" password:@"111111" scope:NULL success:^(AFOAuthCredential * _Nonnull credential) {
        NSLog(@"succeed");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"failed");
    }];
}


@end
