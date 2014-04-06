//
//  HNFeedViewCell.h
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "HNPost.h"
#import "TNFeedViewCell.h"

@interface HNFeedViewCell : TNFeedViewCell

@property (strong, nonatomic) HNPost *post;

- (void)configureForPost:(HNPost *)post;

@end
