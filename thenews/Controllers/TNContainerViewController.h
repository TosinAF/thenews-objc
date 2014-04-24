//
//  TNContainerViewController.h
//  The News
//
//  Created by Tosin Afolabi on 11/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNMenuView.h"
#import <UIKit/UIKit.h>

@interface TNContainerViewController : UIViewController

@property (nonatomic, strong) NSNumber *feedType;

@property (nonatomic, strong) TNMenuView *menu;
@property (nonatomic, strong) UIButton *menuButton;

@property (weak,nonatomic) UIViewController *currentViewController;
@property (weak,nonatomic) UIViewController *nextViewController;

@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UINavigationItem *navItem;

- (id)initWithType:(TNType)type;

- (void)toggleMenu;
- (void)hideMenu;

- (void)fadeOutChildViewController;

@end
