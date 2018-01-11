//
//  NetworkApi.m
//  Stock_IOS
//
//  Created by yang yu on 11/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import "NetworkApi.h"
#import "NetworkUtil.h"
#import "ApiResp.h"

#define API_PREFIX @"/api"
#define PROFILE @"/profiles"
#define PROFILE_CREATE @"/profile_add"
#define PROFILE_DELETE @"/profile_delete"

#define PROFILE_SYMBOL @"/profile_symbols"
#define PROFILE_SYMBOL_ADD @"/profile_only_add_symbol"
#define PROFILE_SYMBOL_DELETE @"/profile_symbol_delete"

@implementation NetworkApi

/**
 * return ApiResp if succeed
 */
+ (ApiResp *)handleResp:(NSDictionary *)resp netWorkStatus:(BOOL)succeed netWorkErrorMsg:(NSString *)msg compltionHandler:(CompletionWithErrorMsg)handler cls:(Class)cls{
    if (!succeed || resp == nil) {
        if (msg != nil) {
            handler(NO, msg, nil);
        } else {
            handler(NO, @"Network Error", nil);
        }
        return nil;
    }
    
    NSError *error;
    ApiResp *apiResp = [[cls alloc] initWithDictionary:resp error:&error];
    if (error != nil) {
        handler(NO, @"Network Error", nil);
        return nil;
    }
    
    if (apiResp.hasError) {
        handler(NO, apiResp.errorMsg, nil);
        return nil;
    }
    
    return apiResp;
}


+ (void)getProfiles:(CompletionWithErrorMsg)handler {
    NSString *path = [API_PREFIX stringByAppendingString:PROFILE];
    [NetworkUtil requestGetWithPath:path parameters:nil completionHandler:^(BOOL succeed, NSString *error, id obj) {
        ApiProfileResp *resp = (ApiProfileResp *)[self handleResp:obj netWorkStatus:succeed netWorkErrorMsg:error compltionHandler:handler cls:ApiProfileResp.class];
        if (resp) {
            handler(YES, nil, resp.response);
        }
    }];
}

+ (void)createProfile:(NSString *)pname completionHandler:(CompletionWithErrorMsg)handler {
    NSString *path = [API_PREFIX stringByAppendingString:PROFILE_CREATE];
    [NetworkUtil requestGetWithPath:path parameters:@{@"pname":path} completionHandler:^(BOOL succeed, NSString *error, id obj) {
        ApiBoolResp *resp = (ApiBoolResp *)[self handleResp:obj netWorkStatus:succeed netWorkErrorMsg:error compltionHandler:handler cls:ApiBoolResp.class];
        if (resp) {
            handler(YES, nil, nil);
        }
    }];
}

+ (void)deleteProfie:(NSString *)pname completionHandler:(CompletionhandlerWithObj)handler {
    NSString *path = [API_PREFIX stringByAppendingString:PROFILE_DELETE];
    [NetworkUtil requestPostWithPath:path paramaters:@{@"pname":pname} completionHandler:^(BOOL succeed, NSString *error, id obj) {
        ApiBoolResp *resp = (ApiBoolResp *)[self handleResp:obj netWorkStatus:succeed netWorkErrorMsg:error compltionHandler:handler cls:ApiBoolResp.class];
        if (resp) {
            handler(YES, nil, nil);
        }
    }];
}

+ (void)getProfileStocks:(Profile *)profile completionHandler:(CompletionhandlerWithObj)handler {
    NSString *path = [API_PREFIX stringByAppendingString:PROFILE_SYMBOL];
    [NetworkUtil requestGetWithPath:path parameters:@{@"pname": profile.pname} completionHandler:^(BOOL succeed, NSString *error, id obj) {
        ApiProfileStockResp *resp = (ApiProfileStockResp *)[self handleResp:obj netWorkStatus:succeed netWorkErrorMsg:error compltionHandler:handler cls:ApiProfileStockResp.class];
        if (resp) {
            handler(YES, nil, resp.response);
        }
    }];
}

+ (void)addProfileStock:(NSString *)pname stockName:(NSString *)sname completionHandler:(CompletionhandlerWithObj)handler {
    NSString *path = [API_PREFIX stringByAppendingString:PROFILE_SYMBOL_ADD];
    [NetworkUtil requestGetWithPath:path parameters:@{@"pname":pname, @"sname":sname} completionHandler:^(BOOL succeed, NSString *error, id obj) {
        ApiBoolResp *resp = (ApiBoolResp *)[self handleResp:obj netWorkStatus:succeed netWorkErrorMsg:error compltionHandler:handler cls:ApiBoolResp.class];
        if (resp) {
            handler(YES, nil, nil);
        }
    }];
}

+ (void)deleteProfileSymbol:(NSString *)pname symbol:(int)profileStockId completionHandler:(CompletionhandlerWithObj)handler {
    NSString *path = [API_PREFIX stringByAppendingString:PROFILE_SYMBOL_DELETE];
    [NetworkUtil requestPostWithPath:path paramaters:@{@"pname":pname, @"profile_stock_id":@(profileStockId)} completionHandler:^(BOOL succeed, NSString *error, id obj) {
        ApiBoolResp *resp = (ApiBoolResp *)[self handleResp:obj netWorkStatus:succeed netWorkErrorMsg:error compltionHandler:handler cls:ApiBoolResp.class];
        if (resp) {
            handler(YES, nil, nil);
        }
    }];
}


@end
