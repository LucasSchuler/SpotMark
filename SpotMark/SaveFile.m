//
//  SaveFile.m
//  SpotMark
//
//  Created by Lucas Fraga Schuler on 07/04/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "SaveFile.h"
#import "Event.h"
#import <Parse/Parse.h>

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
        [NSKeyedArchiver archiveRootObject:array toFile:_path];
        return YES;
    }
    return NO;
}

-(NSMutableArray *) load{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
}

-(NSMutableArray *) selectEventsToFile : (NSArray *) array{
    NSMutableArray *eventsSaved = [self load];
    NSMutableArray *save = [[NSMutableArray alloc]init];
    for(int i=0; i<array.count; i++){
        PFObject *e = [array objectAtIndex:i];
        for(int j=0; j<eventsSaved.count; j++){
            
        }
    }
    return save;
}

@end
