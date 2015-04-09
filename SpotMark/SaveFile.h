//
//  SaveFile.h
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 07/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveFile : NSObject
@property NSArray *paths;
@property NSString *documentsPath;
@property NSString *path;

-(BOOL)save : (NSArray *) array;
-(NSMutableArray *)load;
-(NSMutableArray *) selectEventsToFile : (NSArray *) array;
@end
