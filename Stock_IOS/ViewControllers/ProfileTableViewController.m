//
//  ProfileTableViewController.m
//  Stock_IOS
//
//  Created by yang yu on 12/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import "ProfileTableViewController.h"
#import <RESideMenu.h>
#import "Profile.h"
#import "NetworkApi.h"
#import "ProfilesPageViewController.h"
#import "ProfileDetailViewController.h"


@interface ProfileHeaderCell: UITableViewCell
@property (nonatomic) IBOutlet UILabel *label;
@end
@implementation ProfileHeaderCell
@end


@interface ProfileFootCell: UITableViewCell
@property (nonatomic) IBOutlet UIButton *button;
@end
@implementation ProfileFootCell
@end




@interface ProfileTableViewController () <UIPageViewControllerDataSource>
@property (strong, nonatomic) NSMutableArray<Profile*> *mProfileList;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.mProfileList = [NSMutableArray array];
    self.title = @"Home";
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonPressed)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)leftButtonPressed {
    RESideMenu *rootVc = (RESideMenu *)self.view.window.rootViewController;
    [rootVc presentLeftMenuViewController];
}

- (void)refreshDataSourceWithCompletionHanlder:(RefreshCompltionHandler)handler {
    
    __weak ProfileTableViewController *weakSelf = self;
    [NetworkUtil authWithUserName:@"tom" password:@"111111" completionHandler:^(BOOL succeed, NSError *error) {
        if (succeed) {
            [NetworkApi getProfiles:^(BOOL succeed, NSString *errorMsg, id obj) {
                if (succeed) {
                    NSArray *profiles = obj;
                    weakSelf.mProfileList = [NSMutableArray arrayWithArray:profiles];
                    handler();
                }
            }];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    } else {
        return self.mProfileList.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
        
        // Configure the cell...
        Profile *p = self.mProfileList[indexPath.row];
        cell.textLabel.text = p.pname;
        return cell;
    } else if (indexPath.section == 0) {
        ProfileHeaderCell *header = [tableView dequeueReusableCellWithIdentifier:@"profileHeaderCell" forIndexPath:indexPath];
        header.label.text = @"Profiles header";
        return header;
    } else if (indexPath.section == 2) {
        ProfileFootCell *footer = [tableView dequeueReusableCellWithIdentifier:@"profileFootCell" forIndexPath:indexPath];
        UIButton *btn = footer.button;
        [btn addTarget:self action:@selector(addProfileBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        return footer;
    } else {
        assert(0);
    }
    
    return nil;
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section != 1) {
        return NO;
    }
    
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Profile *p = self.mProfileList[indexPath.row];
        
        __weak ProfileTableViewController *ws = self;
        [NetworkApi deleteProfie:p.pname completionHandler:^(BOOL succeed, NSString *error, id obj) {
            if (succeed) {
                [ws.mProfileList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ProfilesPageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profilesPageVC"];
    vc.mProfiles = self.mProfileList;
    vc.mStartIndex = indexPath.row;
//    vc.dataSource = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 1) {
        return NO;
    }
    return YES;
}

#pragma mark - actions
- (void)addProfileBtnPressed:(UIButton *)btn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Create New Profile" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"profile name";
        textField.textAlignment = NSTextAlignmentLeft;
    }];
    
    __weak ProfileTableViewController *weakSelf = self;
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields[0];
        NSString *text = textField.text;
        if (text != nil && text.length > 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [NetworkApi createProfile:text completionHandler:^(BOOL succeed, NSString *errorMsg, id obj) {
                NSString *msg = nil;
                if (succeed) {
                    msg = @"created succeed";
                } else {
                    msg = errorMsg;
                }
                hud.label.text = msg;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (succeed) {
                        [weakSelf refreshDataSourceWithCompletionHanlder:^{
                            [weakSelf.tableView reloadData];
                            [hud hideAnimated:YES];
                        }];
                    }
                });
                
            }];
        } else {
#warning create another alert view controller to display the error message
        }
    }];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - page view controller data source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (self.mProfileList.count <= 1) {
        return nil;
    }
    
    ProfileDetailViewController *cur = (ProfileDetailViewController *)viewController;
    Profile *p = cur.mProfile;
    NSUInteger idx = [self.mProfileList indexOfObject:p];
    
    ProfileDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profileDetailVc"];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (self.mProfileList.count <= 1) {
        return nil;
    }
    
    ProfileDetailViewController *cur = (ProfileDetailViewController*)viewController;
    Profile *p = cur.mProfile;
    NSUInteger idx = [self.mProfileList indexOfObject:p];
    
    
    ProfileDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profileDetailVc"];
    
    return vc;
    
}


@end
