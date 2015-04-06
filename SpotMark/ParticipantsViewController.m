//
//  ParticipantsViewController.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 01/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "ParticipantsViewController.h"
#import "CustonCellInvite.h"
#import "loadParse.h"
#import "User.h"
#import <Parse/Parse.h>

@interface ParticipantsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property User *user1;

@end

@implementation ParticipantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    loadParse *lp = [[loadParse alloc] init];
    User *user1 = [User sharedUser];
    _participants = [lp loadParticipants:_idEvent];
    _tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _participants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CustomCellInvite *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    PFObject *e = [_participants objectAtIndex:(int)indexPath.row];
    cell.name.text = e[@"userName"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200", e[@"user"]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [cell.image setImage:[UIImage imageWithData:data]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
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
