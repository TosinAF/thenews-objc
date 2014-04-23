//
//  DNMOTDViewController.m
//  The News
//
//  Created by Tosin Afolabi on 22/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNMOTDViewController.h"

@interface DNMOTDViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIView *label;

@end

@implementation DNMOTDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.label = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.label setBackgroundColor:[UIColor darkGrayColor]];
    //[self.label setText:@"MOTD!"];
    //[self.label setFont:[UIFont fontWithName:@"Monteserrat" size:36.0f]];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.label];

     self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];

    [self.view addGestureRecognizer:pan];

    //UIDynamicItemBehavior* dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
    //dynamic.allowsRotation = NO;
    //[self.animator addBehavior:dynamic];

}



@end
