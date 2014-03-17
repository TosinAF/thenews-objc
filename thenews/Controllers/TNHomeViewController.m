//
//  TNHomeViewController.m
//  The News
//
//  Created by Tosin Afolabi on 12/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTypeEnum.h"
#import "TNFeedViewController.h"
#import "TNHomeViewController.h"
#import "TNContainerViewController.h"

@interface TNHomeViewController ()

@property (nonatomic, strong) TNContainerViewController *dnViewController;
@property (nonatomic, strong) TNContainerViewController *hnViewController;
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


	self.hnViewController = [[TNContainerViewController alloc] initWithType:TNTypeHackerNews];
	self.dnViewController = [[TNContainerViewController alloc] initWithType:TNTypeDesignerNews];



	NSArray *viewControllers = [NSArray arrayWithObjects:self.dnViewController, nil];
	[self.pageViewController setViewControllers:viewControllers
	                                  direction:UIPageViewControllerNavigationDirectionForward
	                                   animated:NO completion:nil];

    // View Controller Containment
    [self.pageViewController didMoveToParentViewController:self];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(TNFeedViewController *)viewController
{
    NSNumber *feedType = viewController.feedType;

    switch ([feedType intValue]) {
        case TNTypeDesignerNews:
            return nil;

        case TNTypeHackerNews:
            return self.dnViewController;

        default:
            return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(TNFeedViewController *)viewController
{
    NSNumber *feedType = viewController.feedType;

    switch ([feedType intValue]) {
        case TNTypeDesignerNews:
            return self.hnViewController;

        case TNTypeHackerNews:
            return nil;

        default:
            return nil;
    }
}

@end


