//
//  TNPageViewController.m
//  The News
//
//  Created by Tosin Afolabi on 26/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNPageViewController.h"

@interface TNPageViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *scrollViewPanGestureRecognzier;

@end

@implementation TNPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrollView = (UIScrollView *)view;
            self.scrollViewPanGestureRecognzier = [[UIPanGestureRecognizer alloc] init];
            self.scrollViewPanGestureRecognzier.delegate = self;
            [scrollView addGestureRecognizer:self.scrollViewPanGestureRecognzier];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.scrollViewPanGestureRecognzier)
    {
        CGPoint locationInView = [gestureRecognizer locationInView:self.view];
        if (locationInView.y > 64.0)
        {
            return YES;
        }
        return NO;
    }

    return NO;
}

@end
