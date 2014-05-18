//
//  TNHeaderView.m
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNHeaderView.h"

ButtonActionBlock buttonAction;

@interface TNHeaderView ()

@property (strong, nonatomic) UIColor *themeColor;

@property (strong, nonatomic) UIButton *button;

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
    [self layoutSubviews];

    NSDictionary *cellContent = @{@"title":[story title],
                                  @"author":[story displayName],
                                  @"points":[story voteCount],
                                  @"count":[story commentCount]};

    [self updateLabels:cellContent];
}

- (void)configureForPost:(HNPost *)post
{
    [self layoutSubviews];

    NSDictionary *cellContent = @{@"title":[post Title],
                                  @"author":[post Username],
                                  @"points":@([post Points]),
                                  @"count":@([post CommentCount])};

    [self updateLabels:cellContent];
}

- (void)showButton
{
    [self addSubview:self.button];
}

- (void)setButtonTitle:(NSString *)title
{
    [self.button setTitle:title forState:UIControlStateNormal];
    [self.button setTitle:title forState:UIControlStateSelected];
}

- (void)setButtonAction:(ButtonActionBlock)block
{
    buttonAction = block;
}

- (void)performButtonAction
{
    buttonAction();
}

- (void)layoutSubviews
{
    CGSize contentViewSize = self.frame.size;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, contentViewSize.width - 50, 40)];

    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 145, 20)];

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setFrame:CGRectMake(200, 55, 100, 20)];
    [self.button setTitle:@"Comment" forState:UIControlStateNormal];
    [self.button setTitleColor:self.lightThemeColor forState:UIControlStateNormal];
    [self.button setTitleColor:self.lightThemeColor forState:UIControlStateSelected];
    [[self.button titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Bold" size:10.0f]];

    [self.button addTarget:self action:@selector(performButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
    
	NSString *detailString = [NSString stringWithFormat:@"%@ Points by %@", content[@"points"], content[@"author"]];
	NSRange authorRange = [detailString rangeOfString:content[@"author"]];
	NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:11.0f],
		                        NSForegroundColorAttributeName:[UIColor tnGreyColor] };

	NSMutableAttributedString *detailAttr = [[NSMutableAttributedString alloc] initWithString:detailString attributes:textAttr];
	[detailAttr addAttribute:NSForegroundColorAttributeName value:self.lightThemeColor range:authorRange];
	[self.detailLabel setAttributedText:detailAttr];

    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
}

- (void)adjustViewsRelativeToTitleLabel
{
    // Feels hacky but honestly niggas are tired
    CGFloat yOrigin = self.titleLabel.frame.size.height + 15;

    CGRect frame = self.detailLabel.frame;
    frame.origin.y = yOrigin;
    [self.detailLabel setFrame:frame];

    frame = self.button.frame;
    frame.origin.y = yOrigin;
    [self.button setFrame:frame];

    CGFloat entireViewHeight = yOrigin + self.detailLabel.frame.size.height + 10;
    frame = self.frame;
    frame.size.height = entireViewHeight;
    [self setFrame:frame];
}

@end
