//
//  User.h
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 27/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface User : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSMutableArray *friends_list;
@property (nonatomic, retain) NSString *objectId;

+ (id)sharedUser;

@end