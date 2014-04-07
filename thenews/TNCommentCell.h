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

- (void)configureForComment:(DNComment *)comment;
- (CGFloat)estimateHeightWithComment:(DNComment *)comment;

@end
