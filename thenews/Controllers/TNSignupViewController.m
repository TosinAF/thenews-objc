//
//  TNSignupViewController.m
//  The News
//
//  Created by Tosin Afolabi on 04/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTextField.h"
#import "UIColor+TNColors.h"
#import "TNSignupViewController.h"
#import "TNLoginViewController.h"

@interface TNSignupViewController ()

@property (strong, nonatomic) TNTextField *nameField;
@property (strong, nonatomic) TNTextField *emailField;
@property (strong, nonatomic) TNTextField *passwordField;

@end

@implementation TNSignupViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO];
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
        [nameField setTag:0];
        nameField;
    });

    self.emailField = ({
        TNTextField *emailField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 130, screenSize.width, 50)];
        [emailField setDelegate:self];
        [emailField setPlaceholder:@"Email"];
        [emailField setTag:1];
        emailField;
    });

    self.passwordField = ({
        TNTextField *passwordField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 190, screenSize.width, 50)];
        [passwordField setDelegate:self];
        [passwordField setPlaceholder:@"Password"];
        [passwordField setReturnKeyType:UIReturnKeyDone];
        [passwordField setSecureTextEntry:YES];
        [passwordField setTag:2];
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

        case 0:
            [self.emailField becomeFirstResponder];
            break;

        case 1:
            [self.passwordField becomeFirstResponder];
            break;

        case 2:
            // push new view to nav stack
            break;
    }

    return NO;
}

- (void)textFieldDidBeginEditing:(TNTextField *)textField
{
    UIColor *defaultColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1];
    [textField setPlaceholderColor:defaultColor];
    [textField setTextColor:[UIColor blackColor]];
}

- (void)textFieldDidEndEditing:(TNTextField *)textField
{
    NSUInteger tag = [textField tag];
    NSUInteger inputLength = [[textField text] length];

    if (inputLength == 0) {
        [textField setPlaceholderColor:[UIColor redColor]];
    }

    if (tag == 1 && ![self validateEmail:[textField text]]  ) {
        [textField setTextColor:[UIColor redColor]];
    } else {
        [textField setTextColor:[UIColor blackColor]];
    }
}

#pragma mark - Private Methods

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

- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [regexPredicate evaluateWithObject:email];
}

@end