//
//  TNCommentCell.h
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@protocol TNCommentCellDelegate;

@interface TNCommentCell : MCSwipeTableViewCell

@property (nonatomic, strong) NSDictionary *cellContent;
@property (nonatomic, strong) NSNumber *isExpanded;
@property (nonatomic, weak) id<TNCommentCellDelegate> gestureDelegate;

- (CGFloat)updateSubviews;

- (void)addUpvoteGesture;

- (void)addReplyCommentGesture;

- (void)showToggleButton;

- (void)setFeedType:(TNType)feedType;

- (void)setCommentViewDelegate:(id<UITextViewDelegate>)delegate;

@end

@protocol TNCommentCellDelegate <NSObject>

@optional

- (void)upvoteActionForCell:(TNCommentCell *)cell;
- (void)replyActionForCell:(TNCommentCell *)cell;

@end
