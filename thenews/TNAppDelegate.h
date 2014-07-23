//
//  TNAppDelegate.h
//  thenews
//
//  Created by Tosin Afolabi on 30/01/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

@class TNHomeViewController;

#import <UIKit/UIKit.h>

@interface TNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TNHomeViewController *homeViewController;

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;

@end
