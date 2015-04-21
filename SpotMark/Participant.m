//
//  Participant.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 08/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "Participant.h"

@implementation Participant

-(void)loadImage:(NSString *)user{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=200&height=200", user]];
    NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@", user]];
    _dataImage = [NSData dataWithContentsOfURL:url];
}

@end
