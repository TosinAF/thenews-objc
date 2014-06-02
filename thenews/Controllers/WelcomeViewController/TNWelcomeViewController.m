//
//  TNWelcomeViewController.m
//  The News
//
//  Created by Tosin Afolabi on 21/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "GAIDictionaryBuilder.h"
#import "TNHomeViewController.h"
#import "TNLoginViewController.h"
#import "TNLaunchViewController.h"
#import "TNTutorialViewController.h"
#import "TNWelcomeViewController.h"

@interface TNWelcomeViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) TNLaunchViewController *launchViewController;

@end

@implementation TNWelcomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScreenName:@"Welcome"];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
	                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
	                                                                        options:@{UIPageViewControllerOptionInterPageSpacingKey:@0.0f}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;

    self.launchViewController = [TNLaunchViewController new];
    
    NSArray *viewControllers = @[self.launchViewController];
	[self.pageViewController setViewControllers:viewControllers
	                                  direction:UIPageViewControllerNavigationDirectionForward
	                                   animated:NO completion:nil];

    // View Controller Containment

    [self.pageViewController didMoveToParentViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Tutorial View Buttons

    UIButton *loginButton = [self createTutorialViewButtonWithText:@"Login"];
    [loginButton setFrame:CGRectMake(10, 25, 70, 25)];
    [loginButton addTarget:self action:@selector(pushLoginViewController:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *skipButton = [self createTutorialViewButtonWithText:@"Skip"];
    [skipButton setFrame:CGRectMake(250, 25, 70, 25)];
    [skipButton addTarget:self action:@selector(pushHomeViewController:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:loginButton];
    [self.view addSubview:skipButton];

    // Page View Control

    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(110, 150, 100, 20)];
    [self.pageControl setNumberOfPages:4];

    [self.view addSubview:self.pageControl];
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.pageControl.currentPage -= 1;

    if ([viewController isKindOfClass:[TNLaunchViewController class]]) {

        [self.view setBackgroundColor:[UIColor tnColor]];
        return nil;

    } else {

        TNTutorialViewController *tutorialVC = (TNTutorialViewController *)viewController;

        switch (tutorialVC.type) {

            case TNTutorialNavigationBarSwipe:
                return self.launchViewController;
                break;

            case TNTutorialRightTableViewCellSwipe:
                return [[TNTutorialViewController alloc] initWithTutorial:TNTutorialNavigationBarSwipe];
                break;

            case TNTutorialLeftTableViewCellSwipe:
                return [[TNTutorialViewController alloc] initWithTutorial:TNTutorialRightTableViewCellSwipe];
                break;

        }
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    self.pageControl.currentPage += 1;

    if ([viewController isKindOfClass:[TNLaunchViewController class]]) {

        return [[TNTutorialViewController alloc] initWithTutorial:TNTutorialNavigationBarSwipe];

    } else {

        TNTutorialViewController *tutorialVC = (TNTutorialViewController *)viewController;

        switch (tutorialVC.type) {

            case TNTutorialNavigationBarSwipe:
                [self.view setBackgroundColor:[UIColor whiteColor]];
                return [[TNTutorialViewController alloc] initWithTutorial:TNTutorialRightTableViewCellSwipe];
                break;

            case TNTutorialRightTableViewCellSwipe:
                return [[TNTutorialViewController alloc] initWithTutorial:TNTutorialLeftTableViewCellSwipe];
                break;

            case TNTutorialLeftTableViewCellSwipe:
                return nil;
                break;
                
        }
    }
}

#pragma mark - UIPageViewControllerDelegate Methods

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers 
{
    UIViewController *vc = [pendingViewControllers firstObject];
    [self fixPageControlForViewController:vc];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        return;
    }

    UIViewController *vc = [previousViewControllers firstObject];
    [self fixPageControlForViewController:vc];
}

#pragma mark - Button Actions

- (void)pushLoginViewController:(id)selector
{
    [self logButtonPress:(UIButton *)selector];

    TNLoginViewController *loginViewController = [TNLoginViewController new];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)pushHomeViewController:(id)selector
{
    [self logButtonPress:(UIButton *)selector];
    
    TNHomeViewController *homeViewController = [TNHomeViewController new];
    [self.navigationController pushViewController:homeViewController animated:YES];

    // Remove Welcome View Controller as No Longer Accessible
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [self.navigationController setViewControllers:@[[viewControllers lastObject]]];
}

#pragma mark - Private Methods

- (UIButton *)createTutorialViewButtonWithText:(NSString *)text
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor tnColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor tnColor] forState:UIControlStateHighlighted];
    [[button titleLabel] setFont:[UIFont fontWithName:@"Montserrat" size:18.0f]];

    return button;
}

- (void)fixPageControlForViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[TNLaunchViewController class]]) {

        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.pageIndicatorTintColor  = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

    } else {

        self.pageControl.currentPageIndicatorTintColor = [UIColor tnColor];
        self.pageControl.pageIndicatorTintColor  = [UIColor tnGreyColor];
    }
}

- (void)logButtonPress:(UIButton *)button{

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker set:kGAIScreenName value:@"Welcome"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:[button.titleLabel text]
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
}

@end
