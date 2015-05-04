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
#import <Parse/Parse.h>
#import "push.h"

@interface ViewController ()

@property BOOL isLogged;
@property BOOL load;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

-(void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    if (FBSession.activeSession.isOpen && _isLogged==false) {
        
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        User *user1 = [User sharedUser];
        user1.email = [user objectForKey:@"email"];
        user1.name = [user name];
        user1.objectId = [user objectID];

        PFUser *user = [PFUser user];
        user.username = user1.objectId;
        user.password = @"pass";
        user.email = user1.email;
        user[@"name"] = user1.name;
        
        [PFUser logInWithUsernameInBackground:user.username password:user.password block:^(PFUser *pfuser, NSError *error)
         {
             if (pfuser != nil)
             {
                 ParsePushUserAssign(user.username);
            }
             else{
                 [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                  {
                      if (error == nil)
                      {
                          ParsePushUserAssign(user.username);
                      }
                  }];
             }
         }];
        
        //REQUEST USER FRIENDS
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,NSDictionary* result,
                                                      NSError *error) {
            NSArray* friends = [result objectForKey:@"data"];
                    user1.friends_list = [friends mutableCopy];
        }];
        
        //NEXT SEGUE
        _isLogged=true;
        [self performSegueWithIdentifier:@"gotoEvents" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
