//
//  HNCommentCell.h
//  The News
//
//  Created by Tosin Afolabi on 19/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "HNComment.h"
#import "TNCommentCell.h"

@interface HNCommentCell : TNCommentCell

@property (nonatomic, strong) HNComment *comment;

- (void)configureForComment:(HNComment *)comment;

@end
