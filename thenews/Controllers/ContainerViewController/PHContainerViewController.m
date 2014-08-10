//
//  PHContainerViewController.m
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHFeedViewController.h"
#import "PHContainerViewController.h"

@interface PHContainerViewController ()

@end

@implementation PHContainerViewController

- (instancetype)init
{
    self = [super initWithType:TNTypeProductHunt];
    if (self) {
        [self setScreenName:@"PHContainer"];
    }
    return self;
}

- (void)navBarTapped
{
    PHFeedViewController* phVC = (PHFeedViewController *)self.currentViewController;
    [phVC.feedView setContentOffset:CGPointMake(0,0) animated:YES];
}

@end
