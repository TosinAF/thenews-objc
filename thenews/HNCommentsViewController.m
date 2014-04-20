//
//  HNCommentsViewController.m
//  The News
//
//  Created by Tosin Afolabi on 20/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNHeaderView.h"
#import "HNCommentCell.h"
#import "TNNotification.h"
#import "HNCommentsViewController.h"

static NSString *CellIdentifier = @"HNCommentCell";

@interface HNCommentsViewController ()

@property (nonatomic, strong) HNPost *post;

@end

@implementation HNCommentsViewController

- (instancetype)initWithPost:(HNPost *)post
{
    self = [super init];

    if (self) {
        self.title = @"HACKER NEWS";
        self.post = post;
        self.themeColor = [UIColor hnColor];
        self.comments = [NSArray new];
        self.commentsView = [UITableView new];
    }

    return self;
    
}

#pragma mark - View Methods

- (void)addTableHeaderView
{
    /* Set Up Table Header View */

    TNHeaderView *headerView = [[TNHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 85) type:TNTypeHackerNews];
    [headerView configureForPost:self.post];
    [headerView setButtonTitle:@"Comment"];
    [headerView setButtonAction:^{

        self.replyToID = nil;
        [self.commentInputView.textView becomeFirstResponder];
        NSLog(@"%@",self.replyToID);

    }];

    [self.commentsView setTableHeaderView:headerView];
}

- (void)registerClassForCell
{
    [self.commentsView registerClass:[HNCommentCell class] forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    HNComment *comment = [self.comments objectAtIndex:[indexPath row]];
    [cell configureForComment:comment];
    [cell addReplyCommentGesture];

    [cell configureReplyBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        HNCommentCell *hnCell = (HNCommentCell *)cell;
        self.replyToID = [[hnCell cellContent] objectForKey:@"CommentId"];
        NSLog(@"reply is %@", self.replyToID);
        [self.commentInputView.textView becomeFirstResponder];

    }];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNCommentCell *cell = [[HNCommentCell alloc] init];
    HNComment *comment = self.comments[[indexPath row]];
    NSString *commentStr = [comment Text];
    
    return [cell estimateCellHeightWithComment:commentStr];
}

#pragma mark - Network Methods

- (void)downloadComments {

    [[HNManager sharedManager] loadCommentsFromPost:self.post completion:^(NSArray *comments){
        if (comments) {

            self.comments = comments;
            [self.commentsView reloadData];

        } else {

           NSLog(@"The task failed.");
        }
    }];
}

- (void)postButtonPressed {
    //[self postComment:self.commentInputView.textView.text inReplyTo:self.replyToID];
}

@end
