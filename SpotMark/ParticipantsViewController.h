//
//  ParticipantsViewController.h
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 01/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticipantsViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>
@property NSMutableArray *participants;
@property NSString *idEvent;
@end
