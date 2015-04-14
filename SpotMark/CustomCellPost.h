//
//  CustomCellPost.h
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 14/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellPost : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UITextView *post;


@end
