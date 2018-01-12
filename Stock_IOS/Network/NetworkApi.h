//
//  NetworkApi.h
//  Stock_IOS
//
//  Created by yang yu on 11/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkUtil.h"

@class Profile;

typedef void (^CompletionWithErrorMsg)(BOOL succeed, NSString *errorMsg, id obj);

@interface NetworkApi : NSObject

+ (void)getProfiles:(CompletionWithErrorMsg)handler;

+ (void)createProfile:(NSString *)pname completionHandler:(CompletionWithErrorMsg)handler;

+ (void)deleteProfie:(NSString *)pname completionHandler:(CompletionhandlerWithObj)handler;

+ (void)getProfileStocks:(NSString *) pname completionHandler:(CompletionhandlerWithObj)handler;

+ (void)addProfileStock:(NSString *)pname stockName:(NSString *)sname completionHandler:(CompletionhandlerWithObj)handler;

+ (void)deleteProfileSymbol:(NSString *)pname symbol:(int)profileStockId completionHandler:(CompletionhandlerWithObj)handler;

@end
