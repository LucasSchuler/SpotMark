//
//  ViewController.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 21/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface ViewController ()

@property BOOL isLogged;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

-(void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    if (FBSession.activeSession.isOpen && _isLogged==false) {
        
        //REQUEST USER FRIENDS
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,NSDictionary* result,
                                                      NSError *error) {
            NSArray* friends = [result objectForKey:@"data"];
            User *user1 = [User sharedUser];
            user1.email = [user objectForKey:@"email"];
            user1.name = [user name];
            user1.objectId = [user objectID];
            user1.friends_list = [friends mutableCopy];
        }];
        
        //NEXT SEGUE
        _isLogged=true;
        [self performSegueWithIdentifier:@"gotoEvents" sender:nil];
        
        
    }
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    NSLog(@"you are logged out! :(");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
