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
        [self setId:dict[@"id"]];
        [self setPostID:dict[@"post_id"]];
        [self setParentCommentID:dict[@"parent_comment_id"]];
        [self setChildCommentsCount:dict[@"child_comments_count"]];
        [self setBody:dict[@"body"]];
        [self setHunter:[[PHUser alloc] initWithDictionary:dict[@"user"]]];

        NSMutableArray *childComments = [NSMutableArray new];

        for (NSDictionary* commentDict in dict[@"child_comments"] ) {
            PHComment *comment = [[PHComment alloc] initWithDictionary:commentDict];
            [childComments addObject:comment];
        }

        [self setChildComments:[NSArray arrayWithArray:childComments]];
    }

    return self;
}


@end
