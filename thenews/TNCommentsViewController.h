//
//  TNCommentsViewController.h
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignerNewsAPIClient.h"
#import "RDRStickyKeyboardView.h"
#import "TNTypeEnum.h"

@interface TNCommentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextViewDelegate>
@property (nonatomic) int storyID;
@property (nonatomic) NSNumber *replyToID;
@property (nonatomic) NSNumber *network;
@property (nonatomic) NSArray *commentsData;
@property (nonatomic, strong) DesignerNewsAPIClient *api;
@property (nonatomic, strong) RDRStickyKeyboardView *keyboardView;
@property (nonatomic, strong) UITableView *tableView;


@end
