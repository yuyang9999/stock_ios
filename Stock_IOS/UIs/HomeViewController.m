//
//  HomeViewController.m
//  Stock_IOS
//
//  Created by yang yu on 9/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import "HomeViewController.h"
#import <RESideMenu/RESideMenu.h>
#import "NetworkUtil.h"
#import "NetworkApi.h"
#import "Profile.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 50, 100, 100);
    [button setTitle:@"Click" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonPressed:(id)sender {
//    RESideMenu *rootVc = (RESideMenu *)self.view.window.rootViewController;
//    [rootVc presentLeftMenuViewController];
//    /[NetworkUtil test];
    [NetworkUtil authWithUserName:@"tom" password:@"111111" completionHandler:^(BOOL succeed, NSError *error) {
        if (succeed) {
//            [NetworkUtil requestGetWithPath:@"/api/profiles" parameters:nil completionHandler:^(BOOL succeed, NSError *error, id obj) {
//                if (!succeed) {
//                    NSLog(@"%@", error);
//                }
//            }];
            [NetworkApi getProfiles:^(BOOL succeed, NSString *errorMsg, id obj) {
                if (succeed) {
                    NSArray<Profile*> *resp = obj;
                    NSLog(@"%@", resp);
                }
            }];
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
