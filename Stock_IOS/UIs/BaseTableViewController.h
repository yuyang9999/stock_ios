//
//  BaseTableViewController.h
//  Stock_IOS
//
//  Created by yang yu on 13/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

typedef void (^RefreshCompltionHandler)(void);

@interface BaseTableViewController : UITableViewController

- (void)refreshDataSourceWithCompletionHanlder:(RefreshCompltionHandler)handler;

@end
