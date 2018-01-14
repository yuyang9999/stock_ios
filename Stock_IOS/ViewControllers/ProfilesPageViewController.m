//
//  ProfilesPageViewController.m
//  Stock_IOS
//
//  Created by yang yu on 13/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import "ProfilesPageViewController.h"
#import "ProfileDetailViewController.h"

@interface ProfilesPageViewController () <UIPageViewControllerDataSource>

@end

@implementation ProfilesPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    
    NSMutableArray *controllers = [NSMutableArray array];
    UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"profileDetailNavi"];
    
    ProfileDetailViewController *detail = navi.viewControllers[0];
    detail.mProfile = self.mProfiles[self.mStartIndex];
    [controllers addObject:navi];
    
    [self setViewControllers:controllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (self.mProfiles.count <= 1) {
        return nil;
    }
    
    UINavigationController *cur = (UINavigationController *)viewController;
    Profile *p = ((ProfileDetailViewController *)cur.viewControllers[0]).mProfile;
    NSUInteger idx = [self.mProfiles indexOfObject:p];
    
    if (idx == 0) {
        return nil;
    }
    
    UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"profileDetailNavi"];
    
    ProfileDetailViewController *vc = navi.viewControllers[0];
    vc.mProfile = self.mProfiles[idx-1];
    
    return navi;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (self.mProfiles.count <= 1) {
        return nil;
    }
    
    UINavigationController *cur = (UINavigationController *)viewController;
    Profile *p = ((ProfileDetailViewController *)cur.viewControllers[0]).mProfile;
    NSUInteger idx = [self.mProfiles indexOfObject:p];
    
    if (idx == self.mProfiles.count - 1) {
        return nil;
    }
    
    UINavigationController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"profileDetailNavi"];
    ProfileDetailViewController *vc = navi.viewControllers[0];
    vc.mProfile = self.mProfiles[idx + 1];
    return navi;
}

@end
