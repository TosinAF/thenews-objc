//
//  TNFeedViewCell.h
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "Post.h"
#import "DNStory.h"
#import <UIKit/UIKit.h>
#import "TNFeedViewController.h"
#import "MCSwipeTableViewCell.h"

@interface TNFeedViewCell : MCSwipeTableViewCell

@property (strong, nonatomic) DNStory *story;

- (void)setForReuse;
- (void)setFeedType:(TNType)feedType;
- (void)setUpvoteBlock:(MCSwipeCompletionBlock)block;
- (void)setCommentBlock:(MCSwipeCompletionBlock)block;
- (void)setFrameHeight:(CGFloat)height;

- (void)configureForPost:(Post *)post;
- (void)configureForStory:(DNStory *)story index:(int)index;

@end
