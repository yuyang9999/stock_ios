//
//  CustomNaviControllerViewController.m
//  Stock_IOS
//
//  Created by yang yu on 9/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import "CustomNaviControllerViewController.h"
#import <RESideMenu.h>

@interface CustomNaviControllerViewController ()

@end

@implementation CustomNaviControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuItemSelected)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)leftMenuItemSelected {
    RESideMenu *rootVc = (RESideMenu *)self.view.window.rootViewController;
    [rootVc presentLeftMenuViewController];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
