//
//  TNCommentsViewController.h
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNManager.h"
#import <UIKit/UIKit.h>

@interface TNCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextViewDelegate>

- (instancetype)initWithType:(TNType)type story:(DNStory *)story;

@end
