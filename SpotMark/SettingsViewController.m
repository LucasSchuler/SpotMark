//
//  SettingsViewController.m
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 25/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property User *user1;
@property BOOL isLogged;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user1 = [User sharedUser];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0.97 blue:0.84 alpha:0.70]};
    self.title = @"Settings";
    [self loadUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadUser{
    _lblUsername.text = _user1.name;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200", _user1.objectId]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [_image setImage:[UIImage imageWithData:data]];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
   [self performSegueWithIdentifier:@"gotoLogin" sender:nil];
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
