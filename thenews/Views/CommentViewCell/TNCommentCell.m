//
//  TNCommentCell.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#import "TNCommentCell.h"

TNType type;

@interface TNCommentCell () <UITextViewDelegate>

@property (nonatomic) UIColor *themeColor;
@property (nonatomic) UIColor *lightThemeColor;

@property (nonatomic) UITextView *commentView;
@property (nonatomic) UIView *leftBorder;
@property (nonatomic) UIButton *toggleButton;

@end

@implementation TNCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {

        CGRect frame = CGRectMake(20, 15, self.contentView.frame.size.width, 1000);
        if (IS_IPHONE_4_OR_LESS  || IS_IPHONE_5) {
            frame.size.width = 270;
        }

        self.commentView = [[UITextView alloc] initWithFrame:frame];
        [self.commentView setEditable:NO];
        [self.commentView setDelegate:self];
        [self.commentView setSelectable:YES];
        [self.commentView setScrollEnabled:NO];
        [self.commentView setTextAlignment:NSTextAlignmentJustified];
        [self.commentView setDataDetectorTypes:UIDataDetectorTypeLink];

        if (self.leftBorder) {
            [self.leftBorder removeFromSuperview];
        } else {
            self.leftBorder = [UIView new];
        }

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setSeparatorInset:UIEdgeInsetsZero];
        [self setFirstTrigger:0.20];

        /*

         if (self.toggleButton) {
         [self.leftBorder removeFromSuperview];
         } else {
         self.toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [self.toggleButton setBackgroundImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
         }


        self.isExpanded = [NSNumber numberWithBool:1];
         
        */
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

        case TNTypeProductHunt:
			self.themeColor = [UIColor phColor];
			self.lightThemeColor = [UIColor phLightColor];
			break;
	}

    type = feedType;
}

- (void)setCommentViewDelegate:(id<UITextViewDelegate>)delegate
{
    [self.commentView setDelegate:delegate];
}

- (void)showToggleButton
{
    [self addSubview:self.toggleButton];
}

- (CGFloat)updateSubviews
{
    NSAttributedString *attrString = [self configureAttributedString];
    CGFloat textInset = (15 * [self.cellContent[@"depth"] intValue]);

    [self.commentView setTextContainerInset:UIEdgeInsetsMake(0, textInset, 0, 0)];

    CGFloat height = [self textViewHeightForString:attrString];

    CGRect frame = self.commentView.frame;
    frame.size.height = height;
    self.commentView.frame = frame;

    [self addSubview:self.commentView];

    if ([self.cellContent[@"depth"] intValue] > 0) {

        [self.leftBorder setFrame:CGRectMake(self.commentView.frame.origin.x + textInset - 5, self.commentView.frame.origin.y, 2, self.commentView.frame.size.height)];

        [self.leftBorder setBackgroundColor:[UIColor tnLightGreyColor]];

        [self addSubview:self.leftBorder];
    }

    /*

    [self.toggleButton setFrame:CGRectMake(self.commentView.frame.origin.x + self.commentView.frame.size.width - 10, self.commentView.frame.origin.y + self.commentView.frame.size.height - 17, 11, 6)];
     
     */

    return height + 45; // Height to be used for height for row at index path
}

#pragma mark - Dynamic Height Methods

- (CGFloat)textViewHeightForString:(NSAttributedString *)text {

    [self.commentView setAttributedText:nil];
    [self.commentView setAttributedText:text];

    CGFloat width = self.contentView.frame.size.width;
    if (IS_IPHONE_4_OR_LESS  || IS_IPHONE_5) {
        width = 270;
    }

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

- (NSAttributedString *)configureAttributedString
{
    NSMutableString *comment = [[NSMutableString alloc] initWithString:self.cellContent[@"comment"]];
    comment = [[comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];

    NSDictionary *textAttr = @{ NSFontAttributeName:[UIFont fontWithName:@"Avenir-Book" size:14.0f],
                                NSForegroundColorAttributeName:[UIColor blackColor] };

    /* --- Comment Metadata --- */

    NSString *detailString, *pointsString;

    if (type == TNTypeHackerNews || type == TNTypeProductHunt ) {

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
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Book" size:12.0f] range:authorRange];

    if(type == TNTypeDesignerNews) {
        NSRange pointsRange = [comment rangeOfString:pointsString];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor tnGreyColor] range:pointsRange];
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Book" size:12.0f] range:pointsRange];
    } else {
        //increase font of author in hn
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Book" size:14.0f] range:authorRange];
    }
    
    return [[NSAttributedString alloc] initWithAttributedString:attrString];
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

@end
