//
//  Event.h
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 19/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface Event : NSObject

@property NSString *idEvent;
@property NSString *name;
@property NSString *desc;
@property NSString *local;
@property NSString *datetime;
@property NSMutableArray *participants;
@property NSMutableArray *feed;
@property NSString *eventId;
@property NSString *admin;
@property NSString *category;

+(Event *)eventCreator;
-(void)postCreator : (NSString *)title : (NSString *)post;
-(void)openChat;
-(void)change;

@end


