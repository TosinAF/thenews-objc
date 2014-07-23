//
//  HNContainerViewController.m
//  The News
//
//  Created by Tosin Afolabi on 26/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "HNFeedViewController.h"
#import "HNSettingsViewController.h"
#import "HNContainerViewController.h"

bool inSettingsView = false;

@interface HNContainerViewController () <TNMenuViewDelegate>

@end

@implementation HNContainerViewController

- (instancetype)init
{
    self = [super initWithType:TNTypeHackerNews];
    if (self) {
        [self setScreenName:@"HNContainer"];
        self.menu = [[TNMenuView alloc] initWithFrame:CGRectZero type:TNTypeHackerNews];
        [self.menu setButtonTitles:@[@"Top Posts", @"Show HN", @"Ask HN", @"Settings"]];
        [self.menu setDelegate:self];
    }
    return self;
}

- (void)navBarTapped
{
    if (!inSettingsView) {
        HNFeedViewController* hnVC = (HNFeedViewController *)self.currentViewController;
        [hnVC.feedView setContentOffset:CGPointMake(0,0) animated:YES];
    }
}

#pragma mark - TNMenuView Delegate

- (void)menuActionForButtonOne
{
    HNFeedViewController *hnVC;

    if (inSettingsView) {

        hnVC = [HNFeedViewController new];
        self.nextViewController = hnVC;
        [self.navItem setTitle:@"HACKER NEWS"];
        [self changeChildViewController];

    } else {

        hnVC = (HNFeedViewController *)self.currentViewController;
        [hnVC setPostFilterType:PostFilterTypeTop];
    }

    [self hideMenu];
    [self.menu moveIndicatorTo:1];
    inSettingsView = false;
}

- (void)menuActionForButtonTwo
{
    HNFeedViewController *hnVC;

    if (inSettingsView) {

        hnVC = [[HNFeedViewController alloc] initWithPostFilterType:PostFilterTypeShowHN];
        self.nextViewController = hnVC;
        [self.navItem setTitle:@"HACKER NEWS"];
        [self changeChildViewController];

    } else {

        hnVC = (HNFeedViewController *)self.currentViewController;
        [hnVC setPostFilterType:PostFilterTypeShowHN];
    }

    [self hideMenu];
    [self.menu moveIndicatorTo:2];
    inSettingsView = false;
}

- (void)menuActionForButtonThree
{
    HNFeedViewController *hnVC;

    if (inSettingsView) {
        hnVC = [[HNFeedViewController alloc] initWithPostFilterType:PostFilterTypeAsk];
        self.nextViewController = hnVC;
        [self.navItem setTitle:@"HACKER NEWS"];
        [self changeChildViewController];

    } else {

        hnVC = (HNFeedViewController *)self.currentViewController;
        [hnVC setPostFilterType:PostFilterTypeAsk];
    }

    [self hideMenu];
    [self.menu moveIndicatorTo:3];
    inSettingsView = false;
}

- (void)menuActionForButtonFour
{
    if (!inSettingsView) {

        HNSettingsViewController *settingsVC = [HNSettingsViewController new];
        self.nextViewController = settingsVC;
        [self changeChildViewController];
        [self.menu moveIndicatorTo:0];
        [self.navItem setTitle:@"SETTINGS"];

    } else {

        [self hideMenu];
    }

    inSettingsView = true;
}

- (void)menuActionForKeyboardWillAppear
{
    [self fadeOutChildViewController];
}

@end
