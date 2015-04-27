//
//  CustomTabBarViewController.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 13/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "MessagesViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor greenColor]}
                                           forState:UIControlStateNormal];
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:0];
    tabBarItem1.image = [[UIImage imageNamed:@"MessagesVerde.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:1];
    tabBarItem2.image = [[UIImage imageNamed:@"Verde.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];

    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:2];
    tabBarItem3.image = [[UIImage imageNamed:@"SettingsVede.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
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
