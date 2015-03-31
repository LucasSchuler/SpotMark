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

@interface OneEventViewController () <MKMapViewDelegate>

@property User *user1;
@property loadParse *lp;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet UILabel *eventAdress;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UIButton *invite;
@property (weak, nonatomic) IBOutlet UIButton *exit;

@end

@implementation OneEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //SE O USUARIO NAO CRIOU O EVENTO O BOTAO P/ CONVIDAR NAO APARECE
    _user1 = [User sharedUser];
    if(![_user1.email isEqual:_evt.admin]){
        _invite.hidden=YES;
        _exit.titleLabel.text = @"Sair do evento";
    }
    
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0.97 blue:0.84 alpha:0.70]};
    self.title = _evt.name;
    
    //[_mapView setZoomEnabled:YES];
    
    _eventName.text = _evt.name;
    _eventDescription.text = _evt.desc;
    _eventAdress.text = _evt.local;
    [self loadPosts];
    if(_newEvent)
        [self Invite:nil];
}

-(void)loadPosts{
    _lp = [[loadParse alloc]init];
    _posts = [_lp loadPosts:_evt.idEvent];
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
        NSLog(@"%@", map.txtAdress);
    }else if([segue.identifier isEqualToString:@"gotoInviteFromEvent"]){
        InviteViewController *ivc = (InviteViewController *) segue.destinationViewController;
        ivc.idEvent = _evt.idEvent;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *e = [_posts objectAtIndex:(int)indexPath.row];
    cell.textLabel.text = e[@"post"];
    return cell;
}

- (IBAction)postar:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Post"
                              message:@"Please enter your post:"
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Ok", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    /* Display a numerical keypad for this text field */
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]){
        NSString *post = [alertView textFieldAtIndex:0].text;
        PFObject *saveObject = [PFObject objectWithClassName:@"Post"];
        saveObject[@"idEvent"] = _evt.idEvent;
        saveObject[@"post"] = post;
        [saveObject saveInBackground];
        [self loadPosts];
        [_tableView reloadData];
    }
}

- (IBAction)abrirChat:(id)sender {
    //TODO
}

- (IBAction)Invite:(id)sender {
    [self performSegueWithIdentifier:@"gotoInviteFromEvent" sender:nil];
}

- (IBAction)sair:(id)sender {
    if(![_user1.email isEqual:_evt.admin])
        [_lp sairEvento:_user1.objectId : _evt.idEvent];
    else
        [_lp excluirEvento:_evt.idEvent];
}

- (IBAction)participants:(id)sender {
    //TODO
}

-(IBAction)backFromInvite:(UIStoryboardSegue *)segue
{
}

//
//- (void)zoomIn{
//    MKUserLocation *userLocation = _mapView.userLocation;
//    MKCoordinateRegion region =
//    MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, );
//    [_mapView setRegion:region animated:NO];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
