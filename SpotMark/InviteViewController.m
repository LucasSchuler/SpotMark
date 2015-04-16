//
//  InviteViewController.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 27/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "InviteViewController.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CustonCellInvite.h"
#import <Parse/Parse.h>

@interface InviteViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property User *user1;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.allowsMultipleSelection = YES;
    _user1 = [User sharedUser];
    _friend_list = [[NSMutableArray alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _user1.friends_list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CustomCellInvite *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary<FBGraphUser> *friend = [_user1.friends_list objectAtIndex:(int)indexPath.row];
    cell.name.text = friend.name;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cell.actIndicator startAnimating];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200", friend.objectID]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [cell.image setImage:[UIImage imageWithData:data]];
            [cell.actIndicator stopAnimating];
        });
    });
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (IBAction)inviteFriends:(id)sender {
    NSArray *indexes = [_tableView indexPathsForSelectedRows];
    for (NSIndexPath *path in indexes) {
        NSInteger index = [path indexAtPosition:[path length] - 1];
        NSDictionary<FBGraphUser> *friend = [_user1.friends_list objectAtIndex:(int)index];
        PFObject *object = [PFObject objectWithClassName:@"UserEvent"];
        object [@"user"] = friend.objectID;
        object [@"userName"] = friend.name;
        object [@"event"] = _idEvent;
        [object saveInBackground];
        
        // Send a notification to all devices subscribed to the channel.
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:[@"user" stringByAppendingString:friend.objectID]];
        NSString *message = [_user1.name stringByAppendingString:@" Convidou você para o evento "];
        NSString *message2 =[message stringByAppendingString:_eventName];
        [push setMessage:message2];
        [push sendPushInBackground];
        
        
        
        
  
//        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//        [currentInstallation addUniqueObject:[@"event" stringByAppendingString:_idEvent] forKey:@"channels"];
//        [currentInstallation saveInBackground];
    }
    [self performSegueWithIdentifier:@"backToOneEvent" sender:nil];
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
