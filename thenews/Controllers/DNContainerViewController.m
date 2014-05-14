//
//  DNContainerViewController.m
//  The News
//
//  Created by Tosin Afolabi on 22/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNMenuView.h"
#import "DNPresentMOTDTransition.h"
#import "DNDismissMOTDTransistion.h"
#import "DNMOTDViewController.h"
#import "DNSettingsViewController.h"
#import "DNFeedViewController.h"
#import "DNSearchViewController.h"
#import "DNContainerViewController.h"

int menuIndex = 1;

@interface DNContainerViewController () <TNMenuViewDelegate, UIViewControllerTransitioningDelegate>

@end

@implementation DNContainerViewController

- (instancetype)init
{
    self = [super initWithType:TNTypeDesignerNews];
    if (self) {
        [self setScreenName:@"DNContainer"];
        self.menu = [[TNMenuView alloc] initWithFrame:CGRectZero type:TNTypeDesignerNews];
        [self.menu setDelegate:self];
    }
    return self;
}

- (void)navBarTapped
{
    if (menuIndex == 1) {
        DNFeedViewController* dnVC = (DNFeedViewController *)self.currentViewController;
        [dnVC.feedView setContentOffset:CGPointMake(0,0) animated:YES];
    }
}

#pragma mark - TNMenuView Delegate

- (void)menuActionForButtonOne
{
    if (menuIndex == 1) {

        DNFeedViewController* dnVC = (DNFeedViewController *)self.currentViewController;
        int type = [dnVC switchDNFeedType];

        int dnFeedTop = 0;

        if (type == dnFeedTop) {
            [self.menu.buttonOne setTitle:@"Top Stories" forState:UIControlStateNormal];
        } else {
            [self.menu.buttonOne setTitle:@"Recent Stories" forState:UIControlStateNormal];
        }

        [self hideMenu];

    } else {

        DNFeedViewController *vc = [DNFeedViewController new];
        self.nextViewController = vc;
        [self changeChildViewController];
        [self.navItem setTitle:@"DESIGNER NEWS"];
        [self.menu.buttonOne setTitle:@"Recent Stories" forState:UIControlStateNormal];
        menuIndex = 1;
    }
}

- (void)menuActionForButtonTwo
{
    DNMOTDViewController *vc = [DNMOTDViewController new];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;

    [self presentViewController:vc animated:YES completion:nil];
}

- (void)menuActionForButtonThree
{
    if (menuIndex == 3) {

        [self hideMenu];

    } else {

        DNSettingsViewController *vc = [DNSettingsViewController new];
        self.nextViewController = vc;
        [self changeChildViewController];
        [self.navItem setTitle:@"SETTINGS"];
        [self.menu.buttonOne setTitle:@"Top Stories" forState:UIControlStateNormal];
        menuIndex = 3;
    }
}

- (void)menuActionForSearchFieldWithText:(NSString *)text
{
    DNSearchViewController *vc = [[DNSearchViewController alloc] initWithQuery:text];
    self.nextViewController = vc;
    [self changeChildViewController];
    [self.navItem setTitle:@"SEARCH"];
    [self.menu.buttonOne setTitle:@"Top Stories" forState:UIControlStateNormal];
    menuIndex = 4;

}

- (void)menuActionForKeyboardWillAppear
{
    [self fadeOutChildViewController];
}

#pragma mark - Transitioning Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [DNPresentMOTDTransition new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [DNDismissMOTDTransistion new];
}

@end
