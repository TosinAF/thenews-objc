//
//  TNTutorialViewController.h
//  The News
//
//  Created by Tosin Afolabi on 21/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, TNTutorial) {
	TNTutorialNavigationBarSwipe,
	TNTutorialRightTableViewCellSwipe,
    TNTutorialLeftTableViewCellSwipe
};

@interface TNTutorialViewController : UIViewController

@property (nonatomic, assign) TNTutorial type;

- (instancetype)initWithTutorial:(TNTutorial)type;

@end
