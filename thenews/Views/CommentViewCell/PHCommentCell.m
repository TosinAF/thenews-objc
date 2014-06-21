//
//  PHCommentCell.m
//  The News
//
//  Created by Tosin Afolabi on 14/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHCommentCell.h"

@implementation PHCommentCell

- (void)configureForComment:(PHComment *)comment
{
    [self setFeedType:TNTypeProductHunt];

    NSDictionary *cellContent = @{@"comment":[comment comment],
                                  @"author":[[comment hunter] name],
                                  @"depth":@(0),
                                  @"commentID":@(0)};

    // Should have abstracted this to a TNContent Model with a mutable dictionary
    [self setCellContent:cellContent];
}

@end
