//
//  TNCommentCell.h
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@interface TNCommentCell : MCSwipeTableViewCell
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UILabel *commentAuthorLabel;

@property (nonatomic, strong) NSDictionary *commentsData;

@end
