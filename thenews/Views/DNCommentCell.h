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

- (void)configureForComment:(DNComment *)comment;

@end
