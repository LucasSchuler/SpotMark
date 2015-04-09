//
//  Participant.h
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 08/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Participant : NSObject
@property NSString *name;
@property NSData *dataImage;

-(void)loadImage : (NSString *) url;
@end
