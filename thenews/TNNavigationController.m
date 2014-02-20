//
//  TNNavigationController.m
//  thenews
//
//  Created by Tosin Afolabi on 20/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNNavigationController.h"

@interface TNNavigationController ()

@end

@implementation TNNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
