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
#import "AppDelegate.h"


@interface EventsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property Event *evt;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
   
    self.title = @"Events";
  
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   // _tableView.rowHeight = 110;
    _tableView.backgroundColor = [UIColor clearColor];
    
    
    
    self.navigationController.tabBarItem.selectedImage = [[UIImage imageNamed: @"Branco.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationController.tabBarItem.image = [[UIImage imageNamed:@"Verde.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    if(app.eventCreated != nil)
    {
        _evt = app.eventCreated;
        [self performSegueWithIdentifier:@"gotoEventDetail" sender: nil];
    }
    else
    {
        [_tableView reloadData];
        loadParse *lp = [[loadParse alloc] init];
        User *user1 = [User sharedUser];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *a = [lp loadEvents:user1.objectId];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                _events = a;
                [_tableView reloadData];
            });
        });
    }
    

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    EventTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    PFObject *e = [_events objectAtIndex:(int)indexPath.row];
    cell.nameLabel.text = e[@"name"];
    cell.dateLabel.text = e[@"datetime"];
    cell.localLabel.text = e[@"local"];
    if([e[@"category"] isEqualToString:@"Reunião"])
        cell.eventImage.image = [UIImage imageNamed:@"Reuniao"];
    else
        cell.eventImage.image = [UIImage imageNamed:e[@"category"]];
    cell.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedRowHeight = 90.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _evt = [[Event alloc] init];
    PFObject *e = [_events objectAtIndex:(int) indexPath.row];
    _evt.name = e[@"name"];
    _evt.desc = e[@"description"];
    _evt.local = e[@"local"];
    _evt.datetime = e[@"datetime"];
    _evt.admin = e[@"admin"];
    if([e[@"category"] isEqualToString:@"Reunião"])
        _evt.category = @"Reuniao";
     else
         _evt.category = e[@"category"];
    _evt.idEvent = e.objectId;
    [self performSegueWithIdentifier:@"gotoEventDetail" sender: indexPath];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotoEventDetail"]){
        OneEventViewController *oevt = (OneEventViewController *) segue.destinationViewController;
        oevt.evt = _evt;
        AppDelegate *app = [[UIApplication sharedApplication] delegate];

        if(app.eventCreated != nil)
        {
            oevt.newEvent = YES;
            app.eventCreated = nil;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
