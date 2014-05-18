//
//  TNSearchHeaderView.m
//  The News
//
//  Created by Tosin Afolabi on 18/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNSearchHeaderView.h"

@implementation TNSearchHeaderView

- (void)configureForStory:(DNStory *)story
{
    [self layoutSubviews];

    NSDictionary *cellContent = @{@"title":[story title],
                                  @"author":[story displayName]};

    [self updateLabels:cellContent];
}

- (void)updateLabels:(NSDictionary *)content
{
	/* --- Title Label --- */

	[self.titleLabel setText:content[@"title"]];
	[self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
	[self.titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:15.0f]];

    [self.titleLabel sizeToFit];
    [self adjustViewsRelativeToTitleLabel];

	/* --- Detail Label --- */

    [self.detailLabel setText:content[@"author"]];
    [self.detailLabel setTextColor:self.lightThemeColor];
    [self.detailLabel setFont:[UIFont fontWithName:@"Montserrat" size:10.0f]];

    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
}

@end
