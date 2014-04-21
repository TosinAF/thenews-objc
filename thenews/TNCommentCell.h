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
@property (nonatomic, weak) id<TNCommentCellDelegate> gestureDelegate;

- (void)updateLabels;

- (void)addUpvoteGesture;

- (void)addReplyCommentGesture;

- (void)setFeedType:(TNType)feedType;

- (CGFloat)estimateCellHeightWithComment:(NSString *)comment;

@end

@protocol TNCommentCellDelegate <NSObject>

@optional

- (void)upvoteActionForCell:(TNCommentCell *)cell;
- (void)replyActionForCell:(TNCommentCell *)cell;

@end
