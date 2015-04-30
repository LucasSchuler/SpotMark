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
#import "Participant.h"

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
    Participant *p = [_participants objectAtIndex:(int)indexPath.row];
    cell.name.text = p.name;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cell.actIndicator startAnimating];
       NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200", p.userid]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
