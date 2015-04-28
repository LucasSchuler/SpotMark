//
//  Invites.m
//  SpotMark
//
//  Created by Matheus Baptista Bondan on 20/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "Event.h"

@implementation Event

-(id)initWithValues: (NSString *)name : (NSString *)desc : (NSString *)local : (NSString *)datetime : (NSString *)category : (NSString *)admin{
    
    self = [super init];
    if(self){
        if([name isEqualToString:@""]){
           NSException *exception = [NSException exceptionWithName:@"" reason:@"The name can not be empty!" userInfo:nil];
            @throw exception;
        }else if([desc isEqualToString:@""]){
            NSException *exception = [NSException exceptionWithName:@"" reason:@"The description can not be empty!" userInfo:nil];
            @throw exception;
        }if([local isEqualToString:@""]){
            NSException *exception = [NSException exceptionWithName:@"" reason:@"The address can not be empty!" userInfo:nil];
            @throw exception;
        }if([datetime isEqualToString:@""]){
            NSException *exception = [NSException exceptionWithName:@"" reason:@"Select a date for the event!" userInfo:nil];
            @throw exception;
        }
        //if(datetime > )
        
        _name = name;
        _desc = desc;
        _local = local;
        _datetime = datetime;
        _category = category;
        _admin = admin;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_idEvent forKey:@"_idEvent"];
    [encoder encodeObject:_name forKey:@"_name"];
    [encoder encodeObject:_desc forKey:@"_desc"];
    [encoder encodeObject:_local forKey:@"_local"];
    [encoder encodeObject:_datetime forKey:@"_datetime"];
    [encoder encodeObject:_category forKey:@"_category"];
    [encoder encodeObject:_admin forKey:@"_admin"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    _idEvent = [decoder decodeObjectForKey:@"_idEvent"];
    _name = [decoder decodeObjectForKey:@"_name"];
    _desc = [decoder decodeObjectForKey:@"_desc"];
    _local = [decoder decodeObjectForKey:@"_local"];
    _datetime = [decoder decodeObjectForKey:@"_datetime"];
    _category = [decoder decodeObjectForKey:@"_category"];
    _admin = [decoder decodeObjectForKey:@"_admin"];
    return self;
}

//[NSException raise:@"Invalid foo value" format:@"foo of %d is invalid", foo];

@end
