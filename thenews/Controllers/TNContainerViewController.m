//
//  TNContainerViewController.m
//  The News
//
//  Created by Tosin Afolabi on 11/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNMenuView.h"
#import "DNMOTDViewController.h"
#import "DNPresentMOTDTransition.h"
#import "DNFeedViewController.h"
#import "HNFeedViewController.h"
#import "TNContainerViewController.h"

CAShapeLayer *openMenuShape;
UITapGestureRecognizer *exitMenuTap;

__weak TNContainerViewController *weakSelf;

@interface TNContainerViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) UIColor *navbarColor;

@end

@implementation TNContainerViewController

- (id)initWithType:(TNType)type {
	self = [super init];
	if (self) {

        self.feedType = [NSNumber numberWithInt:type];

		switch (type) {
			case TNTypeDesignerNews:
				self.navTitle = @"DESIGNER NEWS";
				self.navbarColor = [UIColor dnColor];
				break;

			case TNTypeHackerNews:
				self.navTitle = @"HACKER NEWS";
				self.navbarColor = [UIColor hnColor];
				break;
		}
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self defaultNavbarOptions];
    [self.navigationController setNavigationBarHidden:YES];
    exitMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitMenuOnTapRecognizer:)];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self drawOpenMenuShape];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavbarApperance];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    /* Set Up Menu View */
    [self configureMenu];

    /* Set up First Child View Controller */

    UIViewController *feedViewController;

    if ([self.feedType intValue] == 0) {
        feedViewController = [DNFeedViewController new];
    } else {
        feedViewController = [HNFeedViewController new];
    }

    self.currentViewController = feedViewController;
    [self addChildViewController:feedViewController];
    [self.view addSubview:feedViewController.view];
    [feedViewController didMoveToParentViewController:self];

    [self.view addSubview:self.navBar];
}

- (void)setNavbarApperance
{
    CGFloat navBarHeight = 64.0;
	CGSize screenSize = self.view.frame.size;

	self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, navBarHeight)];
	self.navItem = [[UINavigationItem alloc] initWithTitle:self.navTitle];
    [self.navBar setTranslucent:YES];

    [self defaultNavbarOptions];

    self.menuButton = ({
        UIImage *menuOpenImage = [UIImage imageNamed:@"menuOpen"];
        UIImage *menuClosedImage = [UIImage imageNamed:@"menuClosed"];
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setImage:menuClosedImage forState:UIControlStateNormal];
        [menuButton setImage:menuOpenImage forState:UIControlStateSelected];
        [menuButton setFrame:CGRectMake(0, 0, menuOpenImage.size.width + 10, menuOpenImage.size.height + 10)];
        [menuButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        menuButton;
    });

	self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
	[self.navBar pushNavigationItem:self.navItem animated:NO];
}

- (void)defaultNavbarOptions
{
    [self.navBar setBarTintColor:self.navbarColor];
	[self.navBar setTintColor:[UIColor whiteColor]];
	[self.navBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:16.0f],
	                                       NSForegroundColorAttributeName:[UIColor whiteColor] }];
}

#pragma mark - Drop Down Menu Methods

- (void)configureMenu {

    if (self.menu) {
        [self.menu setFrame:CGRectMake(0, -208, 320, 208)];
    } else {
        self.menu = [[TNMenuView alloc] initWithFrame:CGRectMake(0, -208, 320, 208) type:[self.feedType intValue]];
    }

    [self.menu setHidden:YES];
    [self.menu setup];


    

    [self.view addSubview:self.menu];
}

//#pragma mark - Transitioning Delegate
/*

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[DNPresentMOTDTransition alloc] init];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    //return [[THDismissDetailTransition alloc] init];
}
 */


- (void)toggleMenu {

    if(self.menu.hidden) {

        [self showMenu];
        [self.menuButton setSelected:YES];

    } else {
        
        [self hideMenu];
    }
}

