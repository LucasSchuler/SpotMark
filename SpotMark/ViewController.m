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
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:[@"user" stringByAppendingString:user1.objectId] forKey:@"channels"];
        [currentInstallation saveInBackground];
        
        
        PFUser *pfUser = [PFUser user];
        pfUser.username = user1.name;
        pfUser.objectId = user1.objectId;
        [pfUser saveInBackground];
        
        
        
        //REQUEST IMAGE
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200", user1.objectId ]];
             NSData *image = [NSData dataWithContentsOfURL:url];
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 user1.image = image;
             });
        });
        
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
