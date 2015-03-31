//
//  EventsViewController.m
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 19/02/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "EventsViewController.h"
#import "OneEventViewController.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "Event.h"
#import "loadParse.h"
#import "User.h"
#import "EventTableCell.h"

@interface EventsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property Event *evt;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0.97 blue:0.84 alpha:0.70]};
   
    self.title = @"Events";
  
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 100;
    _tableView.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [_tableView reloadData];
    loadParse *lp = [[loadParse alloc] init];
    User *user1 = [User sharedUser];
    _events = [lp loadEvents:user1.objectId];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    EventTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PFObject *e = [_events objectAtIndex:(int)indexPath.row];
    cell. = e[@"name"];
    cell.dateLabel.text = e[@"dateTime"];
    cell.localLabel.text = e[@"local"];
  //  cell.eventImage.image = e[@"category"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _evt = [[Event alloc] init];
    PFObject *e = [_events objectAtIndex:(int)indexPath.row];
    _evt.name = e[@"name"];
    _evt.desc = e[@"description"];
    _evt.local = e[@"local"];
    _evt.datetime = e[@"datetime"];
    _evt.admin = e[@"admin"];
    _evt.idEvent = e.objectId;
    [self performSegueWithIdentifier:@"gotoEventDetail" sender: indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotoEventDetail"]){
        OneEventViewController *oevt = (OneEventViewController *) segue.destinationViewController;
        oevt.evt = _evt;
    }
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
