//
//  TNSettingsViewController.m
//  The News
//
//  Created by Tosin Afolabi on 24/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <POP/POP.h>
#import "DNManager.h"
#import "TNButton.h"
#import "TNTextField.h"
#import "TNNotification.h"
#import "DNSettingsViewController.h"

@interface DNSettingsViewController () <UITextFieldDelegate>

@property (nonatomic, strong) DNUser *user;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) TNButton *button;

@property (strong, nonatomic) TNTextField *usernameField;
@property (strong, nonatomic) TNTextField *passwordField;
@property (strong, nonatomic) UIView *border;
@property (strong, nonatomic) UIView *border2;

@end

@implementation DNSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScreenName:@"DNSettings"];
    [self.view setBackgroundColor:[UIColor clearColor]];


    if ([[DNManager sharedManager] isUserAuthenticated]) {
        [self configureViewForLoggedInState];
    } else {
        [self configureViewForLoggedOutState];
    }

    // Button

    self.button = ({

        TNButton *button;


        if ([[DNManager sharedManager] isUserAuthenticated]) {
            button = [[TNButton alloc] initWithFrame:CGRectMake(20, 270, self.view.frame.size.width  - 40, 50)];
            [button setTitle:@"Log Out" forState:UIControlStateNormal];
        } else {
            button = [[TNButton alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 50)];
            [button setTitle:@"Login" forState:UIControlStateNormal];
        }

        [button setBackgroundImageWithNormalColor:[UIColor whiteColor] highlightColor:[UIColor dnNavBarColor]];
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

#pragma mark - Network Method

- (void)getUserProfile
{
    [[DNManager sharedManager] getUserInfo:^(DNUser *userInfo) {

        self.user = userInfo;
        [self downloadImage];
        [self updateLabels];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"Error Occured");

    }];
}

- (void)downloadImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *imageURL = [NSURL URLWithString:[self.user portraitURL]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        [self performSelectorOnMainThread:@selector(setImage:) withObject:imageData waitUntilDone:YES];
    });
}

- (void)setImage:(NSData *)imageData
{
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    [self.imageView setImage:image];
}

- (void)updateLabels
{
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",[self.user firstName], [self.user lastName]];
    [self.nameLabel setText:fullName];
    [self.jobLabel setText:[self.user job]];

    [self.nameLabel setTextColor:[UIColor blackColor]];
    [self.jobLabel setTextColor:[UIColor blackColor]];
}

- (void)buttonClicked
{
    if([[DNManager sharedManager] isUserAuthenticated]) {
        [[DNManager sharedManager] logout];
        [self.button setTitle:@"Log in" forState:UIControlStateNormal];
        [self transitionToLoggedOutView];

    } else {

        if ([self textFieldsAreFilled]) {
            [self dnLogin];
        }

    }
}

- (void)dnLogin
{
    DNManager *DNClient = [DNManager sharedManager];

    [DNClient authenticateUser:self.usernameField.text password:self.passwordField.text success:^(NSString *accessToken) {

        [self.button setSelected:YES];
        [self.usernameField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        [self transitionToLoggedInView];


    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [self showAuthenticationError];
        
    }];
}

#pragma mark - View States

- (void)configureViewForLoggedInState
{
    // Profile Image
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 90, 80, 80)];
    [self.imageView setBackgroundColor:[UIColor tnLightGreyColor]];

    CGPoint center = self.imageView.center;
    center.x = self.view.center.x;
    self.imageView.center = center;

    // Labels

    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, self.view.frame.size.width, 30)];
    [self.nameLabel setFont:[UIFont fontWithName:@"Montserrat" size:18.0f]];
    [self.nameLabel setText:@"John Doe"];
    [self.nameLabel setTextColor:[UIColor tnGreyColor]];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];

    self.jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 30)];
    [self.jobLabel setFont:[UIFont fontWithName:@"Montserrat" size:18.0f]];
    [self.jobLabel setText:@"Partner at John Doe Industires"];
    [self.jobLabel setTextColor:[UIColor tnGreyColor]];
    [self.jobLabel setTextAlignment:NSTextAlignmentCenter];

    [self.view addSubview:self.imageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.jobLabel];

    [self getUserProfile];
}

- (void)configureViewForLoggedOutState
{
    // Setup Text Fields & Borders

    CGFloat screenWidth = self.view.frame.size.width;

    self.usernameField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 70, screenWidth, 50)];
    [self.usernameField setDelegate:self];
    [self.usernameField setPlaceholder:@"Email"];
    [self.usernameField setTag:0];
    [self.usernameField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    self.passwordField = [[TNTextField alloc] initWithFrame:CGRectMake(50, 130, screenWidth, 50)];
    [self.passwordField setDelegate:self];
    [self.passwordField setPlaceholder:@"Password"];
    [self.passwordField setReturnKeyType:UIReturnKeyDone];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setTag:1];
    [self.passwordField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    // Add borders

    self.border = [[UIView alloc] initWithFrame:CGRectMake(0, 120, screenWidth, 2)];
    [self.border setBackgroundColor:[UIColor tnLightGreyColor]];

    self.border2 = [[UIView alloc] initWithFrame:CGRectMake(0, 180, screenWidth, 2)];
    [self.border2 setBackgroundColor:[UIColor tnLightGreyColor]];

    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.border];
    [self.view addSubview:self.border2];

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
            [self dnLogin];
            break;
    }
    
    return NO;
}

#pragma mark - Transition Methods

- (void)transitionToLoggedInView
{
    [self configureViewForLoggedInState];
    [self.imageView setAlpha:0];
    [self.nameLabel setAlpha:0];
    [self.jobLabel setAlpha:0];

    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.springBounciness = 5;
    anim.springSpeed = 5;
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(20, 270, self.view.frame.size.width - 40, 50)];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.imageView setAlpha:1];
        [self.nameLabel setAlpha:1];
        [self.jobLabel setAlpha:1];

        [self.usernameField setAlpha:0];
        [self.passwordField setAlpha:0];
        [self.border setAlpha:0];
        [self.border2 setAlpha:0];

        [self.button.layer pop_addAnimation:anim forKey:@"postionY"];

    } completion:^(BOOL finished) {
        [self.usernameField removeFromSuperview];
        [self.passwordField removeFromSuperview];
        [self.border removeFromSuperview];
        [self.border2 removeFromSuperview];
    }];
}

- (void)transitionToLoggedOutView
{
    [self configureViewForLoggedOutState];
    [self.usernameField setAlpha:0];
    [self.passwordField setAlpha:0];
    [self.border setAlpha:0];
    [self.border2 setAlpha:0];

    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.springBounciness = 5;
    anim.springSpeed = 5;
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(20, 200, self.view.frame.size.width  - 40, 50)];


    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

        [self.usernameField setAlpha:1];
        [self.passwordField setAlpha:1];
        [self.border setAlpha:1];
        [self.border2 setAlpha:1];

        [self.imageView setAlpha:0];
        [self.nameLabel setAlpha:0];
        [self.jobLabel setAlpha:0];

        [self.button.layer pop_addAnimation:anim forKey:@"postionY"];


    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        [self.nameLabel removeFromSuperview];
        [self.jobLabel removeFromSuperview];
        NSLog(@"%f",self.button.frame.origin.y);
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