//
//  DNPresentMOTDTransition.m
//  The News
//
//  Created by Tosin Afolabi on 22/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNPresentMOTDTransition.h"

@implementation DNPresentMOTDTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];

    fromVC.view.alpha = 0.3;
    toVC.view.alpha = 0.0;

    CGRect frame = containerView.bounds;
    frame.origin.x = 50.0;
    frame.origin.y += 150.0;
    frame.size.height = 150;
    frame.size.width = 150;

    toVC.view.frame = frame;
    [containerView addSubview:toVC.view];

    [UIView animateWithDuration:0.5 animations:^{
        toVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

@end
