//
//  ApiResp.h
//  Stock_IOS
//
//  Created by yang yu on 10/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Profile.h"
#import "ProfileStock.h"

@interface ApiResp : JSONModel
@property (readwrite, nonatomic) BOOL hasError;
@property (strong, nonatomic) NSString *errorMsg;
@end

@interface ApiBoolResp: ApiResp
@property (readwrite, nonatomic) BOOL response;
@end

@interface ApiProfileResp: ApiResp
@property (strong, nonatomic) NSArray<Profile *> <Profile> *response;
@end

@interface ApiProfileStockResp: ApiResp
@property (strong, nonatomic) NSArray<ProfileStock *> <ProfileStock> *response;
@end
