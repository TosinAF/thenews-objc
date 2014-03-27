//
//  TNPostViewController.m
//  thenews
//
//  Created by Tosin Afolabi on 19/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "IonIcons.h"
#import "ionicons-codes.h"
#import "GTScrollNavigationBar.h"
#import "TNPostViewController.h"
#import "OvershareKit.h"

#import "FBShimmering.h"
#import "FBShimmeringView.h"
#import "FBShimmeringLayer.h"


NSString *loadingText = @"Loading...";
DismissActionBlock dismissAction;

@interface TNPostViewController ()

typedef NS_ENUM (NSInteger, TNToolBarButtonType) {
	TNToolBarButtonTypeBack,
	TNToolBarButtonTypeForward,
    TNToolBarButtonTypeSpacer
};

@property (strong, nonatomic) UIColor *themeColor;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIBarButtonItem *shareButton;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) FBShimmeringView *navBarTitleView;

@end

@implementation TNPostViewController

- (id)initWithURL:(NSURL *)url type:(TNType)type
{
    self = [super init];

    if (self) {
        self.url = url;
        self.titleStr = loadingText;

        switch (type) {
			case TNTypeDesignerNews:
				self.themeColor = [UIColor dnColor];
				break;

			case TNTypeHackerNews:
				self.themeColor = [UIColor hnColor];
				break;
		}
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES];
    self.navigationController.scrollNavigationBar.scrollView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /* Set up Navigation Bar */

    [self configureTitleView];
    [self addBarButtonItems];

	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:self.themeColor];

    /* Set Up Web View */

    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.webView setScalesPageToFit:YES];
    [self.view addSubview:self.webView];

    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // Ignore First Page Load
    if (navigationType != UIWebViewNavigationTypeOther) {

        if ( [self.navigationController isToolbarHidden] ) {

            [self.navigationController setToolbarHidden:NO animated:YES];
            [self configureToolbar];
        }

        [self.titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:16.0f]];
        [self.titleLabel setText:@"Loading..."];
        [self.navBarTitleView setShimmering:YES];
        [self updateToolbarButtonState];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPosition:NO];
    [self updateToolbarButtonState];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    /* Set Title View of Navigation Bar With Current Page Details */
    self.titleStr = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self.navBarTitleView setShimmering:NO];

    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFromBottom;
    animation.duration = 1.0f;

    [self.titleLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];

    // Need to delay to allow shimmering to stop
    [self performSelector:@selector(updateTitleLabel) withObject:nil afterDelay:0.5f];
    [self updateToolbarButtonState];

    self.navigationController.scrollNavigationBar.scrollView = self.webView.scrollView;
}

- (void)updateTitleLabel
{
    // Default Font Size When not a Lodaing Indicator
    [self.titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:13.0f]];

    if ([self.titleStr length] > 30 ) {
        [self.titleLabel setAdjustsFontSizeToFitWidth:NO];
    } else {
        [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    }

    [self.titleLabel setText:self.titleStr];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPosition:NO];
}

#pragma mark - Private Methods

- (void)configureTitleView {

    /*
     * Splits the Original Title View into a Title & Subtitle View
     */

    self.navBarTitleView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    //[self.navBarTitleView setBackgroundColor:[UIColor clearColor]];

    self.titleLabel = ({
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 200, 44)];
        [titleLabel setText:self.titleStr];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:16.0f]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setNumberOfLines:2];
        [titleLabel setAdjustsFontSizeToFitWidth:YES];
        titleLabel;
    });

    self.navBarTitleView.contentView = self.titleLabel;
    self.navBarTitleView.shimmering = YES;
    self.navigationItem.titleView = self.navBarTitleView;
}

- (void)addBarButtonItems
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 30)];

    self.shareButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.rightBarButtonItem = self.shareButton;
}

- (void)shareAction
{
    OSKShareableContent *content = [OSKShareableContent contentFromMicroblogPost:self.titleLabel.text authorName:@"thenews" canonicalURL:self.url.absoluteString images:nil];
    
    [[OSKPresentationManager sharedInstance] presentActivitySheetForContent:content presentingViewController:self options:nil];

}
#pragma mark - Toolbar Methods

// Can be Refactored into its own view

- (void)configureToolbar
{
    CGFloat negativeSpacerWidth = -5;
    CGFloat positiveSpaceWidth = 25;

    /* Negative Spacer */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = negativeSpacerWidth;

    /* Positive Spacer */
    UIBarButtonItem *positiveSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    positiveSpacer.width = positiveSpaceWidth;

    /* Back Button */
    self.backButton = [self createToolbarNavButton:TNToolBarButtonTypeBack];
    UIBarButtonItem *backButtonBarItem =[[UIBarButtonItem alloc] initWithCustomView:self.backButton];

    /* Forward Button */
    self.forwardButton = [self createToolbarNavButton:TNToolBarButtonTypeForward];
    UIBarButtonItem *forwardButtonBarItem =[[UIBarButtonItem alloc] initWithCustomView:self.forwardButton];

    NSArray *items = @[negativeSpacer, backButtonBarItem, positiveSpacer, forwardButtonBarItem];
    [self.navigationController.toolbar setItems:items animated:NO];
}

- (UIButton *)createToolbarNavButton:(TNToolBarButtonType)buttonType
{
    NSString *iconString = [[NSString alloc] init];
    UIColor *darkGray = [UIColor colorWithRed:0.529 green:0.596 blue:0.643 alpha:1];
    UIColor *lightGray = [UIColor colorWithRed:0.816 green:0.839 blue:0.855 alpha:1];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 23, 23)];

    switch (buttonType) {

        case TNToolBarButtonTypeBack:
            iconString = icon_ios7_arrow_left;
            [button addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            break;

        case TNToolBarButtonTypeForward:
            iconString = icon_ios7_arrow_right;
            [button addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
            break;

        default:
            break;
    }

    UIImage *icon = [IonIcons imageWithIcon:iconString size:25.0f color:darkGray];
    [button setImage:icon forState:UIControlStateNormal];

    UIImage *iconDisabled = [IonIcons imageWithIcon:iconString size:25.0f color:lightGray];
    [button setImage:iconDisabled forState:UIControlStateDisabled];

    return button;
}

- (void)updateToolbarButtonState
{
    // Called in all three delegate methods to avoid bug
    // where after first link is clicked, backButton is still disabled
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}

- (void)dismissButtonPressed {
    dismissAction();
}

- (void)setDismissAction:(DismissActionBlock)dismissActionBlock {
    dismissAction = dismissActionBlock;
}


@end
