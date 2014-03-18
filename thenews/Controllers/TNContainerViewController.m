//
//  TNContainerViewController.m
//  The News
//
//  Created by Tosin Afolabi on 11/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTypeEnum.h"
#import "TNMenuView.h"
#import "UIColor+TNColors.h"
#import "TNViewController.h"
#import "TNFeedViewController.h"
#import "TNContainerViewController.h"

CAShapeLayer *openMenuShape;
UITapGestureRecognizer *exitMenuTap;

__weak TNContainerViewController *weakSelf;

@interface TNContainerViewController ()

@property (nonatomic, strong) NSNumber *feedType;

@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) UIColor *navbarColor;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UINavigationItem *navItem;

@property (nonatomic, strong) TNMenuView *menu;
@property (nonatomic, strong) UIButton *menuButton;

@property (weak,nonatomic) UIViewController *currentViewController;

@end

@implementation TNContainerViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

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

    // Will refactor this
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeChildViewController:) name:@"menuButtonClicked" object:nil];

    /* Set Up Menu View */

    self.menu = [[TNMenuView alloc] initWithFrame:CGRectMake(0, -208, 320, 208) type:[self.feedType intValue]];
    [self.menu setHidden:YES];
    [self.menu setup];

    weakSelf = self;
    [self.menu setKeyboardWillAppearAction:^{
        [weakSelf fadeOutChildViewController];
    }];

    /* Set up First Child View Controller */

    TNFeedViewController *feedViewController = [[TNFeedViewController alloc] initWithType:[self.feedType intValue]];
    self.currentViewController = feedViewController;
    [self addChildViewController:feedViewController];
    [self.view addSubview:feedViewController.view];
    [feedViewController didMoveToParentViewController:self];

    [self.view addSubview:self.menu];
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

- (void)toggleMenu {
    if(self.menu.hidden) {
        [self showMenu];
        [self.menuButton setSelected:YES];
    } else {
        [self hideMenu];
    }
}

- (void)showMenu
{
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
                         [self.currentViewController.view setAlpha: containerAlpha];
                     }
                     completion:^(BOOL finished){
                     }];

    [UIView commitAnimations];
}

- (void)hideMenu
{
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
            [openMenuShape setFillColor:[UIColor colorWithRed:0.416 green:0.565 blue:0.824 alpha:1].CGColor];
            break;

        case TNTypeHackerNews:
            [openMenuShape setFillColor:[UIColor colorWithRed:0.451 green:0.769 blue:0.675 alpha:1].CGColor];
            break;

        default:
            break;
    }

    [openMenuShape setBounds:CGRectMake(0.0f, 0.0f, height+triangleSize, width)];
    [openMenuShape setAnchorPoint:CGPointMake(0.0f, 0.0f)];
    [openMenuShape setPosition:CGPointMake(0.0f, 0.0f)];
}

- (void)exitMenuOnTapRecognizer:(UITapGestureRecognizer *)recognizer
{
    // Get the location of the gesture
    CGPoint tapLocation = [recognizer locationInView:self.view];
    //NSLog(@"Tap location X:%1.0f, Y:%1.0f", tapLocation.x, tapLocation.y);

    // If menu is open, and the tap is outside of the menu, close it.
    if (!CGRectContainsPoint(self.menu.frame, tapLocation) && !self.menu.hidden) {
        [self hideMenu];
    }
}

- (void)fadeOutChildViewController
{

    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [weakSelf.currentViewController.view setAlpha:0.0f];
                     }
                     completion:nil];
}

- (void)changeChildViewController:(NSNotification *)notification
{

    NSNumber *identifier = [[notification userInfo] valueForKey:@"type"];

    if ( [identifier isEqualToNumber:self.feedType]) {
        NSLog(@"yeah");
    }


    TNViewController *nextViewController = [[TNViewController alloc] init];
    // Add nextViewController as child of container view controller.
    [self addChildViewController:nextViewController];
    // Tell current View controller that it will be removed.
    [self willMoveToParentViewController:nil];

    // Set the frame of the next view controller to equal the outgoing (current) view controller
    nextViewController.view.frame = self.currentViewController.view.frame;

    // Make the transition with a very short Cross disolve animation
    [self transitionFromViewController:self.currentViewController
                                         toViewController:nextViewController
                                                 duration:0.1f
                                                  options:UIViewAnimationOptionTransitionCrossDissolve
                                               animations:^{

                                               }
                                               completion:^(BOOL finished) {
                                                   self.currentViewController = nextViewController;
                                                   [self.currentViewController removeFromParentViewController];
                                                   [self hideMenu];
                                                   [nextViewController didMoveToParentViewController:self];
                                               }];

}

@end
