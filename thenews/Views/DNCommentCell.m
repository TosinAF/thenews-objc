//
//  DNCommentCell.m
//  The News
//
//  Created by Tosin Afolabi on 19/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNCommentCell.h"

@implementation DNCommentCell

- (void)configureForComment:(DNComment *)comment
{
    [self setFeedType:TNTypeDesignerNews];

    NSDictionary *cellContent = @{@"comment":[comment body],
                                  @"voteCount":[comment voteCount],
                                  @"author":[comment author],
                                  @"depth":[comment depth],
                                  @"commentID": [comment commentID]};

    // Should have abstracted this to a TNContent Model with a mutable dictionary
    [self setCellContent:cellContent];
}



@end
