//
//  DNFeedViewCell.m
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNFeedViewCell.h"

@implementation DNFeedViewCell

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

@end
