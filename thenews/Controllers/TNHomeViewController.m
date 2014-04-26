//
//  TNHomeViewController.m
//  The News
//
//  Created by Tosin Afolabi on 12/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNHomeViewController.h"
#import "HNContainerViewController.h"
#import "DNContainerViewController.h"

@interface TNHomeViewController ()

@property (nonatomic, strong) TNContainerViewController *dnViewController;
@property (nonatomic, strong) TNContainerViewController *hnViewController;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation TNHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {

	[super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
	                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
	                                                                        options:@{UIPageViewControllerOptionInterPageSpacingKey:@0.0f}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;


	self.hnViewController = [HNContainerViewController new];
	self.dnViewController = [DNContainerViewController new];


	NSArray *viewControllers = @[self.dnViewController];
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
      viewControllerBeforeViewController:(TNContainerViewController *)viewController
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
       viewControllerAfterViewController:(TNContainerViewController *)viewController
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


