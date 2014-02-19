//
//  TNFeedViewCell.h
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "Post.h"
#import <UIKit/UIKit.h>
#import "TNFeedViewController.h"

@interface TNFeedViewCell : UITableViewCell

- (void)setForReuse;
- (void)setFrameHeight:(CGFloat)height;
- (void)setFeedType:(TNFeedType)feedType;
- (void)configureForPost:(Post *)post;

@end
