//
//  TNCommentCell.h
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNComment.h"
#import "MCSwipeTableViewCell.h"


@interface TNCommentCell : MCSwipeTableViewCell

@property (nonatomic, strong) NSDictionary *cellContent;
@property (copy) MCSwipeCompletionBlock upvoteBlock;
@property (copy) MCSwipeCompletionBlock replyBlock;


- (void)updateLabels;

- (void)addUpvoteGesture;

- (void)configureUpvoteBlock:(MCSwipeCompletionBlock)block;

- (void)addReplyCommentGesture;

- (void)configureReplyBlock:(MCSwipeCompletionBlock)block;

- (void)setFeedType:(TNType)feedType;

- (CGFloat)estimateCellHeightWithComment:(NSString *)comment;


@end
