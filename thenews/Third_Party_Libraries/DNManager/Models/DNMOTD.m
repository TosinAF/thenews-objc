//
//  DNMOTD.m
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 25/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNMOTD.h"

@implementation DNMOTD

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    if (self) {
        [self setUserID:dict[@"user_id"]];
        [self setMessage:dict[@"message"]];
        [self setUpvoteCount:dict[@"upvote_count"]];
        [self setDownvoteCount:dict[@"downvote_count"]];
        [self setDisplayName:dict[@"user_display_name"]];
    }

    return self;
}


@end
