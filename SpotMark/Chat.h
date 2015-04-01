//
//  NSObject+Chat.h
//  SpotMark
//
//  Created by Matheus Baptista Bondan on 20/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chat: NSObject

@property NSMutableArray *guestsList;
@property NSMutableArray *messagesList;
@property NSString *name;

@end
