//
//  MessagesViewController.m
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 25/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "MessagesViewController.h"
#import <Parse/Parse.h>
#import "loadParse.h"
#import "Event.h"
#import "User.h"
#import "ChatViewController.h"

@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewM;
@property User *user1;
@property Event *evt;
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user1 = [User sharedUser];
    NSLog(@"%@",_user1);
    _tableViewM.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewM.rowHeight = 75;
    _tableViewM.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0.97 blue:0.84 alpha:0.70]};
    self.title = @"Messages";
    
}

-(void)viewWillAppear:(BOOL)animated{
    [_tableViewM reloadData];
    loadParse *lp = [[loadParse alloc] init];
    _events = [lp loadEvents:_user1.objectId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    PFObject *e = [_events objectAtIndex:(int)indexPath.row];
    cell.textLabel.text = e[@"name"];
    cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.72 blue:0.36 alpha:1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _evt = [[Event alloc] init];
    PFObject *e = [_events objectAtIndex:(int)indexPath.row];
    _evt.eventId = e.objectId;
    [self performSegueWithIdentifier:@"gotoChat" sender:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     if ([segue.identifier isEqualToString:@"gotoChat"]){
         ChatViewController *cvc = (ChatViewController *) segue.destinationViewController;
         cvc.eventId = _evt.eventId;
     }
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
