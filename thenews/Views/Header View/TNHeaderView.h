//
//  TNHeaderView.h
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNStory.h"
#import "HNPost.h"
#import <UIKit/UIKit.h>

typedef void (^ButtonActionBlock)(void);

@interface TNHeaderView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIColor *lightThemeColor;

- (id)initWithFrame:(CGRect)frame type:(TNType)type;
- (void)configureForStory:(DNStory *)story;
- (void)configureForPost:(HNPost *)post;

- (void)showButton;
- (void)setButtonTitle:(NSString *)title;
- (void)setButtonAction:(ButtonActionBlock)block;
- (void)adjustViewsRelativeToTitleLabel;

@end
