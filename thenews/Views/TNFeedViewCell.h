//
//  TNFeedViewCell.h
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNFeedViewController.h"

@interface TNFeedViewCell : UITableViewCell

- (void)setForReuse;
- (void)setFrameHeight:(CGFloat)height;
- (void)setFeedType:(TNFeedType)feedType;
- (void)setTitle:(NSString*)title author:(NSString*)author points:(NSNumber*)points index:(NSNumber*)index commentCount:(NSNumber*)count;

@end
