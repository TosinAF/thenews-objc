//
//  TNHomeViewController.m
//  The News
//
//  Created by Tosin Afolabi on 12/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNHomeViewController.h"
#import "TNPageViewController.h"
#import "DNContainerViewController.h"
#import "HNContainerViewController.h"
#import "PHContainerViewController.h"

static NSString * const LastViewedContainerKey = @"LastViewedContainer";

@interface TNHomeViewController ()

@property (nonatomic, strong) TNContainerViewController *dnViewController;
@property (nonatomic, strong) TNContainerViewController *hnViewController;
@property (nonatomic, strong) TNContainerViewController *phViewController;
@property (nonatomic, strong) TNPageViewController *pageViewController;

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
    [self setScreenName:@"Home"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

	self.pageViewController = [[TNPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
	                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
	                                                                        options:@{UIPageViewControllerOptionInterPageSpacingKey:@0.0f}];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;

	self.hnViewController = [HNContainerViewController new];
	self.dnViewController = [DNContainerViewController new];
    self.phViewController = [PHContainerViewController new];


	NSArray *viewControllers = @[self.dnViewController];
    NSNumber *feedType = [[NSUserDefaults standardUserDefaults] objectForKey:LastViewedContainerKey];

    if (feedType) {

        switch ([feedType intValue]) {
            case TNTypeDesignerNews:
                viewControllers = @[self.dnViewController];
                break;

            case TNTypeHackerNews:
                viewControllers = @[self.hnViewController];
                break;

            case TNTypeProductHunt:
                viewControllers = @[self.phViewController];
                break;

            default:
                viewControllers = @[self.dnViewController];
                break;
        }
    }


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
            return self.phViewController;

        case TNTypeHackerNews:
            return self.dnViewController;

        case TNTypeProductHunt:
            return nil;

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

        case TNTypeProductHunt:
            return self.dnViewController;

        default:
            return nil;
    }
}

#pragma mark - AppDelegate Method

- (void)saveCurrentViewController
{
    TNContainerViewController *currentVC = [self.pageViewController.viewControllers firstObject];
    NSNumber *feedType =  currentVC.feedType;

    [[NSUserDefaults standardUserDefaults] setObject:feedType forKey:LastViewedContainerKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end


