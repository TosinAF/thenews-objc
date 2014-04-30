//
//  HNCommentCell.m
//  The News
//
//  Created by Tosin Afolabi on 19/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "HNCommentCell.h"

@implementation HNCommentCell

- (void)configureForComment:(HNComment *)comment
{
    [self setFeedType:TNTypeHackerNews];
    self.comment = comment;

    NSDictionary *cellContent = @{@"comment":[comment Text],
                                  @"author":[comment Username],
                                  @"depth":@([comment Level]),
                                  @"commentID": [comment CommentId]};

    // Should have abstracted this to a TNContent Model with a mutable dictionary
    [self setCellContent:cellContent];
}
@end
