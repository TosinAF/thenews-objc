//
//  TNFeedViewCell.m
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNFeedViewCell.h"

MCSwipeCompletionBlock upvoteBlock;
MCSwipeCompletionBlock commentBlock;

@interface TNFeedViewCell ()

@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UIColor *lightThemeColor;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *commentCountLabel;

@property (strong, nonatomic) UIView *viewContainer;

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
	}
}

- (void)setUpvoteBlock:(MCSwipeCompletionBlock)block
{
    upvoteBlock = block;
}

- (void)setCommentBlock:(MCSwipeCompletionBlock)block
{
    commentBlock = block;
}

- (void)layoutSubviews {
	CGSize contentViewSize = self.frame.size;

	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, contentViewSize.width - 50, 40)];
	self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, 145, 20)];
	self.commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 55, 100, 20)];

	[self.contentView addSubview:self.titleLabel];
	[self.contentView addSubview:self.detailLabel];
	[self.contentView addSubview:self.commentCountLabel];

    [self addSwipeGesturesToCell];

}

- (void)removeSubviews {
	UIView *subview;
	while ((subview = [[[self contentView] subviews] lastObject]) != nil)
		[subview removeFromSuperview];
}

- (void)setForReuse {
	[self removeSubviews];
	[self layoutSubviews];
}

// Could Refactor these two methods intp subclass hnfeedviewcell & dnfeedviewcell

- (void)configureForPost:(HNPost *)post
{
    NSDictionary *cellContent = @{@"title":[post Title],
                                  @"author":[post Username],
                                  @"points":@([post Points]),
                                  @"count":@([post CommentCount])};

    [self updateLabels:cellContent];
}

- (void)configureForStory:(DNStory *)story
{
    self.story = story;

    NSDictionary *cellContent = @{@"title":[story title],
                                  @"author":[story displayName],
                                  @"points":[story voteCount],
                                  @"count":[story commentCount]};

    [self updateLabels:cellContent];
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

	/* --- Comment Label --- */
	NSString *commentCountString = [NSString stringWithFormat:@"%@ Comments \u2192", content[@"count"]];
	NSRange arrowRange = [commentCountString rangeOfString:@"\u2192"];
	NSDictionary *commentAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:10.0f],
		                           NSForegroundColorAttributeName:self.lightThemeColor };

	NSMutableAttributedString *commentCountAttr = [[NSMutableAttributedString alloc] initWithString:commentCountString attributes:commentAttr];
	[commentCountAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Entypo" size:15.0f] range:arrowRange];
	[self.commentCountLabel setAttributedText:commentCountAttr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	//[super setSelected:selected animated:animated];
}

- (void)addSwipeGesturesToCell
{
    UIView *upvoteView = [self viewWithImageName:@"Upvote"];
    UIView *commentView = [self viewWithImageName:@"Comment"];
    UIColor *lightGreen = [UIColor colorWithRed:0.631 green:0.890 blue:0.812 alpha:1];

    [self setDefaultColor:[UIColor tnLightGreyColor]];

    [self setSwipeGestureWithView:upvoteView color:lightGreen mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

            upvoteBlock(cell, state, mode);
    }];

    [self setSwipeGestureWithView:commentView color:[UIColor dnColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        commentBlock(cell, state, mode);
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