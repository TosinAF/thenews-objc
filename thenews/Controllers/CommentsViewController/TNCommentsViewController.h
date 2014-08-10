//
//  TNCommentsViewController.h
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//
//  This Class has been been designed as a virtual/abstract class

#import "JSMessageInputView.h"
#import <UIKit/UIKit.h>

@interface TNCommentsViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic) UIColor *themeColor;
@property (nonatomic, strong) NSNumber *feedType;
@property (nonatomic, strong) NSArray *comments;

@property (nonatomic) UITableView *commentsView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (weak, nonatomic, readonly) JSMessageInputView *commentInputView;

- (void)postActionCompleted;

// Methods to be overridden

- (void)downloadComments;

- (void)postButtonPressed;

- (BOOL)shouldKeyboardBeAdded;

- (void)addTableHeaderView;

- (void)registerClassForCell;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
