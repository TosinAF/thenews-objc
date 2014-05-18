//
//  TNFeedViewCell.h
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@protocol TNFeedViewCellDelegate;

@interface TNFeedViewCell : MCSwipeTableViewCell


@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIColor *lightThemeColor;
@property (nonatomic, weak) id<TNFeedViewCellDelegate> gestureDelegate;

- (void)setForReuse;
- (void)setFeedType:(TNType)feedType;
- (void)setFrameHeight:(CGFloat)height;

- (void)updateLabels:(NSDictionary *)content;
- (void)addUpvoteGesture;

- (void)addViewCommentsGesture;

@end

@protocol TNFeedViewCellDelegate <NSObject>

@optional

- (void)upvoteActionForCell:(TNFeedViewCell *)cell;
- (void)viewCommentsActionForCell:(TNFeedViewCell *)cell;

@end
