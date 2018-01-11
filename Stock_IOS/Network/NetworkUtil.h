//
//  NetworkUtil.h
//  Stock_IOS
//
//  Created by yang yu on 9/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiResp.h"

typedef void (^CompletionHandler)(BOOL succeed, NSError *error);
typedef void (^CompletionhandlerWithObj)(BOOL succeed, NSString *error, id obj);

@interface NetworkUtil : NSObject

+ (BOOL)isAuthorized;

+ (void)authWithUserName:(NSString *)userName password:(NSString *)password completionHandler:(CompletionHandler) handler;

+ (void)requestGetWithPath:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(CompletionhandlerWithObj) handler;

+ (void)requestPostWithPath:(NSString *)path paramaters:(NSDictionary *)parameters completionHandler:(CompletionhandlerWithObj) handler;

+ (void)test;


@end
