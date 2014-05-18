//
//  HNFeedViewCell.m
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "HNFeedViewCell.h"

@implementation HNFeedViewCell

- (void)configureForPost:(HNPost *)post
{
    self.post = post;
    [self setFeedType:TNTypeHackerNews];

    NSDictionary *cellContent = @{@"title":[post Title],
                                  @"author":[post Username],
                                  @"points":@([post Points]),
                                  @"count":@([post CommentCount])};

    [self updateLabels:cellContent];
}

- (void)incrementVoteCount
{
    int voteCount = [self.post Points] + 1;

    NSDictionary *cellContent = @{@"title":[self.post Title],
                                  @"author":[self.post Username],
                                  @"points":@(voteCount),
                                  @"count":@([self.post CommentCount])};

    [self setForReuse];
    [self updateLabels:cellContent];
}

@end
