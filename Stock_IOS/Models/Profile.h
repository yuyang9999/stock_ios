//
//  Profile.h
//  Stock_IOS
//
//  Created by yang yu on 10/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ModelBase.h"

@protocol Profile;


@interface Profile : ModelBase

@property (readwrite, nonatomic) int pid;
@property (readwrite, nonatomic) int userId;
@property (strong, nonatomic) NSString *pname;

@end
