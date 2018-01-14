//
//  ProfileDetailViewController.m
//  Stock_IOS
//
//  Created by yang yu on 13/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "Profile.h"
#import "NetworkApi.h"
#import "ProfileStock.h"

//CJAMacros

#define WSWithNameAndObj(_obj, _name) __weak typeof(_obj) weak##_name = _obj;
#define WS WSWithNameAndObj(self, Self)

@interface ProfileDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *mStocks;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;


@end

@implementation ProfileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.mProfile.pname;
    self.mStocks = [NSMutableArray array];
    
    float r = (float)random() / RAND_MAX;
    self.view.backgroundColor = [UIColor colorWithWhite:r alpha:1.0];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed:)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    WS
    [self refreshDataSourceWithCompletionHanlder:^{
        [weakSelf.mTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)backBtnPressed:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - override parent function
- (void)refreshDataSourceWithCompletionHanlder:(RefreshCompltionHandler)handler {
    if (self.mProfile) {
        WS
        [NetworkApi getProfileStocks:self.mProfile.pname completionHandler:^(BOOL succeed, NSString *error, id obj) {
            if (succeed) {
                NSArray<ProfileStock *> *profiles = obj;
                weakSelf.mStocks = [NSMutableArray arrayWithArray:profiles];
                handler();
            }
        }];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - table view data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mStocks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    ProfileStock *stock = self.mStocks[indexPath.row];
    cell.textLabel.text = stock.sname;
    return cell;
}


@end
