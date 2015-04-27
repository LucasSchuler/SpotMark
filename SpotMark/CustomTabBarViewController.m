//
//  CustomTabBarViewController.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 13/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import <UIKit/UIKit.h>

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateSelected];

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor colorWithRed:8/255 green:60/255 blue:50/255 alpha:1]}
                                           forState:UIControlStateNormal];

    self.selectedIndex = 1;
    
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
