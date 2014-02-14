//
//  TNLaunchViewController.m
//  thenews
//
//  Created by Tosin Afolabi on 03/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNLaunchViewController.h"
#import "TNSignupViewController.h"
#import "TNLoginViewController.h"
#import "UIColor+TNColors.h"
#import "TNButton.h"

@interface TNLaunchViewController ()

@property (strong, nonatomic) UILabel *appTitle;
@property (strong, nonatomic) TNButton *login;
@property (strong, nonatomic) TNButton *signup;

@end

@implementation TNLaunchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Animation to bring up the two buttons from the bottom of the screen

    CGRect signupFrame = self.signup.frame;
    signupFrame.origin.y = 388;

    CGRect loginFrame = self.login.frame;
    loginFrame.origin.y = 468;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

    self.signup.frame = signupFrame;
    self.login.frame = loginFrame;

    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor hnColor]];

    CGSize screenSize = self.view.bounds.size;

    self.appTitle = ({
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, screenSize.width, 100)];
        [title setText:@"THE NEWS"];
        [title setTextColor:[UIColor whiteColor]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont fontWithName:@"Montserrat-Bold" size:40]];
        title;
    });

    self.signup = ({
        TNButton *signup = [[TNButton alloc] initWithFrame:CGRectMake(10, screenSize.height + 100, screenSize.width - 20, 50)];
        [signup withText:@"Sign Up" normalColor:[UIColor whiteColor] highlightColor:[UIColor hnColor] border:NO];
        [signup addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        signup;
    });

    self.login = ({
        TNButton *login = [[TNButton alloc] initWithFrame:CGRectMake(10, screenSize.height + 100, screenSize.width - 20, 50)];
        [login withText:@"Log In" normalColor:[UIColor hnColor] highlightColor:[UIColor whiteColor] border:YES];
        [login addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        login;
    });

    [self.view addSubview:self.appTitle];
    [self.view addSubview:self.signup];
    [self.view addSubview:self.login];
}

- (void)signupButtonPressed:(id)selector
{
    TNSignupViewController *signupViewController = [[TNSignupViewController alloc] init];
    [self.navigationController pushViewController:signupViewController animated:YES];
}

- (void)loginButtonPressed:(id)selector
{
    TNLoginViewController *loginViewController = [[TNLoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

@end