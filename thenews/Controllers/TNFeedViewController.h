//
//  TNFeedViewController.h
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "GTScrollNavigationBar.h"


#import <UIKit/UIKit.h>

@interface TNFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPageViewControllerDelegate>

typedef NS_ENUM (NSInteger, TNFeedType) {
	TNFeedTypeDesignerNews,
	TNFeedTypeHackerNews
};

@property (nonatomic, strong) NSNumber *feedType;

- (id)initWithFeedType:(TNFeedType)feedType;

- (void)resetNavBar;

@end
