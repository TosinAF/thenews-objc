//
//  TNRefreshView.m
//  The News
//
//  Created by Tosin Afolabi on 28/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "FBShimmering.h"
#import "FBShimmeringView.h"
#import "TNRefreshView.h"

@implementation TNRefreshView

- (instancetype)initWithFrame:(CGRect)frame state:(TNRefreshState)state
{
    self = [super initWithFrame:frame];
    if (self) {

        switch (state) {
            case TNRefreshStatePulling:
                [self setupWithText:@"Pull To Refresh"];
                break;

            case TNRefreshStateLoading:
                [self setupWithShimmer:@"Delievering The Latest..."];
                break;

            case TNRefreshStateEnded:
                [self setupWithText:@"Enjoy!"];
                break;

        }
    }
    return self;
}

- (void)setupWithShimmer:(NSString *)text
{

    UIView *containerView = [[UIView alloc] initWithFrame:self.frame];
    [containerView setBackgroundColor:[UIColor tnLightGreyColor]];

    FBShimmeringView *loadingIndicator = [[FBShimmeringView alloc] initWithFrame:self.bounds];

    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:loadingIndicator.bounds];
    [loadingLabel setText:text];
    [loadingLabel setTextColor:[UIColor blackColor]];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:15.0f]];

    loadingIndicator.contentView = loadingLabel;
    // need to stop shimmering somehow
    loadingIndicator.shimmering = YES;

    [containerView addSubview:loadingIndicator];
    [self addSubview:containerView];

}

- (void)setupWithText:(NSString *)text
{
    UIView *containerView = [[UIView alloc] initWithFrame:self.frame];
    [containerView setBackgroundColor:[UIColor tnLightGreyColor]];

    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:self.frame];
    loadingLabel.text = text;
    [loadingLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:15.0f]];
    [loadingLabel setTextColor:[UIColor blackColor]];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];

    [containerView addSubview:loadingLabel];
    [self addSubview:containerView];
}

@end
