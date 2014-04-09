//
//  TNHeaderView.m
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNHeaderView.h"

@interface TNHeaderView ()

@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UIColor *lightThemeColor;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *upvoteButton;

@end

@implementation TNHeaderView

- (id)initWithFrame:(CGRect)frame type:(TNType)type
{
    self = [super initWithFrame:frame];

    if (self) {
        switch (type) {
            case TNTypeDesignerNews:
                self.themeColor = [UIColor dnColor];
                self.lightThemeColor = [UIColor dnLightColor];
                break;

            case TNTypeHackerNews:
                self.themeColor = [UIColor hnColor];
                self.lightThemeColor = [UIColor hnLightColor];
                break;
        }
    }

    return self;
}

- (void)configureForStory:(DNStory *)story
{
    self.story = story;
    [self layoutSubviews];

    NSDictionary *cellContent = @{@"title":[story title],
                                  @"author":[story displayName],
                                  @"points":[story voteCount],
                                  @"count":[story commentCount]};

    [self updateLabels:cellContent];
}

- (void)layoutSubviews
{
    CGSize contentViewSize = self.frame.size;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, contentViewSize.width - 50, 40)];

    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 145, 20)];

    self.upvoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.upvoteButton setFrame:CGRectMake(200, 55, 100, 20)];
    [self.upvoteButton setTitle:@"Comment" forState:UIControlStateNormal];
    [[self.upvoteButton titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Bold" size:10.0f]];
    [[self.upvoteButton titleLabel] setTextColor:self.lightThemeColor];

    [self addSubview:self.upvoteButton];
}

- (void)updateLabels:(NSDictionary *)content
{
	/* --- Title Label --- */

	[self.titleLabel setText:content[@"title"]];
	[self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setNumberOfLines:2];
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
	[self.titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:15.0f]];

	/* --- Detail Label --- */
    
	NSString *detailString = [NSString stringWithFormat:@"%@ Points by %@", content[@"points"], content[@"author"]];
	NSRange authorRange = [detailString rangeOfString:content[@"author"]];
	NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:10.0f],
		                        NSForegroundColorAttributeName:[UIColor tnGreyColor] };

	NSMutableAttributedString *detailAttr = [[NSMutableAttributedString alloc] initWithString:detailString attributes:textAttr];
	[detailAttr addAttribute:NSForegroundColorAttributeName value:self.lightThemeColor range:authorRange];
	[self.detailLabel setAttributedText:detailAttr];

    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];

}

@end
