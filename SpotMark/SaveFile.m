//
//  SaveFile.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 07/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "SaveFile.h"

@implementation SaveFile

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsPath = [_paths objectAtIndex:0];
        self.path= [_documentsPath stringByAppendingPathComponent:@"events"];
    }
    return self;
}


-(BOOL)save:(NSArray *)array{
    if(array != nil){
        NSMutableArray *objects = [self selectEventsToFile:array];
        [NSKeyedArchiver archiveRootObject:objects toFile:_path];
        return YES;
    }
    return NO;
}

-(NSMutableArray *) load{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
}

-(NSMutableArray *) selectEventsToFile : (NSArray *) array{
    NSMutableArray *eventsSaved = [self load];
    return nil;
}

@end
