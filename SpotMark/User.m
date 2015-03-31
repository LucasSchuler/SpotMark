//
//  User.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 27/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "User.h"

@implementation User

+ (id)sharedUser {
    static User *sharedMyUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyUser = [[self alloc] init];
    });
    return sharedMyUser;
}

- (id)init {
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end