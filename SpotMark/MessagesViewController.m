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
#import "ChatView.h"
#import "AppDelegate.h"

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
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.title = @"Messages";
    
    self.navigationController.tabBarItem.selectedImage = [[UIImage imageNamed: @"MessagesBranco.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationController.tabBarItem.image = [[UIImage imageNamed:@"MessagesVerde.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if(app.eventCreated != nil)
    {
        [self.tabBarController setSelectedIndex:1];
    }
    
    [_tableViewM reloadData];
    loadParse *lp = [[loadParse alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *a = [lp loadEvents:_user1.objectId];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            _events = a;
            [_tableViewM reloadData];
        });
    });
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
    cell.backgroundColor = [UIColor colorWithRed:0.06 green:0.48 blue:0.40 alpha:0.7];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _evt = [[Event alloc] init];
    PFObject *e = [_events objectAtIndex:(int)indexPath.row];
    _evt.idEvent = e.objectId;
    _evt.name = e[@"name"];
    ChatView *chatView = [[ChatView alloc] initWith:e.objectId];
    chatView.hidesBottomBarWhenPushed = YES;
    chatView.name = _evt.name;
    [self.navigationController pushViewController:chatView animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
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
