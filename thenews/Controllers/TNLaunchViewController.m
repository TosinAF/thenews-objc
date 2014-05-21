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

@interface TNLaunchViewController ()

@property (strong, nonatomic) UILabel *appTitle;
@property (strong, nonatomic) TNButton *login;
@property (strong, nonatomic) UIButton *skip;

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
    anim2.toValue = [NSValue valueWithCGRect:CGRectMake(10, screenSize.height - 110, 300, 50)];

    [self.skip.layer pop_addAnimation:anim2 forKey:@"frame"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScreenName:@"Launch"];
    [self.view setBackgroundColor:[UIColor tnColor]];
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    CGSize screenSize = self.view.bounds.size;

    self.appTitle = ({
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, screenSize.width, 100)];
        [title setText:@"THE NEWS"];
        [title setTextColor:[UIColor whiteColor]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont fontWithName:@"Montserrat-Bold" size:40]];
        title;
    });

    self.login = ({
        TNButton *login = [[TNButton alloc] initWithFrame:CGRectMake(20, screenSize.height + 100, screenSize.width - 40, 60)];
        [login setBackgroundImageWithNormalColor:[UIColor tnColor] highlightColor:[UIColor whiteColor]];
        [login setTitle:@"Log In" forState:UIControlStateNormal];
        [login addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        login;
    });

    self.skip = ({
        UIButton *skip = [UIButton buttonWithType:UIButtonTypeCustom ];
        [skip setFrame:CGRectMake(10, screenSize.height + 150, screenSize.width - 20, 50)];
        [skip setTitle:@"Skip to The News" forState:UIControlStateNormal];
        [skip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[skip titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20]];
        [skip addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        skip;
    });

    [self.view addSubview:self.appTitle];
    [self.view addSubview:self.login];
    [self.view addSubview:self.skip];
}

- (void)loginButtonPressed:(id)selector
{
    TNLoginViewController *loginViewController = [[TNLoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)skipButtonPressed:(id)selector
{
    TNHomeViewController *homeViewController = [[TNHomeViewController alloc] init];
    [self.navigationController pushViewController:homeViewController animated:YES];

    // Remove Launch View Controllers As It Is No Longer Accessible
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [self.navigationController setViewControllers:@[[viewControllers lastObject]]];
}

@end