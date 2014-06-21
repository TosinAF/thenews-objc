//
//  PHFeedViewController.h
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHFeedViewController : UIViewController

@property (nonatomic, strong) NSNumber *feedType;
@property (nonatomic, strong) UITableView *feedView;

@end
