//
//  TNFeedViewCell.h
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "HNPost.h"
#import "DNStory.h"
#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@interface TNFeedViewCell : MCSwipeTableViewCell

@property (strong, nonatomic) DNStory *story;

- (void)setForReuse;
- (void)setFeedType:(TNType)feedType;
- (void)setUpvoteBlock:(MCSwipeCompletionBlock)block;
- (void)setCommentBlock:(MCSwipeCompletionBlock)block;
- (void)setFrameHeight:(CGFloat)height;

- (void)configureForPost:(HNPost *)post;
- (void)configureForStory:(DNStory *)story;

@end
