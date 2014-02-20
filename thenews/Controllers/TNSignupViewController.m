//
//  TNSignupViewController.m
//  The News
//
//  Created by Tosin Afolabi on 04/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTextField.h"
#import "UIColor+TNColors.h"
#import "TNTextFieldTypeEnum.h"
#import "TNSignupViewController.h"
#import "TNLoginViewController.h"
#import "TNHomeViewController.h"

bool validNameField;
bool validEmailField;
bool validPasswordField;
int passwordLength = 6;

static NSString *networkErrorMessage = @"There is no network connection";
static NSString *invalidFieldErrorMessage = @"Please correct the indicated errors.";

@interface TNSignupViewController ()

@property (strong, nonatomic) TNTextField *nameField;
@property (strong, nonatomic) TNTextField *emailField;
@property (strong, nonatomic) TNTextField *passwordField;

@property (strong, nonatomic) UILabel *errorLabel;

@end

@implementation TNSignupViewController

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

    CGSize screenSize = self.view.bounds.size;

    [self setTitle:@"Sign Up"];
    [[UINavigationBar appearance] setBarTintColor:[UIColor hnColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0f],
                                                            NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Setup Text Fields & Borders

    self.nameField = ({
        TNTextField *nameField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 70, screenSize.width, 50)];
        [nameField setDelegate:self];
        [nameField setPlaceholder:@"Name"];
        [nameField setTag:TNTextFieldTypeName];
        nameField;
    });

    self.emailField = ({
        TNTextField *emailField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 130, screenSize.width, 50)];
        [emailField setDelegate:self];
        [emailField setPlaceholder:@"Email"];
        [emailField setTag:TNTextFieldTypeEmail];
        emailField;
    });

    self.passwordField = ({
        TNTextField *passwordField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 190, screenSize.width, 50)];
        [passwordField setDelegate:self];
        [passwordField setPlaceholder:@"Password"];
        [passwordField setReturnKeyType:UIReturnKeyDone];
        [passwordField setSecureTextEntry:YES];
        [passwordField setTag:TNTextFieldTypePassword];
        passwordField;
    });

    // Add borders
    
    for (int i = 0; i < 3; i++) {

        int yPos = 120 + (i * 60);

        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, self.view.bounds.size.width, 2)];
        [border setBackgroundColor:[UIColor tnLightGreyColor]];

        [self.view addSubview:border];
    }

    // Button to go to Login View Instead

    UIButton *gotoLoginView = [[UIButton alloc] init];
    [gotoLoginView setFrame:CGRectMake(0, 260, screenSize.width, 50)];
    [gotoLoginView setTitle:@"ALREADY A USER?" forState:UIControlStateNormal];
    [gotoLoginView setTitleColor:[UIColor hnColor] forState:UIControlStateNormal];
    [gotoLoginView setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [[gotoLoginView titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.0f]];
    [gotoLoginView  addTarget:self action:@selector(gotoLoginView:) forControlEvents:UIControlEventTouchUpInside];

    self.errorLabel = ({
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 270, screenSize.width, 100)];
        [errorLabel setText:invalidFieldErrorMessage];
        [errorLabel setTextColor:[UIColor redColor]];
        [errorLabel setTextAlignment:NSTextAlignmentCenter];
        [errorLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:16.5f]];
        errorLabel;
    });

    [self.view addSubview:gotoLoginView];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.emailField];
    [self.view addSubview:self.passwordField];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(TNTextField *)textField
{
    NSUInteger tag = [textField tag];

    switch (tag) {

        case TNTextFieldTypeName:
            [self.emailField becomeFirstResponder];
            break;

        case TNTextFieldTypeEmail:
            [self.passwordField becomeFirstResponder];
            break;

        case TNTextFieldTypePassword:

            [self checkAllFields];

            if (validNameField && validEmailField && validPasswordField) {
                [self pushHomeView];
            } else {
                [self.view addSubview:self.errorLabel];
                [self fadeInAnimation:self.view];
            }
            break;
    }

    return NO;
}

- (void)textFieldDidBeginEditing:(TNTextField *)textField
{
    if (![self.errorLabel isHidden]) {
        [self.errorLabel removeFromSuperview];
    }
    UIColor *defaultColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1];
    [textField setPlaceholderColor:defaultColor];
    [textField setTextColor:[UIColor blackColor]];
}

- (void)textFieldDidEndEditing:(TNTextField *)textField
{
    [self checkField:textField];
}

#pragma mark - Private Methods

- (void)checkField:(TNTextField *)textField
{
    NSUInteger tag = [textField tag];
    NSUInteger inputLength = [[textField text] length];

    switch (tag) {

    case TNTextFieldTypeName:
        if  (inputLength == 0) {
            [textField setPlaceholderColor:[UIColor redColor]];
            validNameField = NO;
        } else {
            validNameField = YES;
        }
        break;

    case TNTextFieldTypeEmail:
        if (![self validateEmail:[textField text]] || inputLength == 0) {
            [textField setTextColor:[UIColor redColor]];
            [textField setPlaceholderColor:[UIColor redColor]];
            validEmailField = NO;
        } else {
            [self resetTextField:self.emailField];
            validEmailField = YES;
        }
        break;

    case TNTextFieldTypePassword:
        if (inputLength < passwordLength) {
            [textField setTextColor:[UIColor redColor]];
            [textField setPlaceholderColor:[UIColor redColor]];
            validPasswordField = NO;
        } else {
            [self resetTextField:self.passwordField];
            validPasswordField = YES;
        }
        break;
    }
}

- (void)checkAllFields
{
    [self checkField:self.nameField];
    [self checkField:self.emailField];
    [self checkField:self.passwordField];
}

- (void)resetTextField:(TNTextField *)textField
{
    UIColor *defaultColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1];
    [textField setPlaceholderColor:defaultColor];
    [textField setTextColor:[UIColor blackColor]];
}

- (void)gotoLoginView:(id)selector
{
    int viewControllersInStack = [self.navigationController.viewControllers count];
    TNLoginViewController *loginViewController;

    if ( viewControllersInStack <= 2 ) {

        loginViewController = [[TNLoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];

    } else {

        // Prevent loop of Signup & Login View Controllers
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];

        for (id vc in viewControllers) {
            if ([vc isMemberOfClass:[TNLoginViewController class]]) {
                loginViewController = vc;
                [viewControllers removeObject:vc];
                break;
            }
        }

        [self.navigationController setViewControllers:viewControllers];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (void)pushHomeView
{
    TNHomeViewController *homeViewController = [[TNHomeViewController alloc] init];
    [self.navigationController pushViewController:homeViewController animated:YES];
}

- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [regexPredicate evaluateWithObject:email];
}

-(void)fadeInAnimation:(UIView *)aView
{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.5f;
    transition.delegate = self;
    [aView.layer addAnimation:transition forKey:@"kCATransitionFade"];
}

@end