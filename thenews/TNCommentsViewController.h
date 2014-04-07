//
//  TNCommentsViewController.h
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignerNewsAPIClient.h"

@interface TNCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic) NSNumber *replyToID;
@property (nonatomic) NSNumber *network;

- (instancetype)initWithType:(TNType)type story:(DNStory *)story;

@end
