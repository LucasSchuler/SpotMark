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
#import "Chat.h"

@interface MessagesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property Chat *chat;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 75;
    _tableView.backgroundColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:0.97 blue:0.84 alpha:0.70]};
    self.title = @"Messages";
    
}

-(void)viewWillAppear:(BOOL)animated{
    //[_tableView reloadData];
    //loadParse *lp = [[loadParse alloc] init];
    //User *user1 = [User sharedUser];
 //   _messages = [lp loadMessages:user1.objectId];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  //  PFObject *e = [_messages objectAtIndex:(int)indexPath.row];
    cell.textLabel.text = @"teste";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
