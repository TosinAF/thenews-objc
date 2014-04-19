//
//  TNCommentCell.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNCommentCell.h"

__weak TNCommentCell *weakSelf;

@interface TNCommentCell ()

@property (nonatomic) UIColor *themeColor;
@property (nonatomic) UIColor *lightThemeColor;

@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) UITextView *commentView;

@end

@implementation TNCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        weakSelf = self;

        self.commentView = [[UITextView alloc] initWithFrame:CGRectMake(20, 15, 270, 2000)];
        [self.commentView setEditable:NO];
        [self.commentView setScrollEnabled:NO];
        [self.commentView setSelectable:YES];
        [self.commentView setTextColor:[UIColor blackColor]];
        [self.commentView setFont:[UIFont fontWithName:@"Avenir" size:14.0f]];

        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 110, 250, 15)];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setSeparatorInset:UIEdgeInsetsZero];

        [self setFirstTrigger:0.20];

        [self addSubview:self.commentView];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)configureForComment:(DNComment *)comment
{
    self.comment = comment;
    [self setFeedType:TNTypeDesignerNews];

    [self.commentView setText:nil];
    [self.commentView setText:[comment body]];
    [self.commentView setDataDetectorTypes:UIDataDetectorTypeLink];

    /* --- Attributed Detail Text --- */

	NSString *detailString = [NSString stringWithFormat:@"%@ Points by %@", [comment voteCount], [comment author]];
	NSRange authorRange = [detailString rangeOfString:[comment author]];
	NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:12.0f],
		                        NSForegroundColorAttributeName:[UIColor tnGreyColor] };

	NSMutableAttributedString *detailAttr = [[NSMutableAttributedString alloc] initWithString:detailString attributes:textAttr];
	[detailAttr addAttribute:NSForegroundColorAttributeName value:self.lightThemeColor range:authorRange];

	[self.detailLabel setAttributedText:detailAttr];

    [self adjustFrames];
}

- (void)adjustFrames
{
    /* Resize frame For Comment Body */

    CGRect frame = self.commentView.frame;
    frame.size = CGSizeMake(270, [self getCommentViewHeight:[self.comment body]]);
    self.commentView.frame = frame;

    /* Move Author Label Below Comment */

    int commentViewHeight = self.commentView.frame.size.height;

    CGRect detailFrame = self.detailLabel.frame;
    detailFrame.origin.y = 15 + commentViewHeight + 5;

    /* Handle Nested Comments */

    NSNumber *depth = [self.comment depth];
    [self.commentView setTextContainerInset:UIEdgeInsetsMake(0, 15 * [depth intValue] , -5, 0)];
    detailFrame.origin.x = 25 + 15 * [depth intValue];

    self.detailLabel.frame = detailFrame;
}

- (CGFloat)estimateHeightWithComment:(DNComment *)comment
{
    int commentViewHeight = [self getCommentViewHeight:[comment body]];
    int detailLabelHeight = self.detailLabel.frame.size.height;
    return commentViewHeight + detailLabelHeight + 35;
}

- (CGFloat)getCommentViewHeight:(NSString *)comment
{
    CGSize size = [self text:comment sizeWithFont:[UIFont fontWithName:@"Avenir" size:15.0f] constrainedToSize:CGSizeMake(270, 5000)];
    return floorf(size.height);
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

- (void)addSwipeGesturesToCell
{
    UIView *upvoteView = [self viewWithImageName:@"Upvote"];
    UIView *commentView = [self viewWithImageName:@"Comment"];
    UIColor *lightGreen = [UIColor colorWithRed:0.631 green:0.890 blue:0.812 alpha:1];

    [self setDefaultColor:[UIColor tnLightGreyColor]];
    [self setFirstTrigger:0.15];

    [self setSwipeGestureWithView:upvoteView color:lightGreen mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        weakSelf.upvoteBlock((TNCommentCell *)cell);
        
    }];

    [self setSwipeGestureWithView:commentView color:[UIColor dnColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        weakSelf.commentBlock((TNCommentCell *)cell);

    }];
}

#pragma mark - Private Methods

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGRect frame = [text boundingRectWithSize:size
                                      options:(NSStringDrawingUsesLineFragmentOrigin )
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    return frame.size;
}

@end
