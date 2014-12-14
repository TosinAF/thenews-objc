//
//  TNFeedViewCell.m
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNFeedViewCell.h"

@interface TNFeedViewCell ()

@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UILabel *commentCountLabel;

@end

@implementation TNFeedViewCell

- (void)setFrameHeight:(CGFloat)height {
	CGRect contentViewFrame = self.frame;
	contentViewFrame.size.height = height;
	self.frame = contentViewFrame;
}

- (void)setFeedType:(TNType)feedType {

	switch (feedType) {
		case TNTypeDesignerNews:
			self.themeColor = [UIColor dnColor];
			self.lightThemeColor = [UIColor dnLightColor];
			break;

		case TNTypeHackerNews:
			self.themeColor = [UIColor hnColor];
			self.lightThemeColor = [UIColor hnLightColor];
			break;

        case TNTypeProductHunt:
			self.themeColor = [UIColor phColor];
			self.lightThemeColor = [UIColor phLightColor];
			break;
	}

    // Other Defaults
    [self setFirstTrigger:0.20];
}

- (void)layoutSubviews {

    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    self.detailLabel = [UILabel new];
    [self.detailLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    self.commentCountLabel = [UILabel new];
    [self.commentCountLabel setTranslatesAutoresizingMaskIntoConstraints:false];

	[self.contentView addSubview:self.titleLabel];
	[self.contentView addSubview:self.detailLabel];
	[self.contentView addSubview:self.commentCountLabel];

    [self setDefaultColor:[UIColor tnLightGreyColor]];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setNeedsUpdateConstraints {
    [super setNeedsUpdateConstraints];

    NSDictionary *views = @{ @"title": self.titleLabel,
                             @"detail": self.detailLabel,
                             @"count": self.commentCountLabel
                             };

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[title]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[title]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[title]" options:0 metrics:nil views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[detail]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[count]-60-|" options:0 metrics:nil views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[detail]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[count]-10-|" options:0 metrics:nil views:views]];

}

- (void)removeSubviews {
	UIView *subview;
	while ((subview = [[[self contentView] subviews] lastObject]) != nil)
		[subview removeFromSuperview];
    [self.contentView setAlpha:1.0];
}

- (void)setForReuse {
	[self removeSubviews];
	[self layoutSubviews];
}

- (void)updateLabels:(NSDictionary *)content
{
	/* --- Title Label --- */
	[self.titleLabel setText:content[@"title"]];
	[self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setNumberOfLines:2];
    [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
	[self.titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:15.0f]];

	/* --- Detail Label --- */
	NSString *detailString = [NSString stringWithFormat:@"%@ Points by %@", content[@"points"], content[@"author"]];
	NSRange authorRange = [detailString rangeOfString:content[@"author"]];
	NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:10.0f],
		                        NSForegroundColorAttributeName:[UIColor tnGreyColor] };

	NSMutableAttributedString *detailAttr = [[NSMutableAttributedString alloc] initWithString:detailString attributes:textAttr];
	[detailAttr addAttribute:NSForegroundColorAttributeName value:self.lightThemeColor range:authorRange];
	[self.detailLabel setAttributedText:detailAttr];

	/* --- Comment Label --- */

    NSNumber *commentCount = content[@"count"];
    NSString *commentCountString;

    if ([commentCount intValue] == 1) {
        commentCountString = [NSString stringWithFormat:@"%@ Comment", commentCount];
    } else {
        commentCountString = [NSString stringWithFormat:@"%@ Comments", commentCount];
    }

	[self.commentCountLabel setText:commentCountString];
    [self.commentCountLabel setTextColor:self.lightThemeColor];
    [self.commentCountLabel setFont:[UIFont fontWithName:@"Montserrat" size:10.0f]];

    [self setNeedsUpdateConstraints];
}

- (void)addUpvoteGesture
{

    UIView *upvoteView = [self viewWithImageName:@"Upvote"];
    UIColor *lightGreen = [UIColor colorWithRed:0.631 green:0.890 blue:0.812 alpha:1];

    __block TNFeedViewCell *blockSelf = self;

    [self setSwipeGestureWithView:upvoteView color:lightGreen mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        TNFeedViewCell *tnCell = (TNFeedViewCell*)cell;
        [blockSelf.gestureDelegate upvoteActionForCell:tnCell];

    }];
}

- (void)addViewCommentsGesture
{
    __block TNFeedViewCell *blockSelf = self;

    UIView *commentView = [self viewWithImageName:@"Comment"];

    [self setSwipeGestureWithView:commentView color:self.lightThemeColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        TNFeedViewCell *tnCell = (TNFeedViewCell*)cell;
        [blockSelf.gestureDelegate viewCommentsActionForCell:tnCell];

    }];
}

#pragma mark - Private Methods

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

@end