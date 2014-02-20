//
//  TNLoginViewController.m
//  The News
//
//  Created by Tosin Afolabi on 05/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTextField.h"
#import "UIColor+TNColors.h"
#import "TNSignupViewController.h"
#import "TNLoginViewController.h"
#import "TNHomeViewController.h"
#import "TNTextFieldTypeEnum.h"

bool validEmailField;
bool validPasswordField;

static NSString *authErrorMessage = @"Your login credentials are invalid";
static NSString *networkErrorMessage = @"There is no network connection";
static NSString *invalidFieldErrorMessage = @"Please correct the indicated errors.";

@interface TNLoginViewController ()

@property (strong, nonatomic) TNTextField *emailField;
@property (strong, nonatomic) TNTextField *passwordField;
@property (strong, nonatomic) UILabel *errorLabel;

@end

@implementation TNLoginViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    CGSize screenSize = self.view.bounds.size;


    [self setTitle:@"Log In"];
    [[UINavigationBar appearance] setBarTintColor:[UIColor hnColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0f],
                                                            NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Setup Text Fields & Borders

    self.emailField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 70, screenSize.width, 50)];
    [self.emailField setDelegate:self];
    [self.emailField setPlaceholder:@"Email"];
    [self.emailField setTag:0];

    self.passwordField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 130, screenSize.width, 50)];
    [self.passwordField setDelegate:self];
    [self.passwordField setPlaceholder:@"Password"];
    [self.passwordField setReturnKeyType:UIReturnKeyDone];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setTag:1];

    // Add borders

    for (int i = 0; i < 2; i++) {

        int yPos = 120 + (i * 60);

        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, self.view.bounds.size.width, 2)];
        [border setBackgroundColor:[UIColor tnLightGreyColor]];

        [self.view addSubview:border];
    }

    // Button to go to Sign Up View Instead

    UIButton *gotoSignupView = [[UIButton alloc] init];
    [gotoSignupView setFrame:CGRectMake(95, 200, 130, 50)];
    [gotoSignupView setTitle:@"FORGOT YOUR PASSWORD?" forState:UIControlStateNormal];
    [gotoSignupView setTitleColor:[UIColor hnColor] forState:UIControlStateNormal];
    [gotoSignupView setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[gotoSignupView titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.0f]];
    [[gotoSignupView titleLabel] setNumberOfLines:3];
    [[gotoSignupView titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[gotoSignupView titleLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [gotoSignupView  addTarget:self action:@selector(gotoSignupView:) forControlEvents:UIControlEventTouchUpInside];

    // Error Label

    self.errorLabel = ({
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, screenSize.width, 100)];
        [errorLabel setText:invalidFieldErrorMessage];
        [errorLabel setTextColor:[UIColor redColor]];
        [errorLabel setTextAlignment:NSTextAlignmentCenter];
        [errorLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:16.5f]];
        errorLabel;
    });

    [self.view addSubview:gotoSignupView];
    [self.view addSubview:self.emailField];
    [self.view addSubview:self.passwordField];
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
            [self pushHomeView];
            break;
    }
    
    return NO;
}

#pragma mark - Private Methods

- (void)pushHomeView
{
    TNHomeViewController *homeViewController = [[TNHomeViewController alloc] init];
    [self.navigationController pushViewController:homeViewController animated:YES];
}

- (void)gotoSignupView:(id)selector
{
    int viewControllersInStack = [self.navigationController.viewControllers count];
    TNSignupViewController *signupViewController;

    if ( viewControllersInStack <= 2 ) {

        signupViewController = [[TNSignupViewController alloc] init];
        [self.navigationController pushViewController:signupViewController animated:YES];

    } else {

        // Prevent loop of Signup & Login View Controllers

        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];

        for (id vc in viewControllers) {
            if ([vc isMemberOfClass:[TNSignupViewController class]]) {
                signupViewController = vc;
                [viewControllers removeObject:vc];
                break;
            }
        }

        [self.navigationController setViewControllers:viewControllers];
        [self.navigationController pushViewController:signupViewController animated:YES];
    }
}

@end
