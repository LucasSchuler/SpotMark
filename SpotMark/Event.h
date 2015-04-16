//
//  Event.h
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 19/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface Event : NSObject

-(id)initWithValues: (NSString *)name : (NSString *)desc : (NSString *)local : (NSString *)datetime : (NSString *)category : (NSString *)admin;

@property NSString *idEvent;
@property NSString *name;
@property NSString *desc;
@property NSString *local;
@property NSString *datetime;
@property NSMutableArray *participants;
//@property NSMutableArray *feed;
@property NSString *admin;
@property NSString *category;

@end


