//
//  DNCommentsSearchViewController.m
//  The News
//
//  Created by Tosin Afolabi on 18/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNSearchHeaderView.h"
#import "DNCommentsSearchViewController.h"

@interface DNCommentsSearchViewController ()

@end

@implementation DNCommentsSearchViewController

- (void)addTableHeaderView
{
    /* Set Up Table Header View */

    TNSearchHeaderView *headerView = [[TNSearchHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 85) type:TNTypeDesignerNews];
    [headerView configureForStory:self.story];

    if ([[DNManager sharedManager] isUserAuthenticated]) {

        [headerView setButtonTitle:@"Comment"];
        [headerView setButtonAction:^{

            self.replyToID = nil;
            [self.commentInputView.textView becomeFirstResponder];
            NSLog(@"%@",self.replyToID);

        }];

        [headerView showButton];
    }

    [self.commentsView setTableHeaderView:headerView];
}



@end
