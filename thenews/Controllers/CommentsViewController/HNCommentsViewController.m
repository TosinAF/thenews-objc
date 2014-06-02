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
#import "TNPostViewController.h"
#import "HNCommentsViewController.h"

static NSString *CellIdentifier = @"HNCommentCell";

@interface HNCommentsViewController () <TNCommentCellDelegate>

@property (nonatomic, strong) HNPost *post;
@property (nonatomic, strong) id replyToObject;

@end

@implementation HNCommentsViewController

- (instancetype)initWithPost:(HNPost *)post
{
    self = [super init];

    if (self) {
        [self setScreenName:@"DNComments"];
        self.title = @"HACKER NEWS";
        self.post = post;
        self.replyToObject = post;
        self.themeColor = [UIColor hnColor];
        self.comments = [NSArray new];
        self.commentsView = [UITableView new];
    }

    return self;
}

#pragma mark - Keyboard Methods

- (BOOL)shouldKeyboardBeAdded
{
    if ([[HNManager sharedManager] userIsLoggedIn]) return YES;
    return NO;
}

#pragma mark - View Methods

- (void)addTableHeaderView
{
    /* Set Up Table Header View */

    TNHeaderView *headerView = [[TNHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 85) type:TNTypeHackerNews];
    [headerView configureForPost:self.post];

    if ([[HNManager sharedManager] userIsLoggedIn]) {

        [headerView setButtonTitle:@"Comment"];
        [headerView setButtonAction:^{

            self.replyToObject = self.post;
            [self.commentInputView.textView becomeFirstResponder];
            NSLog(@"%@",self.replyToObject);
            
        }];

        [headerView showButton];
    }

    [self.commentsView setTableHeaderView:headerView];
}

- (void)registerClassForCell
{
    [self.commentsView registerClass:[HNCommentCell class] forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNCommentCell *cell;

    if (!cell){
        cell = [[HNCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    HNComment *comment = [self.comments objectAtIndex:[indexPath row]];

    [cell configureForComment:comment];
    [cell setGestureDelegate:self];
    [cell updateSubviews];

    if ([[HNManager sharedManager] userIsLoggedIn]) [cell addReplyCommentGesture];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static HNCommentCell *cell;

    if (!cell){
        cell = [[HNCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    [cell configureForComment:self.comments[[indexPath row]]];
    return [cell updateSubviews];
}

#pragma mark - TNCommentCell Delegate

-(void)replyActionForCell:(TNCommentCell *)cell
{
    HNCommentCell *hnCell = (HNCommentCell *)cell;
    self.replyToObject = [hnCell comment];
    [self.commentInputView.textView becomeFirstResponder];
}

#pragma mark - Network Methods

- (void)downloadComments {

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[HNManager sharedManager] loadCommentsFromPost:self.post completion:^(NSArray *comments){
        if (comments) {

            self.comments = comments;
            [self.commentsView reloadData];

        } else {

           NSLog(@"The task failed.");
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)postButtonPressed {

    TNNotification *notification = [[TNNotification alloc] init];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[HNManager sharedManager] replyToPostOrComment:self.replyToObject withText:self.commentInputView.textView.text completion:^(BOOL success){
        if (success) {

           [notification showSuccessNotification:@"Comment Post Successful" subtitle:nil];
            [self postActionCompleted];
            [self.commentsView reloadData];

        } else {
            
            NSLog(@"Error occurred");
            [notification showFailureNotification:@"Comment Post Failed" subtitle:nil];
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)switchAction
{
    NSURL *postURL = [NSURL URLWithString:[self.post UrlString]];

    TNPostViewController *vc = [[TNPostViewController alloc] initWithURL:postURL type:TNTypeHackerNews];
    vc.createdFromSwitch = YES;

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self.navigationController pushViewController:vc animated:NO];
    } completion:nil];
}



@end
