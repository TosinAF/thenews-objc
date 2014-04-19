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
@property (readwrite, copy) MCSwipeCompletionBlock upvoteBlock;
@property (readwrite, copy) MCSwipeCompletionBlock commentBlock;


- (void)updateLabels;

- (void)addSwipeGesturesToCell;

- (void)setFeedType:(TNType)feedType;

- (CGFloat)estimateCellHeightWithComment:(NSString *)comment;


@end
