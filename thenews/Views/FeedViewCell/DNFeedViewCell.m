//
//  DNFeedViewCell.m
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNFeedViewCell.h"

@implementation DNFeedViewCell

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)configureForStory:(DNStory *)story
{
    self.story = story;
    [self setFeedType:TNTypeDesignerNews];

    NSDictionary *cellContent = @{@"title":[story title],
                                  @"author":[story displayName],
                                  @"points":[story voteCount],
                                  @"count":[story commentCount]};

    [self updateLabels:cellContent];
}

- (void)incrementVoteCount
{
    int voteCount = [[self.story voteCount] intValue] + 1;

    NSDictionary *cellContent = @{@"title":[self.story title],
                                  @"author":[self.story displayName],
                                  @"points":@(voteCount),
                                  @"count":[self.story commentCount]};

    [self setForReuse];
    [self updateLabels:cellContent];
}

@end
