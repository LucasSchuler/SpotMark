//
//  EventTableCell.h
//  SpotMark
//
//  Created by Rafaela dos Santos Bertolini on 30/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;
@property (nonatomic, weak) IBOutlet UIImageView *eventImage;

@end
