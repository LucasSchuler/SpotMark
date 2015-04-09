//
//  Invites.m
//  SpotMark
//
//  Created by Matheus Baptista Bondan on 20/03/15.
//  Copyright (c) 2015 Lucas Fraga Schuler. All rights reserved.
//

#import "Event.h"

@implementation Event


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

@end
