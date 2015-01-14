//
//  TNWelcomeViewController.m
//  The News
//
//  Created by Tosin Afolabi on 21/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//


#import "TNHomeViewController.h"
#import "TNLoginViewController.h"
#import "TNLaunchViewController.h"
#import "TNTutorialViewController.h"
#import "TNWelcomeViewController.h"

@interface TNWelcomeViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *skipButton;
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

    self.loginButton = [self createTutorialViewButtonWithText:@"Login"];
    [self.loginButton addTarget:self action:@selector(pushLoginViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTranslatesAutoresizingMaskIntoConstraints:false];

    self.skipButton = [self createTutorialViewButtonWithText:@"Skip"];
    [self.skipButton addTarget:self action:@selector(pushHomeViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.skipButton setTranslatesAutoresizingMaskIntoConstraints:false];

    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.skipButton];

    // Page View Control

    self.pageControl = [UIPageControl new];
    [self.pageControl setNumberOfPages:4];
    [self.pageControl setTranslatesAutoresizingMaskIntoConstraints:false];

    [self.view addSubview:self.pageControl];

    [self layoutSubviews];
}

- (void)layoutSubviews {

    NSDictionary *views = @{
                            @"loginButton": self.loginButton,
                            @"skipButton": self.skipButton,
                            @"pageControl": self.pageControl
                            };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[loginButton]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[loginButton]" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[skipButton]-20-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[skipButton]" options:0 metrics:nil views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[pageControl]" options:0 metrics:nil views:views]];

    

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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
	[self fixPageControlForViewController];
}

#pragma mark - Button Actions

- (void)pushLoginViewController:(id)selector
{
    TNLoginViewController *loginViewController = [TNLoginViewController new];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)pushHomeViewController:(id)selector
{
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

- (void)fixPageControlForViewController
{
	// since iOS 6 `[[self.pageViewController viewControllers] firstObject]` should be the current VC
	// see: http://stackoverflow.com/questions/8400870/uipageviewcontroller-return-the-current-visible-view
    if ([[[self.pageViewController viewControllers] firstObject] isKindOfClass:[TNLaunchViewController class]]) {
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.pageIndicatorTintColor  = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
	else {
        self.pageControl.currentPageIndicatorTintColor = [UIColor tnColor];
        self.pageControl.pageIndicatorTintColor  = [UIColor tnGreyColor];
    }
}

@end
