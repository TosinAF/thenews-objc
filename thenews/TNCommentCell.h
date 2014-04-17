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

@class TNCommentCell;

typedef void (^TNSwipeCompletionBlock) (TNCommentCell *cell);

@interface TNCommentCell : MCSwipeTableViewCell

@property (nonatomic, strong) DNComment *comment;

@property (readwrite, copy) TNSwipeCompletionBlock upvoteBlock;
@property (readwrite, copy) TNSwipeCompletionBlock commentBlock;

- (void)addSwipeGesturesToCell;
- (void)configureForComment:(DNComment *)comment;
- (CGFloat)estimateHeightWithComment:(DNComment *)comment;

@end
