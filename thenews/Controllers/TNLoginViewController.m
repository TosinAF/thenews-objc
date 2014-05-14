//
//  TNLoginViewController.m
//  The News
//
//  Created by Tosin Afolabi on 05/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "libHN.h"
#import "DNManager.h"
#import "TNButton.h"
#import "TNTextField.h"
#import "TNNotification.h"
#import "TNHomeViewController.h"
#import "TNLoginViewController.h"

TNType currentAuthType;

@interface TNLoginViewController ()

@property (nonatomic) TNButton *addDN;
@property (nonatomic) TNButton *addHN;

@end

@implementation TNLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScreenName:@"Log In"];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    currentAuthType = TNTypeDesignerNews;
    [[TNTextField appearance] setTintColor:[UIColor dnColor]];

    CGSize screenSize = self.view.bounds.size;

    [self setTitle:@"Login"];
    [[UINavigationBar appearance] setBarTintColor:[UIColor tnColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:18.0f],
                                                            NSForegroundColorAttributeName:[UIColor whiteColor]}];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"The News" style:UIBarButtonItemStylePlain target:self action:@selector(pushHomeView)];

    [[self navigationItem] setRightBarButtonItem:rightItem];

    // Setup Text Fields & Borders

    self.usernameField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 70, screenSize.width, 50)];
    [self.usernameField setDelegate:self];
    [self.usernameField setPlaceholder:@"Email"];
    [self.usernameField setTag:0];
    [self.usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    self.passwordField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 130, screenSize.width, 50)];
    [self.passwordField setDelegate:self];
    [self.passwordField setPlaceholder:@"Password"];
    [self.passwordField setReturnKeyType:UIReturnKeyDone];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setTag:1];
    [self.passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    // Add borders

    for (int i = 0; i < 2; i++) {

        int yPos = 120 + (i * 60);

        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, self.view.bounds.size.width, 2)];
        [border setBackgroundColor:[UIColor tnLightGreyColor]];

        [self.view addSubview:border];
    }

    // Log In Buttons

    self.addDN = ({

        TNButton *addDN = [[TNButton alloc] initWithFrame:CGRectMake(20, 210, screenSize.width  - 40, 50)];
        [addDN setBackgroundImageWithNormalColor:[UIColor whiteColor] highlightColor:[UIColor dnColor]];
        [addDN removeHighlightBackgroundImage];

        [addDN setTitle:@"Login" forState:UIControlStateNormal];
        [addDN setTitleColor:[UIColor dnColor] forState:UIControlStateNormal | UIControlStateHighlighted];


        [[addDN titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:18]];
        [[addDN layer] setBorderWidth:1.0f];

        [addDN setTitle:@"DN Account Added" forState:UIControlStateSelected];
        [addDN setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [addDN addTarget:self action:@selector(dnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        addDN;
    });

    self.addHN = ({

        TNButton *addHN = [[TNButton alloc] initWithFrame:CGRectMake(20, 280, screenSize.width  - 40, 50)];
        [addHN setBackgroundImageWithNormalColor:[UIColor whiteColor] highlightColor:[UIColor hnColor]];
        [addHN removeHighlightBackgroundImage];

        [addHN setTitle:@"Add HN Account" forState:UIControlStateNormal];
        [addHN setTitleColor:[UIColor hnColor] forState:UIControlStateNormal | UIControlStateHighlighted];

        [[addHN titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:18]];
        [[addHN layer] setBorderWidth:1.0f];

        [addHN setTitle:@"HN Account Added" forState:UIControlStateSelected];
        [addHN setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [addHN addTarget:self action:@selector(hnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        addHN;
    });

    if (!(self.view.frame.size.height == 568)) {

        // fix positioning for 3.5 inch devices

        [self.addDN setFrame:CGRectMake(10, 200, screenSize.width / 2 - 15, 50)];
        [self.addDN setBackgroundImageWithNormalColor:[UIColor whiteColor] highlightColor:[UIColor dnColor]];
        [[self.addDN titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];

        [self.addHN setFrame:CGRectMake(165, 200, screenSize.width / 2 - 15, 50)];
        [self.addHN setBackgroundImageWithNormalColor:[UIColor whiteColor] highlightColor:[UIColor hnColor]];
        [[self.addHN titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
    }

    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.addDN];
    [self.view addSubview:self.addHN];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSUInteger tag = [textField tag];

    switch (tag) {

        case 0:
            [self.passwordField becomeFirstResponder];
            break;

        case 1:
            if (currentAuthType == TNTypeDesignerNews) {
                [self dnLogin];
            } else {
                [self hnLogin];
            }
            break;
    }
    
    return NO;
}

#pragma mark - Button Actions

- (void)dnButtonClicked
{
    if ( (currentAuthType == TNTypeDesignerNews) && [self textFieldsAreFilled] ) {

        [self dnLogin];

    } else {

        currentAuthType = TNTypeDesignerNews;
        [self changeCaretColor:TNTypeDesignerNews];
        [self.addDN setTitle:@"Login" forState:UIControlStateNormal];
        [self.addHN setTitle:@"Add HN Account" forState:UIControlStateNormal];
        [self.usernameField becomeFirstResponder];
    }
}

- (void)hnButtonClicked
{
    if ( (currentAuthType == TNTypeHackerNews) && [self textFieldsAreFilled] ) {

        [self hnLogin];

    } else {

        currentAuthType = TNTypeHackerNews;
        [self changeCaretColor:TNTypeHackerNews];
        [self.addHN setTitle:@"Login" forState:UIControlStateNormal];
        [self.addDN setTitle:@"Add DN Account" forState:UIControlStateNormal];
        [self.usernameField becomeFirstResponder];
    }
}

#pragma mark - Network Methods

- (void)dnLogin
{
    DNManager *DNClient = [DNManager sharedManager];

    [DNClient authenticateUser:self.usernameField.text password:self.passwordField.text success:^(NSString *accessToken) {

        [self.addDN setSelected:YES];
        [self.addDN setUserInteractionEnabled:NO];

        if ([self userCompletedLoginForBoth]) {
             [self performSelector:@selector(pushHomeView) withObject:nil afterDelay:0.5];
        } else {
            [self hnButtonClicked];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self showAuthenticationError];

    }];
}

- (void)hnLogin
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [[HNManager sharedManager] loginWithUsername:self.usernameField.text password:self.passwordField.text completion:^(HNUser *user){

        if (user) {

            [self.addHN setSelected:YES];
            [self.addHN setUserInteractionEnabled:NO];


            if ([self userCompletedLoginForBoth]) {
                // add delay
                [self performSelector:@selector(pushHomeView) withObject:nil afterDelay:0.5];
            } else {
                // click other button automatically
                [self dnButtonClicked];
            }

        } else {

            [self showAuthenticationError];
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

#pragma mark - Private Methods

- (UIImage *)imageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)changeCaretColor:(TNType)type
{
    // change caret color of textfields

    switch (type) {
        case TNTypeDesignerNews:
            [self.usernameField setTintColor:[UIColor dnColor]];
            [self.passwordField setTintColor:[UIColor dnColor]];
            break;

        case TNTypeHackerNews:
            [self.usernameField setTintColor:[UIColor hnColor]];
            [self.passwordField setTintColor:[UIColor hnColor]];
            break;
    }

}

- (BOOL)userCompletedLoginForBoth
{
    return [[HNManager sharedManager] userIsLoggedIn] && [[DNManager sharedManager] isUserAuthenticated];
}

- (BOOL)textFieldsAreFilled
{
    return ( [self.usernameField.text length] != 0 && [self.passwordField.text length] != 0 );
}

- (void)showAuthenticationError
{
    TNNotification *error = [[TNNotification alloc] init];
    [error showFailureNotification:@"Username or Password is Incorrect." subtitle:nil];
}

@end
