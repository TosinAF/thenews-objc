//
//  TNCommentCell.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNCommentCell.h"

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

        self.commentView = [[UITextView alloc] initWithFrame:CGRectMake(20, 15, 270, 2000)];
        [self.commentView setEditable:NO];
        [self.commentView setScrollEnabled:NO];
        [self.commentView setSelectable:YES];
        [self.commentView setDataDetectorTypes:UIDataDetectorTypeLink];

        [self addSubview:self.commentView];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setSeparatorInset:UIEdgeInsetsZero];
        [self setFirstTrigger:0.20];

    }

    return self;
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

- (CGFloat)updateSubviews
{
    NSLog(@"%@", self.cellContent[@"comment"]);
    NSAttributedString *attrString = [self configureAttributedString];
    CGFloat textInset = (15 * [self.cellContent[@"depth"] intValue]);
    CGFloat width = 270 - textInset;
    CGFloat height = [self textViewHeightForString:attrString width:width];

    CGRect frame = self.commentView.frame;
    frame.size.height = height;
    self.commentView.frame = frame;

    [self.commentView setTextContainerInset:UIEdgeInsetsMake(0, textInset, 0, 0)];

    return height + 25; // Height to be used for height for row at index path
}

#pragma mark - Dynamic Height Methods

- (CGFloat)textViewHeightForString:(NSAttributedString *)text width:(CGFloat)width {

    [self.commentView setAttributedText:nil];
    [self.commentView setAttributedText:text];

    CGSize size = [self.commentView sizeThatFits:CGSizeMake(width, FLT_MAX)];

    return size.height;
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

#pragma mark - Private Methods

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (NSAttributedString *)configureAttributedString
{
    NSMutableString *comment = [[NSMutableString alloc] initWithString:self.cellContent[@"comment"]];
    comment = [[comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];

    NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:14.0f],
                                NSForegroundColorAttributeName:[UIColor blackColor] };

    /* --- Comment Metadata --- */

    NSString *detailString, *pointsString;

    if (type == TNTypeHackerNews) {

        detailString = [NSString stringWithFormat:@"\n\n%@", self.cellContent[@"author"]];

    } else {

        int voteCount = [self.cellContent[@"voteCount"] intValue];

        if (voteCount == 1) {

            detailString = [NSString stringWithFormat:@"\n\n1 Point by %@", self.cellContent[@"author"]];
            pointsString = [NSString stringWithFormat:@"1 Point by"];

        } else {

            detailString = [NSString stringWithFormat:@"\n\n%@ Points by %@", self.cellContent[@"voteCount"], self.cellContent[@"author"]];
            pointsString = [NSString stringWithFormat:@"%@ Points by", self.cellContent[@"voteCount"]];
        }
    }

    [comment insertString:detailString atIndex:[comment length]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:comment attributes:textAttr];

    NSRange authorRange = [comment rangeOfString:self.cellContent[@"author"]];
    [attrString addAttribute:NSForegroundColorAttributeName value:self.lightThemeColor range:authorRange];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:12.0f] range:authorRange];

    if(type == TNTypeDesignerNews) {
        NSRange pointsRange = [comment rangeOfString:pointsString];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor tnGreyColor] range:pointsRange];
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:12.0f] range:pointsRange];
    } else {
        //increase font of author in hn
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:14.0f] range:authorRange];
    }
    
    return [[NSAttributedString alloc] initWithAttributedString:attrString];
}

@end
