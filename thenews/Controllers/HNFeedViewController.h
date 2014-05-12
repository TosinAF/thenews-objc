//
//  HNFeedViewController.h
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "libHN.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface HNFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSNumber *feedType;
@property (nonatomic, strong) UITableView *feedView;

- (instancetype)initWithPostFilterType:(PostFilterType)type;
- (void)setPostFilterType:(int)type;


@end
