//
//  TNCommentCell.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNCommentCell.h"

__weak TNCommentCell *weakSelf;
TNType type;

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
        [self.commentView setFont:[UIFont fontWithName:@"Avenir-Book" size:14.0f]];

        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 110, 250, 15)];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setSeparatorInset:UIEdgeInsetsZero];

        [self setFirstTrigger:0.20];

        [self addSubview:self.commentView];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)updateLabels
{
    //[self.commentView setText:nil];
    //[self.commentView setText:];
    [self.commentView setDataDetectorTypes:UIDataDetectorTypeLink];

    /* --- Attributed Detail Text --- */

    if (type == TNTypeHackerNews) {

        NSString *detailString = [NSString stringWithFormat:@"%@", self.cellContent[@"author"]];
        [self.detailLabel setText:nil];
        [self.detailLabel setText:detailString];
        [self.detailLabel setFont:[UIFont fontWithName:@"Avenir" size:14.0f]];
        [self.detailLabel setTextColor:self.themeColor];

    } else {

        NSString *detailString = [NSString stringWithFormat:@"%@ Points by %@", self.cellContent[@"voteCount"], self.cellContent[@"author"]];
        NSRange authorRange = [detailString rangeOfString:self.cellContent[@"author"]];
        NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:12.0f],
                                    NSForegroundColorAttributeName:[UIColor tnGreyColor] };

        NSMutableAttributedString *detailAttr = [[NSMutableAttributedString alloc] initWithString:detailString attributes:textAttr];
        [detailAttr addAttribute:NSForegroundColorAttributeName value:self.lightThemeColor range:authorRange];

        [self.detailLabel setAttributedText:detailAttr];

    }

    [self adjustFrames];
}

#pragma mark - Dynamic Height Methods

- (void)adjustFrames
{
    /* Resize frame For Comment Body */
    NSNumber *depth = self.cellContent[@"depth"];
    CGRect frame = self.commentView.frame;
    //frame.size = CGSizeMake(270, [self getCommentViewHeight:self.cellContent[@"comment"]]);


    CGFloat height = [self textViewHeightForString:self.cellContent[@"comment"] andWidth:(270 - (15 * [depth intValue]))];

    frame.size.height = height;
    self.commentView.frame = frame;

    /* Move Author Label Below Comment */

    int commentViewHeight = self.commentView.frame.size.height;

    CGRect detailFrame = self.detailLabel.frame;
    detailFrame.origin.y = commentViewHeight + 20;

    /* Handle Nested Comments */

    [self.commentView setTextContainerInset:UIEdgeInsetsMake(0, 15 * [depth intValue] , 0, 0)];
    detailFrame.origin.x = 25 + 15 * [depth intValue];

    self.detailLabel.frame = detailFrame;
}

- (CGFloat)estimateCellHeightWithComment:(NSString *)comment
{
    //int commentViewHeight = [self getCommentViewHeight:comment];
    //int detailLabelHeight = self.detailLabel.frame.size.height;
    //return commentViewHeight + detailLabelHeight + 35;

    NSNumber *depth = self.cellContent[@"depth"];
    comment = self.cellContent[@"comment"];

    CGFloat x = [self textViewHeightForString:comment andWidth:(270 - (15 * [depth intValue]))] + 15 + 35;
    NSLog(@"%f",x);
    return x;
}

- (CGFloat)getCommentViewHeight:(NSString *)comment
{
    CGSize size = [self text:comment sizeWithFont:[UIFont fontWithName:@"Avenir-Book" size:14.0f] constrainedToSize:CGSizeMake(270, 5000)];
    return floorf( 1.2 * size.height);
}

#pragma mark - Swipe Gesture Methods

- (void)addUpvoteGesture
{
    [self setDefaultColor:[UIColor tnLightGreyColor]];
    UIView *upvoteView = [self viewWithImageName:@"Upvote"];
    UIColor *lightGreen = [UIColor colorWithRed:0.631 green:0.890 blue:0.812 alpha:1];

    __block TNCommentCell *blockSelf = self;

    [self setSwipeGestureWithView:upvoteView color:lightGreen mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        TNCommentCell *tnCell = (TNCommentCell *)cell;
        [blockSelf.gestureDelegate upvoteActionForCell:tnCell];

    }];
}

- (void)addReplyCommentGesture
{
    [self setDefaultColor:[UIColor tnLightGreyColor]];
    UIView *commentView = [self viewWithImageName:@"Comment"];

    __block TNCommentCell *blockSelf = self;

    [self setSwipeGestureWithView:commentView color:self.lightThemeColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        TNCommentCell *tnCell = (TNCommentCell *)cell;
        [blockSelf.gestureDelegate replyActionForCell:tnCell];
    }];
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

    type = feedType;
}

#pragma mark - Private Methods

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (CGFloat)textViewHeightForString:(NSString*)text andWidth:(CGFloat)width {

    NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:14.0f],
                                NSForegroundColorAttributeName:[UIColor blackColor] };

    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:textAttr];

    //NSLog(@"%f", width);
    [self.commentView setAttributedText:nil];
    [self.commentView setAttributedText:attrString];
    CGSize size = [self.commentView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGRect frame = [text boundingRectWithSize:size
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    return frame.size;
}

@end
