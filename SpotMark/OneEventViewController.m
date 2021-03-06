//
//  OneEventViewController.m
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 25/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "OneEventViewController.h"
#import "Event.h"
#import "loadParse.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "InviteViewController.h"
#import "ParticipantsViewController.h"
#import "Participant.h"
#import "CustomCellPost.h"
#import "ChatView.h"
#import "push.h"


@interface OneEventViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property User *user1;
@property loadParse *lp;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (weak, nonatomic) IBOutlet UILabel *eventAdress;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UIButton *invite;
@property (weak, nonatomic) IBOutlet UIButton *exit;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActIndicator;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;

@property BOOL loaded;
@property UITextView *textView;
@property NSArray *idParticipants;

@end

@implementation OneEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _eventImage.image = [UIImage imageNamed:_evt.category];
    
    //SE O USUARIO NAO CRIOU O EVENTO O BOTAO P/ CONVIDAR NAO APARECE
    _user1 = [User sharedUser];
    if(![_user1.email isEqual:_evt.admin]){
        _invite.hidden=YES;
        [_exit setTitle:@"Exit Event" forState:UIControlStateNormal];
    }
    
    self.tabBarController.tabBar.hidden = YES;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.title = _evt.name;
    _eventName.text = _evt.name;
    _eventDescription.text = _evt.desc;
    _eventAdress.text = _evt.local;
    _dateTime.text = _evt.datetime;
    [self loadPosts];
    if(_newEvent)
       [self Invite:nil];
    
    
}

-(void)loadPosts{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _lp = [[loadParse alloc]init];
        _posts = [_lp loadPosts:_evt.idEvent];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [_tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewMap:(id)sender {
    [self performSegueWithIdentifier:@"goToMap" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToMap"]){
        MapViewController *map = (MapViewController *) segue.destinationViewController;
        map.txtAdress = _evt.local;
    }else if([segue.identifier isEqualToString:@"gotoInviteFromEvent"]){
        InviteViewController *ivc = (InviteViewController *) segue.destinationViewController;
        ivc.idEvent = _evt.idEvent;
        ivc.eventName = _evt.name;
    }else if([segue.identifier isEqualToString:@"gotoParticipants"]){
        ParticipantsViewController *pc = (ParticipantsViewController *) segue.destinationViewController;
        pc.idEvent = _evt.idEvent;
        pc.participants = _evt.participants;
    }else if([segue.identifier isEqualToString:@"backtoEventFromEvent"]){
    }

}

- (BOOL) hidesBottomBarWhenPushed{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CustomCellPost *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    PFObject *e = [_posts objectAtIndex:(int)indexPath.row];
    cell.name.text = e[@"name"];
    cell.date.text = e[@"datetime"];
    cell.post.text = e[@"post"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (IBAction)postar:(id)sender {
    UIAlertView *testAlert = [[UIAlertView alloc] initWithTitle:@"Post"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Done", nil];
    _textView = [UITextView new];
    [testAlert setValue: _textView forKey:@"accessoryView"];
    [testAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]){
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"d/M/YYYY HH:mm"];
        NSString *post = _textView.text;
        PFObject *saveObject = [PFObject objectWithClassName:@"Post"];
        saveObject[@"idEvent"] = _evt.idEvent;
        saveObject[@"post"] = post;
        saveObject[@"name"] = _user1.name;
        saveObject[@"datetime"] = [DateFormatter stringFromDate:[NSDate date]];
        [saveObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if(succeeded){
                [self loadPosts];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        pushEvent(_evt.idEvent, _evt.name,0,@"");
    }
}

- (IBAction)abrirChat:(id)sender {
    ChatView *chatView = [[ChatView alloc] initWith:_evt.idEvent];
    chatView.hidesBottomBarWhenPushed = YES;
    chatView.name = _evt.name;
    [self.navigationController pushViewController:chatView animated:YES];
}

- (IBAction)Invite:(id)sender {
    [self performSegueWithIdentifier:@"gotoInviteFromEvent" sender:nil];
}

- (IBAction)sair:(id)sender {
    if(![_user1.email isEqual:_evt.admin])
        [_lp sairEvento:_user1.objectId : _evt.idEvent];
    else
        [_lp excluirEvento:_evt.idEvent];
    [self performSegueWithIdentifier:@"backtoEventFromEvent" sender:nil];
}

- (IBAction)participants:(id)sender {
    [self loadParticipants];
}

-(void) loadParticipants{
    _loaded = NO;
    [_ActIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger limit = 1000;
        NSUInteger skip = 0;
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        [query whereKey:@"objectId" equalTo:_evt.idEvent];
        [query setLimit: limit];
        [query setSkip: skip];
        PFObject *a = [[query findObjects] objectAtIndex:0];
        NSArray *b = a[@"members"];
        
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" containedIn:b];
        
        NSArray *users = userQuery.findObjects;
        
        NSMutableArray *participants = [[NSMutableArray alloc]init];
        for(int i=0; i<b.count; i++){
            Participant *p = [[Participant alloc]init];
            PFUser *uu = users[i];
            p.name = uu[@"name"];
            p.userid = b[i];
            p.channel = [@"user" stringByAppendingString:b[i]];
            [participants addObject:p];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            _idParticipants = b;
            _evt.participants = participants;
            _loaded = YES;
            [_ActIndicator stopAnimating];
            [self performSegueWithIdentifier:@"gotoParticipants" sender:nil];

        });
    });
}



-(IBAction)backFromInvite:(UIStoryboardSegue *)segue
{
}

- (void)goBack:(id)sender {
    [self performSegueWithIdentifier:@"backtoEventFromEvent" sender:nil];
}

//HANDOFF
- (void)restoreUserActivityState:(NSUserActivity *)activity  {
    
    
    NSString *userInfo = [activity userInfo];
        
    [super restoreUserActivityState : activity];
}












@end
