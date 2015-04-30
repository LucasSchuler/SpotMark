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
@property NSMutableArray *friends;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _friends = [[NSMutableArray alloc]init];
    [self loadParticipants];
    _tableView.allowsMultipleSelection = YES;
    _user1 = [User sharedUser];
    _tableView.backgroundColor = [UIColor clearColor];
    
   
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadParticipants{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"objectId" equalTo:_idEvent];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            PFObject *a = [[query findObjects] objectAtIndex:0];
            [self selectFriends:a[@"members"]];
            [_tableView reloadData];
        }
    }];
}

-(void) selectFriends:(NSArray *)participants{
    NSMutableArray *selecteds = [_user1.friends_list mutableCopy];
    NSLog(@"%d",selecteds.count);
    for(int i=0;i<participants.count;i++){
        for(int j=0; j<selecteds.count;j++){
            NSDictionary<FBGraphUser> *friend = [selecteds objectAtIndex:j];
            if([participants[i] isEqualToString:friend.objectID]){
                [selecteds removeObjectAtIndex:j];
                break;
            }
        }
    }
    _friends = selecteds;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return _friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CustomCellInvite *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary<FBGraphUser> *friend = [_friends objectAtIndex:(int)indexPath.row];
    cell.name.text = friend.name;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cell.actIndicator startAnimating];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200", friend.objectID]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [cell.image setImage:[UIImage imageWithData:data]];
            cell.image.layer.cornerRadius = cell.image.frame.size.width / 2;
            cell.image.clipsToBounds = YES;
            [cell.actIndicator stopAnimating];
            self.tableView.estimatedRowHeight = 100.0;
            self.tableView.rowHeight = UITableViewAutomaticDimension;

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
        NSDictionary<FBGraphUser> *friend = [_friends objectAtIndex:(int)index];
        PFObject *object = [PFObject objectWithoutDataWithClassName:@"Event" objectId: _idEvent];
        [object addUniqueObject:friend.objectID forKey:@"members"];
        [object saveInBackground];
        
// Send a notification to all devices subscribed to the channel.
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:[@"user" stringByAppendingString:friend.objectID]];
        NSString *message = [_user1.name stringByAppendingString:@" invited you to\""];
        NSString *message2 =[message stringByAppendingString:_eventName];
        NSString *message3 =[message2 stringByAppendingString:@"\""];

        [push setMessage:message3];
        [push sendPushInBackground];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successfully invited friends!"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self performSegueWithIdentifier:@"backToOneEvent" sender:nil];
}



@end