- (void)showMenu {

    self.menu.hidden = NO;
    float containerAlpha = 0.5f;
    [[[self view] layer] addSublayer:openMenuShape];
    [self.view addGestureRecognizer:exitMenuTap];

    [self.currentViewController.view setUserInteractionEnabled:NO];

    // Set new origin of menu
    CGRect menuFrame = self.menu.frame;
    menuFrame.origin.y = self.navBar.frame.size.height;
    CGRect containerFrame = self.currentViewController.view.frame;
    containerFrame.origin.y = self.navBar.frame.size.height + 208 - 64;


    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:4.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.menu setFrame:menuFrame];
                         [self.currentViewController.view setFrame:containerFrame];
                         [self.currentViewController.view setAlpha:containerAlpha];
                     }
                     completion:^(BOOL finished){
                     }];

    [UIView commitAnimations];
}

- (void)hideMenu {

    float containerAlpha = 1.0f;
    [self.menuButton setSelected:NO];
    [openMenuShape removeFromSuperlayer];
    [self.view removeGestureRecognizer:exitMenuTap];
    [self.menu toDefaultState];
    [self.currentViewController.view setUserInteractionEnabled:YES];

    // Set new origin of Menu & Contianer
    CGRect menuFrame = self.menu.frame;
    CGRect containerFrame = self.currentViewController.view.frame;
    menuFrame.origin.y = self.navBar.frame.size.height-menuFrame.size.height;
    containerFrame.origin.y = 0.0f;

    [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:1.0 initialSpringVelocity:4.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.menu setFrame:menuFrame];
                         [self.currentViewController.view setFrame:containerFrame];
                         [self.currentViewController.view setAlpha: containerAlpha];
                     }
                     completion:^(BOOL finished){
                         self.menu.hidden = YES;
                     }];

    [UIView commitAnimations];
}

- (void)drawOpenMenuShape {

    openMenuShape = [CAShapeLayer layer];

    // Constants to ease drawing the border and the stroke.
    int height = self.navBar.frame.size.height;
    int width = self.navBar.frame.size.width;
    int triangleSize = 10;
    int trianglePosition = 276;

    // The path for the triangle (showing that the menu is open).
    UIBezierPath *triangleShape = [[UIBezierPath alloc] init];
    [triangleShape moveToPoint:CGPointMake(trianglePosition, height)];
    [triangleShape addLineToPoint:CGPointMake(trianglePosition+triangleSize, height+triangleSize)];
    [triangleShape addLineToPoint:CGPointMake(trianglePosition+2*triangleSize, height)];
    [triangleShape addLineToPoint:CGPointMake(trianglePosition, height)];

    [openMenuShape setPath:triangleShape.CGPath];

    // So as to match the Navbar Colours after Apple's meddling with the barTintColor
    switch ([self.feedType intValue]) {
        case TNTypeDesignerNews:
            [openMenuShape setFillColor:[UIColor colorWithRed:0.310 green:0.533 blue:0.863 alpha:1].CGColor];
            break;

        case TNTypeHackerNews:
            [openMenuShape setFillColor:[UIColor colorWithRed:0.992 green:0.486 blue:0.208 alpha:1].CGColor];
            break;

        default:
            break;
    }

    [openMenuShape setBounds:CGRectMake(0.0f, 0.0f, height+triangleSize, width)];
    [openMenuShape setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [openMenuShape setPosition:CGPointMake(0.0f, 0.0f)];
}

- (void)exitMenuOnTapRecognizer:(UITapGestureRecognizer *)recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.view];
    //NSLog(@"Tap location X:%1.0f, Y:%1.0f", tapLocation.x, tapLocation.y);

    // If menu is open, and the tap is outside of the menu, close it.
    if (!CGRectContainsPoint(self.menu.frame, tapLocation) && !self.menu.hidden) {
        [self hideMenu];
    }
}

- (void)fadeOutChildViewController {

    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.currentViewController.view setAlpha:0.0f];
                     }
                     completion:nil];
}

@end
