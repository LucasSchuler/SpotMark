//
//  MessagesViewController.m
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 25/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "MessagesViewController.h"
#import "loadParse.h"
#import "User.h"
#import <Parse/Parse.h>

@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewM;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    _tableViewM.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewM.rowHeight = 75;
    _tableViewM.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0.97 blue:0.84 alpha:0.70]};
    self.title = @"Messages";
    
}

-(void)viewWillAppear:(BOOL)animated{
    [_tableViewM reloadData];
    loadParse *lp = [[loadParse alloc] init];
    User *user1 = [User sharedUser];
    _messages = [lp loadEvents:user1.objectId];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cell];
    PFObject *e = [_messages objectAtIndex:(int)indexPath.row];
    cell = e[@"name"];
    
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
