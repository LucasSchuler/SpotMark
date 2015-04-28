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
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery whereKey:@"members" equalTo:idUser];
    [eventQuery orderByDescending:@"createdAt"];
    [eventQuery setLimit: limit];
    [eventQuery setSkip: skip];
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

-(NSMutableArray *) loadMessages : (NSString *) idEvent{
    NSUInteger limit = 1000;
    NSUInteger skip = 0;
    PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"Event" equalTo:idEvent];
    [query setLimit: limit];
    [query setSkip: skip];
    NSArray *objects = query.findObjects;
    return [objects mutableCopy];
}

-(void)sairEvento:(NSString *)user :(NSString *)event{
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Event" objectId: event];
    [object removeObject:user forKey:@"members"];
    [object saveInBackground];
}

-(void) excluirEvento:(NSString *)event{
    //DELETA O EVENTO
    PFObject *query2 = [PFObject objectWithoutDataWithClassName:@"Event" objectId:event];
    query2.deleteInBackground;

    //DELETA OS POSTS
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"idEvent" equalTo:event];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error){
            for (PFObject *post in array){
                post.deleteInBackground;
            }
        }else{
            NSLog(@"%@",error);
        }
        
    }];

    //DELETA AS MENSAGENS DO CHAT
    query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"eventId" equalTo:event];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error){
            for (PFObject *message in array){
                message.deleteInBackground;
            }
        }else{
            NSLog(@"%@",error);
        }
    }];
        
}

@end
