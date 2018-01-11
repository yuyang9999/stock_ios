//
//  ProfileStock.h
//  Stock_IOS
//
//  Created by yang yu on 11/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>


@protocol ProfileStock;

@interface ProfileStock : JSONModel

@property (readwrite, nonatomic) int sid;
@property (readwrite, nonatomic) int userId;
@property (readwrite, nonatomic) int pid;
@property (strong, nonatomic) NSString *sname;
@property (readwrite, nonatomic) float price;
@property (readwrite, nonatomic) int share;
@property (strong, nonatomic) NSDate *boughtTime;

@end
