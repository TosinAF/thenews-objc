//
//  TNEmptyStateView.m
//  The News
//
//  Created by Tosin Afolabi on 22/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//
// The frame should be of the entire window excluding the nav bar

#import "TNEmptyStateView.h"
#import "FBShimmeringView.h"

@interface TNEmptyStateView ()

@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) FBShimmeringView *labelShimmeringView;

@end

@implementation TNEmptyStateView

- (instancetype)init
{
    self = [super init];

    if (self) {
        [self configureSubviews];
    }

    return self;
}

- (void)configureSubviews
{
    UIImage *loadingIcon = [UIImage imageNamed:@"Loading"];

    CGRect imageViewFrame = CGRectMake(80, 170, loadingIcon.size.width, loadingIcon.size.height);
    CGRect labelFrame = CGRectMake(0, 170 + loadingIcon.size.height + 25, 320, 15);

    self.loadingView = [[UIImageView alloc] initWithImage:loadingIcon];
    [self.loadingView setFrame:imageViewFrame];

    self.infoLabel = [[UILabel alloc] initWithFrame:labelFrame];
    [self.infoLabel setText:@"DELIVERING THE NEWS..."];
    [self.infoLabel setTextAlignment:NSTextAlignmentCenter];
    [self.infoLabel setFont:[UIFont fontWithName:@"Montserrat" size:15.0f]];

    self.labelShimmeringView = [[FBShimmeringView alloc] initWithFrame:labelFrame];
    self.labelShimmeringView.contentView = self.infoLabel;

    [self addSubview:self.loadingView];
    [self addSubview:self.labelShimmeringView];
}

- (void)setText:(NSString *)text
{
    [self.infoLabel setText:text];
    [self.loadingView removeFromSuperview];
    [self.labelShimmeringView removeFromSuperview];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    [self addSubview:self.loadingView];
    [self addSubview:self.labelShimmeringView];
}

- (void)showDownloadingText
{
    [self setText:@"DELIVERING THE NEWS..."];
    [self.labelShimmeringView setShimmering:YES];
}

- (void)showErrorText
{
    [self setText:@"NO INTERNET CONNECTION :("];
    [self.labelShimmeringView setShimmering:NO];
}

- (void)showErrorWithText:(NSString *)text
{
    [self setText:text];
    [self.labelShimmeringView setShimmering:NO];
}

@end
