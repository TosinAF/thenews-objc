//
//  TNFeedViewController.h
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@interface TNFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPageViewControllerDelegate, MCSwipeTableViewCellDelegate>

typedef NS_ENUM (NSInteger, TNFeedType) {
	TNFeedTypeDesignerNews,
	TNFeedTypeHackerNews
};

@property (nonatomic, strong) NSNumber *feedType;

- (id)initWithFeedType:(TNFeedType)feedType;

@end
