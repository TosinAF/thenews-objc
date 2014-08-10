//
//  PHUser.m
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHUser.h"

@implementation PHUser

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    if (self) {
        [self setId:dict[@"id"]];
        [self setName:dict[@"name"]];
        [self setHeadline:dict[@"headline"]];
        [self setUsername:dict[@"username"]];
    }

    return self;
}


@end
