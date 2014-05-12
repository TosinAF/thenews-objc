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

@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UINavigationItem *navItem;

@property (weak,nonatomic) UIViewController *currentViewController;
@property (weak,nonatomic) UIViewController *nextViewController;


- (id)initWithType:(TNType)type;


- (void)hideMenu;
- (void)navBarTapped;
- (void)fadeOutChildViewController;
- (void)changeChildViewController;

@end
