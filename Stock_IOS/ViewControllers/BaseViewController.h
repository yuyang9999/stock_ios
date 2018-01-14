//
//  BaseViewController.h
//  Stock_IOS
//
//  Created by yang yu on 13/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface BaseViewController : UIViewController

- (void)refreshDataSourceWithCompletionHanlder:(RefreshCompltionHandler)handler;

@end
