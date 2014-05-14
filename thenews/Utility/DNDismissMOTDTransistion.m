//
//  DNDismissMOTDTransistion.m
//  The News
//
//  Created by Tosin Afolabi on 26/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "JCRBlurView.h"
#import "DNDismissMOTDTransistion.h"

@implementation DNDismissMOTDTransistion

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *blurView;

    for (UIView *subview in toVC.view.subviews)
    {
        if([subview isKindOfClass:[JCRBlurView class]])
        {
            blurView = subview;
        }
    }

    [UIView animateWithDuration:0.3 animations:^{

        [fromVC.view setAlpha:0.0];
        [blurView setAlpha:0.0];

    } completion:^(BOOL finished) {

        [blurView removeFromSuperview];
        [fromVC.view removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end