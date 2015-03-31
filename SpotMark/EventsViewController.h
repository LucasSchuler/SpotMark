//
//  EventsViewController.h
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 19/02/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property NSMutableArray *events;

@end
