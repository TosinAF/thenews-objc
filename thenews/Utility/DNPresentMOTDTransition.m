//
//  DNPresentMOTDTransition.m
//  The News
//
//  Created by Tosin Afolabi on 22/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <POP/POP.h>
#import "JCRBlurView.h"
#import "DNPresentMOTDTransition.h"

@implementation DNPresentMOTDTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    toVC.view.alpha = 0.0;
    [toVC.view setFrame:containerView.bounds];

    JCRBlurView *blurView = [JCRBlurView new];
    [blurView setFrame:containerView.bounds];
    [blurView setAlpha:0.0];
    [fromVC.view addSubview:blurView];

    CGRect frame = toVC.view.frame;
    frame.origin.y = -568;
    [toVC.view setFrame:frame];
    [containerView addSubview:toVC.view];

    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.springBounciness = 5;
    anim.springSpeed = 5;
    anim.toValue = [NSValue valueWithCGRect:containerView.bounds];

    [UIView animateWithDuration:0.5 animations:^{
        
        [blurView setBlurTintColor:[UIColor blackColor]];
        [blurView setAlpha:0.8];
        [toVC.view setAlpha:1.0];
        [toVC.view pop_addAnimation:anim forKey:@"frame"];
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

@end
