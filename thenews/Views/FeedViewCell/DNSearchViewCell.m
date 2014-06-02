//
//  DNSearchViewCell.m
//  The News
//
//  Created by Tosin Afolabi on 18/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNStory.h"
#import "DNSearchViewCell.h"

@implementation DNSearchViewCell

- (void)configureForStory:(DNStory *)story
{
    self.story = story;
    [self setFeedType:TNTypeDesignerNews];

    NSDictionary *cellContent = @{@"title":[story title],
                                  @"author":[story displayName]};

    [self updateLabels:cellContent];
}

- (void)updateLabels:(NSDictionary *)content
{
	[self.titleLabel setText:content[@"title"]];
	[self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setNumberOfLines:2];
    [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
	[self.titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:15.0f]];

	[self.detailLabel setText:content[@"author"]];
    [self.detailLabel setTextColor:self.lightThemeColor];
    [self.detailLabel setFont:[UIFont fontWithName:@"Montserrat" size:10.0f]];
}

@end
