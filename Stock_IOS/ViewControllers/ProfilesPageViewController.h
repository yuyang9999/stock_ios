//
//  ProfilesPageViewController.h
//  Stock_IOS
//
//  Created by yang yu on 13/1/18.
//  Copyright © 2018年 yang yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"

@interface ProfilesPageViewController : UIPageViewController

@property (strong, nonatomic) NSArray<Profile *> *mProfiles;

@property (readwrite, nonatomic) NSUInteger mStartIndex;


@end
