//
//  loadParse.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 27/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <Parse/Parse.h>
#import "loadParse.h"

@implementation loadParse

-(NSMutableArray *)loadEvents : (NSString *) idUser{
    NSUInteger limit = 1000;
    NSUInteger skip = 0;
    PFQuery *userQuery = [PFQuery queryWithClassName:@"UserEvent"];
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    
    [userQuery whereKey:@"user" equalTo:idUser];
    [eventQuery whereKey:@"objectId" matchesKey:@"event" inQuery:userQuery];
    [eventQuery orderByDescending:@"createdAt"];

    [eventQuery setLimit: limit];
    [eventQuery setSkip: skip];
    
    NSLog(@"aqui");
    
    NSArray *objects = eventQuery.findObjects;
    return [objects mutableCopy];
}

-(NSMutableArray *) loadPosts : (NSString *) idEvent{
    NSUInteger limit = 1000;
    NSUInteger skip = 0;
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"idEvent" equalTo:idEvent];
    [query setLimit: limit];
    [query setSkip: skip];
    NSArray *objects = query.findObjects;
    return [objects mutableCopy];
}

-(void)sairEvento:(NSString *)user :(NSString *)event{
    PFQuery *query = [PFQuery queryWithClassName:@"UserEvent"];
    [query whereKey:@"user" equalTo:user];
    [query whereKey:@"event" equalTo:event];
    NSArray *objects = query.findObjects;
    PFObject *delete = [objects objectAtIndex:0];
    [delete deleteInBackground];
}

-(void) excluirEvento:(NSString *)event{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"objectId" equalTo:event];
    NSArray *objects = query.findObjects;
    PFObject *delete = [objects objectAtIndex:0];
    [delete deleteInBackground];
}

@end
