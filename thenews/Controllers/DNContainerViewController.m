//
//  DNContainerViewController.m
//  The News
//
//  Created by Tosin Afolabi on 22/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNMenuView.h"
#import "DNFeedViewController.h"
#import "DNSearchViewController.h"
#import "DNContainerViewController.h"

int menuIndex = 1;

@interface DNContainerViewController () <TNMenuViewDelegate>

@end

@implementation DNContainerViewController

- (instancetype)init
{
    self = [super initWithType:TNTypeDesignerNews];
    if (self) {
        self.menu = [[TNMenuView alloc] initWithFrame:CGRectZero type:TNTypeDesignerNews];
        [self.menu setDelegate:self];
    }
    return self;
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

}

- (void)menuActionForButtonThree
{
    NSLog(@"Button Three Called");
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

#pragma mark - Private Methods

 - (void)changeChildViewController
 {
     [self addChildViewController:self.nextViewController];
     [self.currentViewController willMoveToParentViewController:nil];
     [self hideMenu];

     // Make the transition with a very short Cross disolve animation
     [self transitionFromViewController:self.currentViewController
                       toViewController:self.nextViewController
                               duration:0.1f
                                options:UIViewAnimationOptionTransitionCrossDissolve
                             animations:^{

     }
                             completion:^(BOOL finished) {
                                 [self.currentViewController removeFromParentViewController];
                                 [self.view addSubview:self.nextViewController.view];
                                 [self.nextViewController didMoveToParentViewController:self];
                                 self.currentViewController = self.nextViewController;

                                 [self.navBar removeFromSuperview];
                                 [self.view addSubview:self.navBar];

     }];
 }

@end
