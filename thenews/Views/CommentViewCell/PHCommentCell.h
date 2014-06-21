//
//  PHCommentCell.h
//  The News
//
//  Created by Tosin Afolabi on 14/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHComment.h"
#import "TNCommentCell.h"

@interface PHCommentCell : TNCommentCell


- (void)configureForComment:(PHComment *)comment;

@end
