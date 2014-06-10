//
//  TNContainerViewController.m
//  The News
//
//  Created by Tosin Afolabi on 11/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <POP/POP.h>
#import "TNMenuView.h"
#import "DNFeedViewController.h"
#import "HNFeedViewController.h"
#import "TNContainerViewController.h"

UITapGestureRecognizer *exitMenuTap;
UIPanGestureRecognizer *exitMenuPan;
UIImageView *navBarHairlineImageView;

@interface TNContainerViewController () <UIViewControllerTransitioningDelegate, POPAnimationDelegate>

@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) UIColor *navbarColor;
@property (nonatomic, strong) CAShapeLayer *openMenuShape;

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

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self defaultNavbarOptions];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self drawOpenMenuShape];

}

- (void)viewWillDisappear:(BOOL)animated
{
    if (![self.menu isHidden]) {
        [self hideMenu];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavbarApperance];
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

- (void)configureNavbarApperance
{
    CGFloat navBarHeight = 64.0;
	CGSize screenSize = self.view.frame.size;

	self.navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, navBarHeight)];
	self.navItem = [[UINavigationItem alloc] initWithTitle:self.navTitle];
    [self.navBar setTranslucent:YES];

    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navBar];
    navBarHairlineImageView.hidden = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navBarTapped)];
    [self.navBar addGestureRecognizer:tap];

    [self defaultNavbarOptions];

    self.menuButton = ({
        UIImage *menuOpenImage = [UIImage imageNamed:@"menuOpen"];
        UIImage *menuClosedImage = [UIImage imageNamed:@"menuClosed"];
        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setImage:menuClosedImage forState:UIControlStateNormal];;
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

- (void)navBarTapped
{
    NSAssert(NO, @"Subclasses need to overwrite this method");
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
    [[[self view] layer] addSublayer:self.openMenuShape];
    [self.currentViewController.view setUserInteractionEnabled:NO];

    // Set new origin of menu
    CGRect menuFrame = self.menu.frame;
    menuFrame.origin.y = self.navBar.frame.size.height;
    CGRect containerFrame = self.currentViewController.view.frame;
    containerFrame.origin.y = self.navBar.frame.size.height + 208 - 64;

    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.delegate = self;
    anim.springBounciness = 10;
    anim.springSpeed = 10;
    anim.toValue = [NSValue valueWithCGRect:menuFrame];

    POPSpringAnimation *anim2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.delegate = self;
    anim2.springBounciness = 10;
    anim2.springSpeed = 10;
    anim2.toValue = [NSValue valueWithCGRect:containerFrame];

    POPBasicAnimation *anim3 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim3.fromValue = @(1.0);
    anim3.toValue = @(containerAlpha);

    [self.menu pop_addAnimation:anim forKey:@"frame"];
    [self.currentViewController.view pop_addAnimation:anim2 forKey:@"frame"];
    [self.currentViewController.view pop_addAnimation:anim3 forKey:@"alpha"];
    [self.menuButton setEnabled:NO];
}

- (void)hideMenu {

    float containerAlpha = 1.0f;
    [self.menuButton setSelected:NO];
    [self.openMenuShape removeFromSuperlayer];
    [self.view removeGestureRecognizer:exitMenuTap];
    [self.view removeGestureRecognizer:exitMenuPan];
    [self.menu toDefaultState];
    [self.menuButton setEnabled:NO];

    // Set new origin of Menu & Contianer
    CGRect menuFrame = self.menu.frame;
    CGRect containerFrame = self.currentViewController.view.frame;
    menuFrame.origin.y = self.navBar.frame.size.height-menuFrame.size.height;
    containerFrame.origin.y = 0.0f;

    [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:5.0 initialSpringVelocity:10.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.menu setFrame:menuFrame];
                         [self.currentViewController.view setFrame:containerFrame];
                         [self.currentViewController.view setAlpha: containerAlpha];
                     }
                     completion:^(BOOL finished){
                         self.menu.hidden = YES;
                         [self.menu pop_removeAllAnimations];
                         [self.currentViewController pop_removeAllAnimations];
                         [self.currentViewController.view setUserInteractionEnabled:YES];
                         [self.menuButton setEnabled:YES];
                     }];

    [UIView commitAnimations];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    // ensure animations are done, then add gesture recognizers
    exitMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitMenuOnTapRecognizer:)];
    exitMenuPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(exitMenuOnPanRecognizer:)];
    [self.menuButton setEnabled:YES];

    [self.view addGestureRecognizer:exitMenuTap];
    [self.view addGestureRecognizer:exitMenuPan];

}

- (void)drawOpenMenuShape {

    self.openMenuShape = [CAShapeLayer layer];

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

    [self.openMenuShape setPath:triangleShape.CGPath];

    // So as to match the Navbar Colours after Apple's meddling with the barTintColor
    switch ([self.feedType intValue]) {
        case TNTypeDesignerNews:
            [self.openMenuShape setFillColor:[UIColor dnNavBarColor].CGColor];
            break;

        case TNTypeHackerNews:
            [self.openMenuShape setFillColor:[UIColor hnNavBarColor].CGColor];
            break;

        default:
            break;
    }

    [self.openMenuShape setBounds:CGRectMake(0.0f, 0.0f, height+triangleSize, width)];
    [self.openMenuShape setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [self.openMenuShape setPosition:CGPointMake(0.0f, 0.0f)];
}

- (void)exitMenuOnTapRecognizer:(UITapGestureRecognizer *)recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.view];

    // If menu is open, and the tap is outside of the menu, close it.
    if (!CGRectContainsPoint(self.menu.frame, tapLocation) && !self.menu.hidden) {
        [self hideMenu];
    }
}

- (void)exitMenuOnPanRecognizer:(UIPanGestureRecognizer *)recognizer
{
    // Get the translation in the view
    [recognizer setTranslation:CGPointZero inView:recognizer.view];

    // But also, detect the swipe gesture
    if (recognizer.state == UIGestureRecognizerStateEnded) {

        CGPoint vel = [recognizer velocityInView:recognizer.view];

        if (vel.y < -1000.0f) {
            [self hideMenu];
        }
    }
}

- (void)fadeOutChildViewController {

    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.currentViewController.view setAlpha:0.0f];
                     }
                     completion:nil];
}


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

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
@end
