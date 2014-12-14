//
//  TNLaunchViewController.m
//  thenews
//
//  Created by Tosin Afolabi on 03/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <POP/POP.h>
#import "TNLaunchViewController.h"
#import "TNLoginViewController.h"
#import "TNHomeViewController.h"
#import "TNButton.h"
#import "GAIDictionaryBuilder.h"

@interface TNLaunchViewController ()

@property (strong, nonatomic) UILabel *appTitle;
@property (strong, nonatomic) TNButton *login;
@property (strong, nonatomic) UIButton *skip;

@property (strong, nonatomic) NSLayoutConstraint *loginButtonYConstraint;
@property (strong, nonatomic) NSLayoutConstraint *skipButtonYConstraint;

@end

@implementation TNLaunchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGSize screenSize = self.view.bounds.size;

    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.springBounciness = 10;
    anim.springSpeed = 10;
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(20, screenSize.height - 180, screenSize.width - 40, 60)];;

    [self.login.layer pop_addAnimation:anim forKey:@"frame"];

    POPSpringAnimation *anim2 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim2.springBounciness = 10;
    anim2.springSpeed = 10;
    anim2.toValue = [NSValue valueWithCGRect:CGRectMake(0, screenSize.height - 110, screenSize.width, 50)];

    [self.skip.layer pop_addAnimation:anim2 forKey:@"frame"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScreenName:@"Launch"];
    [self.view setBackgroundColor:[UIColor tnColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    CGSize screenSize = self.view.bounds.size;

    self.appTitle = ({
        UILabel *title = [UILabel new];
        [title setText:@"THE NEWS"];
        [title setTextColor:[UIColor whiteColor]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont fontWithName:@"Montserrat-Bold" size:40]];
        [title setTranslatesAutoresizingMaskIntoConstraints:false];
        title;
    });

    self.login = ({
        TNButton *login = [[TNButton alloc] initWithFrame:CGRectMake(20, screenSize.height + 100, screenSize.width - 40, 60)];
        [login setBackgroundImageWithNormalColor:[UIColor tnColor] highlightColor:[UIColor whiteColor]];
        [login setTitle:@"Log In" forState:UIControlStateNormal];
        [login addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        CGPoint center = login.center;
        center.x = self.view.center.x;
        login.center = center;

        login;
    });

    self.skip = ({
        UIButton *skip = [UIButton buttonWithType:UIButtonTypeCustom];
        [skip setFrame:CGRectMake(0, screenSize.height + 150, screenSize.width, 50)];
        [skip setTitle:@"Skip to The News" forState:UIControlStateNormal];
        [skip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[skip titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20]];
        [[skip titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [skip addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        skip;
    });

    [self.view addSubview:self.appTitle];
    [self.view addSubview:self.login];
    [self.view addSubview:self.skip];

    [self layoutSubviews];
}

- (void)layoutSubviews
{
    NSDictionary *views = @{ @"title": self.appTitle };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[title]" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.appTitle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}

- (void)loginButtonPressed:(id)selector
{
    [self logButtonPress:(UIButton *)selector];

    TNLoginViewController *loginViewController = [[TNLoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)skipButtonPressed:(id)selector
{
    [self logButtonPress:(UIButton *)selector];

    TNHomeViewController *homeViewController = [[TNHomeViewController alloc] init];
    [self.navigationController pushViewController:homeViewController animated:YES];

    // Remove Launch View Controllers As It Is No Longer Accessible
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [self.navigationController setViewControllers:@[[viewControllers lastObject]]];
}

#pragma mark - Google Analytics

- (void)logButtonPress:(UIButton *)button{

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker set:kGAIScreenName value:@"Launch"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:[button.titleLabel text]
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
}

@end