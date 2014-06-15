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

        [self setTitle:dict[@"title"]];
        [self setTagline:dict[@"tagline"]];
        [self setRank:dict[@"rank"]];
        [self setURL:dict[@"url"]];
        [self setPermalink:dict[@"permalink"]];
        [self setVoteCount:dict[@"votes"]];
        [self setCommentCount:dict[@"comment_count"]];
        [self setHunter:[[PHUser alloc] initWithDictionary:dict[@"user"]]];

        NSString *titleWithTagline = [NSString stringWithFormat:@"%@: %@", self.title, self.tagline];
        [self setTitleWithTagline:titleWithTagline];
    }

    return self;
}


@end
