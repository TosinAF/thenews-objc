//
//  PHProduct.m
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHProduct.h"

@implementation PHProduct

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    if (self) {
        [self setId:dict[@"id"]];
        [self setName:dict[@"name"]];
        [self setTagline:dict[@"tagline"]];
        [self setDiscussionURL:dict[@"discussion_url"]];
        [self setRedirectURL:dict[@"redirect_url"]];
        [self setUpvotes:dict[@"votes_count"]];
        [self setCommentsCount:dict[@"comments_count"]];
        [self setHunter:[[PHUser alloc] initWithDictionary:dict[@"user"]]];

        NSString *nameWithTagline = [NSString stringWithFormat:@"%@: %@", self.name, self.tagline];
        [self setNameWithTagline:nameWithTagline];
    }

    return self;
}


@end
