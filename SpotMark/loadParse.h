//
//  loadParse.h
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 27/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loadParse : NSObject

-(NSMutableArray *) loadEvents : (NSString *) email;
-(NSMutableArray *) loadPosts : (NSString *) idEvent;
-(void) sairEvento : (NSString *) user : (NSString *) event;
-(void) excluirEvento : (NSString *) event;

@end
