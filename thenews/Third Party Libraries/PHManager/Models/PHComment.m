//
//  PHComment.m
//  The News
//
//  Created by Tosin Afolabi on 14/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHComment.h"

@implementation PHComment

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    if (self) {
        [self setComment:dict[@"comment"]];
        [self setCommentHTML:dict[@"comment_html"]];
        [self setTimestamp:dict[@"timestamp"]];
        [self setIndex:dict[@"index"]];
        [self setHunter:[[PHUser alloc] initWithDictionary:dict[@"user"]]];
    }

    return self;
}


@end
