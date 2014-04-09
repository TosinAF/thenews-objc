//
//  TNLoginViewController.m
//  The News
//
//  Created by Tosin Afolabi on 05/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "libHN.h"
#import "TNTextField.h"
#import "TNNotification.h"
#import "TNHomeViewController.h"
#import "DesignerNewsAPIClient.h"
#import "TNLoginViewController.h"

TNType currentAuthType;

@interface TNLoginViewController ()

@property (nonatomic) UIButton *addDN;
@property (nonatomic) UIButton *addHN;

@end

@implementation TNLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentAuthType = TNTypeDesignerNews;
    [self.view setBackgroundColor:[UIColor whiteColor]];

    CGSize screenSize = self.view.bounds.size;

    [self setTitle:@"Log In"];
    [[UINavigationBar appearance] setBarTintColor:[UIColor tnColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0f],
                                                            NSForegroundColorAttributeName:[UIColor whiteColor]}];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushHomeView)];

    [[self navigationItem] setRightBarButtonItem:rightItem];



    // Setup Text Fields & Borders

    self.emailField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 70, screenSize.width, 50)];
    [self.emailField setDelegate:self];
    [self.emailField setPlaceholder:@"Email"];
    [self.emailField setTag:0];
    [self.emailField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

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

        UIButton *addDN = [UIButton buttonWithType:UIButtonTypeCustom];
        [addDN setFrame:CGRectMake(20, 210, screenSize.width  - 40, 50)];
        [addDN setTitle:@"Enter DN Credentials" forState:UIControlStateNormal];
        [addDN setTitleColor:[UIColor dnColor] forState:UIControlStateNormal];

        [[addDN titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[addDN titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        [[addDN layer] setBorderColor:[[UIColor dnColor] CGColor]];
        [[addDN layer] setBorderWidth:1.0f];


        [addDN setBackgroundImage:[self imageWithColor:[UIColor dnColor]] forState:UIControlStateSelected];
        [addDN setTitle:@"DN Account Added" forState:UIControlStateSelected];
        [addDN setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [addDN addTarget:self action:@selector(dnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        addDN;
    });

    self.addHN = ({
        UIButton *addHN = [UIButton buttonWithType:UIButtonTypeCustom];
        [addHN setFrame:CGRectMake(20, 280, screenSize.width - 40, 50)];
        [addHN setTitle:@"Add HN Account" forState:UIControlStateNormal];
        [addHN setTitleColor:[UIColor hnColor] forState:UIControlStateNormal];

        [[addHN titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[addHN titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:14]];
        [[addHN layer] setBorderColor:[[UIColor hnColor] CGColor]];
        [[addHN layer] setBorderWidth:1.0f];


        [addHN setBackgroundImage:[self imageWithColor:[UIColor hnColor]] forState:UIControlStateSelected];
        [addHN setTitle:@"HN Account Added" forState:UIControlStateSelected];
        [addHN setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [addHN addTarget:self action:@selector(hnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        addHN;
    });

    [self.view addSubview:self.emailField];
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
    currentAuthType = TNTypeDesignerNews;
    [self.addDN setTitle:@"Enter DN Credentials" forState:UIControlStateNormal];
    [self.addHN setTitle:@"Add HN Account" forState:UIControlStateNormal];
    [self.emailField becomeFirstResponder];
}

- (void)hnButtonClicked
{
    currentAuthType = TNTypeHackerNews;
    [self.addHN setTitle:@"Enter HN Credentials" forState:UIControlStateNormal];
    [self.addDN setTitle:@"Add DN Account" forState:UIControlStateNormal];
    [self.emailField becomeFirstResponder];
}

#pragma mark - Network Methods

- (void)dnLogin
{
    DesignerNewsAPIClient *DNClient = [DesignerNewsAPIClient sharedClient];

    [DNClient authenticateUser:self.emailField.text password:self.passwordField.text success:^(NSString *accessToken) {

        [self.addDN setSelected:YES];
        [self.addDN setUserInteractionEnabled:NO];

        if ([self userCompletedLoginForBoth]) {
             [self performSelector:@selector(pushHomeView) withObject:nil afterDelay:0.5];
        } else {
            // click other button automatically
            [self hnButtonClicked];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self showAuthenticationError];

    }];
}

- (void)hnLogin
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[HNManager sharedManager] loginWithUsername:self.emailField.text password:self.passwordField.text completion:^(HNUser *user){

        if (user) {

            [self.addHN setSelected:YES];
            [self.addHN setUserInteractionEnabled:NO];


            if ([self userCompletedLoginForBoth]) {
                // add delay
                [self performSelector:@selector(pushHomeView) withObject:nil afterDelay:0.4];
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

- (BOOL)userCompletedLoginForBoth
{
    return [[HNManager sharedManager] userIsLoggedIn] && [[DesignerNewsAPIClient sharedClient] isUserAuthenticated];
}

- (void)showAuthenticationError
{
    TNNotification *error = [[TNNotification alloc] init];
    [error showFailureNotification:@"Username or Password is Incorrect." subtitle:nil];
}

@end
