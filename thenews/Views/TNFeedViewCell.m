//
//  TNFeedViewCell.m
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTypeEnum.h"
#import "TNFeedViewCell.h"
#import "UIColor+TNColors.h"
#import "TNFeedViewController.h"

@interface TNFeedViewCell ()

@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UIColor *lightThemeColor;

@property (strong, nonatomic) UILabel *index;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *detail;
@property (strong, nonatomic) UILabel *commentCount;

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

- (void)layoutSubviews {
	CGSize contentViewSize = self.frame.size;

	self.index = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 25, 20)];
	self.title = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, contentViewSize.width - 50, 20)];
	self.detail = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 145, 20)];
	self.commentCount = [[UILabel alloc] initWithFrame:CGRectMake(190, 40, 100, 20)];

	[self.contentView addSubview:self.index];
	[self.contentView addSubview:self.title];
	[self.contentView addSubview:self.detail];
	[self.contentView addSubview:self.commentCount];

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

- (void)configureForPost:(Post *)post
{

    NSString *title = [post title];
	NSString *author = [post author];
    NSNumber *points = [post points];
    NSNumber *index = [post position];
    NSNumber *count = [post comments];

	/* --- Index Label --- */
	[self.index setText:[NSString stringWithFormat:@"%@.", index]];
	[self.index setTextColor:self.themeColor];
	[self.index setFont:[UIFont fontWithName:@"Montserrat" size:15.0f]];

	/* --- Title Label --- */
	[self.title setText:title];
	[self.title setTextColor:[UIColor blackColor]];
	[self.title setFont:[UIFont fontWithName:@"Montserrat" size:15.0f]];

	/* --- Detail Label --- */
	NSString *detailString = [NSString stringWithFormat:@"%@ Points by %@", points, author];
	NSRange authorRange = [detailString rangeOfString:author];
	NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:10.0f],
		                        NSForegroundColorAttributeName:[UIColor tnGreyColor] };

	NSMutableAttributedString *detailAttr = [[NSMutableAttributedString alloc] initWithString:detailString attributes:textAttr];
	[detailAttr addAttribute:NSForegroundColorAttributeName value:self.lightThemeColor range:authorRange];
	[self.detail setAttributedText:detailAttr];

	/* --- Comment Label --- */
	NSString *commentCountString = [NSString stringWithFormat:@"%@ Comments \u2192", count];
	NSRange arrowRange = [commentCountString rangeOfString:@"\u2192"];
	NSDictionary *commentAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:10.0f],
		                           NSForegroundColorAttributeName:self.lightThemeColor };

	NSMutableAttributedString *commentCountAttr = [[NSMutableAttributedString alloc] initWithString:commentCountString attributes:commentAttr];
	[commentCountAttr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Entypo" size:15.0f] range:arrowRange];
	[self.commentCount setAttributedText:commentCountAttr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	//[super setSelected:selected animated:animated];
}

@end
