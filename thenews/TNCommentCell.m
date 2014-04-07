//
//  TNCommentCell.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNCommentCell.h"

@interface TNCommentCell ()

@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UIColor *lightThemeColor;

@property (nonatomic, strong) DNComment *comment;

@end

@implementation TNCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.commentView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, 250, 50)];
        [self.commentView setEditable:NO];
        [self.commentView setScrollEnabled:NO];
        [self.commentView setTextColor:[UIColor blackColor]];
        [self.commentView setFont:[UIFont fontWithName:@"Montserrat" size:12.0f]];

        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 110, 250, 15)];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setSeparatorInset:UIEdgeInsetsZero];

        [self addSubview:self.commentView];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)configureForComment:(DNComment *)comment
{
    self.comment = comment;
    [self setFeedType:TNTypeDesignerNews];

    [self.commentView setText:[comment body]];

    /* --- Attributed Detail Text --- */

	NSString *detailString = [NSString stringWithFormat:@"%@ Points by %@", [comment voteCount], [comment author]];
	NSRange authorRange = [detailString rangeOfString:[comment author]];
	NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Bold" size:10.0f],
		                        NSForegroundColorAttributeName:[UIColor tnGreyColor] };

	NSMutableAttributedString *detailAttr = [[NSMutableAttributedString alloc] initWithString:detailString attributes:textAttr];
	[detailAttr addAttribute:NSForegroundColorAttributeName value:self.lightThemeColor range:authorRange];

	[self.detailLabel setAttributedText:detailAttr];

    [self adjustFrames];
}

- (void)adjustFrames
{
    [self.commentView sizeToFit];

    /* Move Author Label Below Comment */

    CGRect commentViewFrame = self.commentView.frame;
    int commentViewHeight = commentViewFrame.size.height;

    CGRect detailFrame = self.detailLabel.frame;
    detailFrame.origin.y = 10 + commentViewHeight + 5;
    self.detailLabel.frame = detailFrame;
}

- (CGFloat)estimateHeightWithComment:(DNComment *)comment
{
    // First lets get the main text view height

    [self.commentView setText:[comment body]];
    [self.commentView  sizeToFit];

    int commentViewHeight = self.commentView.frame.size.height;
    int detailLabelHeight = self.detailLabel.frame.size.height;

    // Now let's return all of them added up :)
    return commentViewHeight + detailLabelHeight + 25;
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

@end
