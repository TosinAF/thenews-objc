//
//  HNSettingsViewController.m
//  The News
//
//  Created by Tosin Afolabi on 09/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <POP/POP.h>
#import "libHN.h"
#import "TNButton.h"
#import "TNTextField.h"
#import "TNNotification.h"
#import "HNSettingsViewController.h"

@interface HNSettingsViewController () <UITextFieldDelegate>

@property (strong, nonatomic) TNTextField *usernameField;
@property (strong, nonatomic) TNTextField *passwordField;
@property (strong, nonatomic) UIView *border;
@property (strong, nonatomic) UIView *border2;

@property (nonatomic, strong) TNButton *button;

@end

@implementation HNSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScreenName:@"HNComments"];

    if ([[HNManager sharedManager] userIsLoggedIn]) {
        [self configureViewForLoggedInState];
    } else {
        [self configureViewForLoggedOutState];
    }

    self.button = ({

        TNButton *button;

        if ([[HNManager sharedManager] userIsLoggedIn]) {
            button = [[TNButton alloc] initWithFrame:CGRectMake(20, 270, 320  - 40, 50)];
            [button setTitle:@"Log Out" forState:UIControlStateNormal];
        } else {
            button = [[TNButton alloc] initWithFrame:CGRectMake(20, 210, 320  - 40, 50)];
            [button setTitle:@"Login" forState:UIControlStateNormal];
        }

        [button setBackgroundImageWithNormalColor:[UIColor whiteColor] highlightColor:[UIColor hnNavBarColor]];
        [button removeHighlightBackgroundImage];

        [button setTitleColor:[UIColor dnColor] forState:UIControlStateNormal | UIControlStateHighlighted];

        [[button titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:18]];
        [[button layer] setBorderWidth:1.0f];

        [button setTitle:@"Logged In!" forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });

    [self.view addSubview:self.button];
}

- (void)configureViewForLoggedInState
{

}

- (void)configureViewForLoggedOutState
{
    // Setup Text Fields & Borders

    self.usernameField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 70, 320, 50)];
    [self.usernameField setDelegate:self];
    [self.usernameField setPlaceholder:@"Email"];
    [self.usernameField setTag:0];
    [self.usernameField setTintColor:[UIColor hnColor]];
    [self.usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    self.passwordField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 130, 320, 50)];
    [self.passwordField setDelegate:self];
    [self.passwordField setPlaceholder:@"Password"];
    [self.passwordField setReturnKeyType:UIReturnKeyDone];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setTag:1];
    [self.passwordField setTintColor:[UIColor hnColor]];
    [self.passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    // Add borders

    self.border = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 320, 2)];
    [self.border setBackgroundColor:[UIColor tnLightGreyColor]];

    self.border2 = [[UIView alloc] initWithFrame:CGRectMake(0, 180, 320, 2)];
    [self.border2 setBackgroundColor:[UIColor tnLightGreyColor]];

    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.border];
    [self.view addSubview:self.border2];
}

- (void)buttonClicked
{
    if([[HNManager sharedManager] userIsLoggedIn]) {
        [[HNManager sharedManager] logout];
        [self.button setTitle:@"Log in" forState:UIControlStateNormal];
        [self transitionToLoggedOutView];

    } else {

        if ([self textFieldsAreFilled]) {
            [self hnLogin];
        }
        
    }
}

- (void)transitionToLoggedOutView
{
    [self configureViewForLoggedOutState];
    [self.usernameField setAlpha:0];
    [self.passwordField setAlpha:0];
    [self.border setAlpha:0];
    [self.border2 setAlpha:0];

    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.springBounciness = 5;
    anim.springSpeed = 5;
    anim.toValue = @(230);

    [UIView animateWithDuration:0.5 animations:^{

        [self.usernameField setAlpha:1];
        [self.passwordField setAlpha:1];
        [self.border setAlpha:1];
        [self.border2 setAlpha:1];

        [self.button.layer pop_addAnimation:anim forKey:@"postionY"];

    } completion:nil];
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
            [self hnLogin];
            break;
    }
    
    return NO;
}


#pragma mark - Network Methods

- (void)hnLogin
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[HNManager sharedManager] loginWithUsername:self.usernameField.text password:self.passwordField.text completion:^(HNUser *user){

        if (user) {

            [self.button setSelected:YES];
            [self.button setUserInteractionEnabled:NO];

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

- (void)showAuthenticationError
{
    TNNotification *error = [[TNNotification alloc] init];
    [error showFailureNotification:@"Username or Password is Incorrect." subtitle:nil];
}

- (BOOL)textFieldsAreFilled
{
    return ( [self.usernameField.text length] != 0 && [self.passwordField.text length] != 0 );
}

@end
