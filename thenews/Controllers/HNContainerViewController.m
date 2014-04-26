//
//  HNContainerViewController.m
//  The News
//
//  Created by Tosin Afolabi on 26/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "HNFeedViewController.h"
#import "HNContainerViewController.h"

bool inSettingsView = false;

@interface HNContainerViewController () <TNMenuViewDelegate>

@end

@implementation HNContainerViewController

- (instancetype)init
{
    self = [super initWithType:TNTypeHackerNews];
    if (self) {
        self.menu = [[TNMenuView alloc] initWithFrame:CGRectZero type:TNTypeHackerNews];
        [self.menu setButtonTitles:@[@"Top Posts", @"New Posts", @"Ask HN", @"Settings"]];
        [self.menu setDelegate:self];
    }
    return self;
}

#pragma mark - TNMenuView Delegate

- (void)menuActionForButtonOne
{
    HNFeedViewController* hnVC = (HNFeedViewController *)self.currentViewController;
    [hnVC setPostFilterType:0];
    [self hideMenu];
    inSettingsView = false;
}

- (void)menuActionForButtonTwo
{
    HNFeedViewController* hnVC = (HNFeedViewController *)self.currentViewController;
    [hnVC setPostFilterType:2];
    [self hideMenu];
    inSettingsView = false;
}

- (void)menuActionForButtonThree
{
    HNFeedViewController* hnVC = (HNFeedViewController *)self.currentViewController;
    [hnVC setPostFilterType:1];
    [self hideMenu];
    inSettingsView = false;
}

- (void)menuActionForButtonFour
{
    NSLog(@"Button four clicked");
    [self hideMenu];
    inSettingsView = true;
}

- (void)menuActionForKeyboardWillAppear
{
    [self fadeOutChildViewController];
}

@end
