//
//  TNHomeViewController.m
//  The News
//
//  Created by Tosin Afolabi on 12/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNFeedViewController.h"
#import "TNHomeViewController.h"

@interface TNHomeViewController ()

@property (nonatomic, strong) TNFeedViewController *dnViewController;
@property (nonatomic, strong) TNFeedViewController *hnViewController;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation TNHomeViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLoad {

	[super viewDidLoad];

	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
	                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
	                                                                        options:@{UIPageViewControllerOptionInterPageSpacingKey:@0.0f}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;


	self.hnViewController = [[TNFeedViewController alloc] initWithFeedType:TNFeedTypeHackerNews];
	self.dnViewController = [[TNFeedViewController alloc] initWithFeedType:TNFeedTypeDesignerNews];



	NSArray *viewControllers = [NSArray arrayWithObjects:self.dnViewController, nil];
	[self.pageViewController setViewControllers:viewControllers
	                                  direction:UIPageViewControllerNavigationDirectionForward
	                                   animated:NO completion:nil];

    // View Controller Containment
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    //[self.pageViewController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.pageViewController.view];

    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(TNFeedViewController *)viewController
{
    NSNumber *feedType = viewController.feedType;

    switch ([feedType intValue]) {
        case TNFeedTypeDesignerNews:
            return nil;

        case TNFeedTypeHackerNews:
            return self.dnViewController;

        default:
            // will never reach here
            return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(TNFeedViewController *)viewController
{
    NSNumber *feedType = viewController.feedType;

    switch ([feedType intValue]) {
        case TNFeedTypeDesignerNews:
            return self.hnViewController;

        case TNFeedTypeHackerNews:
            return nil;

        default:
            // will never reach here
            return nil;
    }
}

@end


