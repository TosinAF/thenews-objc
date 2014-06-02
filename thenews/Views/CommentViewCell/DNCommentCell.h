//
//  DNCommentCell.h
//  The News
//
//  Created by Tosin Afolabi on 19/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNComment.h"
#import "TNCommentCell.h"

@interface DNCommentCell : TNCommentCell

@property (nonatomic, strong) DNComment *comment;

- (void)configureForComment:(DNComment *)comment;
- (void)incrementVoteCount;

@end
