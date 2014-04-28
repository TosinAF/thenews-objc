//
//  DNCommentsViewController.m
//  The News
//
//  Created by Tosin Afolabi on 18/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNHeaderView.h"
#import "DNCommentCell.h"
#import "TNNotification.h"
#import "JSMessageInputView.h"
#import "DNCommentsViewController.h"

static NSString *CellIdentifier = @"DNCommentCell";

@interface DNCommentsViewController () <TNCommentCellDelegate>

@property (nonatomic, strong) DNStory *story;

@end

@implementation DNCommentsViewController

- (instancetype)initWithStory:(DNStory *)story
{
    self = [super init];

    if (self) {
        self.title = @"DESIGNER NEWS";
        self.story = story;
        self.themeColor = [UIColor dnColor];
        self.comments = [NSArray new];
        self.commentsView = [UITableView new];
    }

    return self;
}

#pragma mark - View Methods

- (void)addTableHeaderView
{
    /* Set Up Table Header View */

    TNHeaderView *headerView = [[TNHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 85) type:TNTypeDesignerNews];
    [headerView configureForStory:self.story];
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
    [self.commentsView registerClass:[DNCommentCell class] forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    DNComment *comment = [self.comments objectAtIndex:[indexPath row]];

    [cell setGestureDelegate:self];
    [cell configureForComment:comment];
    [cell addUpvoteGesture];
    [cell addReplyCommentGesture];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNCommentCell *cell = [[DNCommentCell alloc] init];
    DNComment *comment = self.comments[[indexPath row]];

    NSString *commentStr = [comment body];
    [cell setCellContent: @{@"comment":[comment body],@"depth":[comment depth]}];

    return [cell estimateCellHeightWithComment:commentStr];
}

#pragma mark - TNCommentCell Gesture Delegate

- (void)upvoteActionForCell:(TNCommentCell *)cell
{
    DNCommentCell *dnCell = (DNCommentCell *)cell;
    NSString *commentID = [[[dnCell cellContent] objectForKey:@"commentID"] stringValue];

    TNNotification *notification = [[TNNotification alloc] init];

    [[DNManager sharedManager] upvoteCommentWithID:commentID success:^{

        [notification showSuccessNotification:@"Comment Upvote Successful" subtitle:nil];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [notification showFailureNotification:@"Comment Upvote Failed" subtitle:@"You can only upvote a comment once."];
    }];
}

- (void)replyActionForCell:(TNCommentCell *)cell
{
    DNCommentCell *dnCell = (DNCommentCell *)cell;
    self.replyToID = [[dnCell cellContent] objectForKey:@"commentID"];
    NSLog(@"reply is %@", self.replyToID);
    [self.commentInputView.textView becomeFirstResponder];
}

#pragma mark - Network Methods

- (void)downloadComments {

    [[DNManager sharedManager] getCommentsForStoryWithID:[[self.story storyID] stringValue] success:^(NSArray *comments) {

        self.comments = comments;
        [self.commentsView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"The task: %@ failed with error: %@", task, error);
        
    }];
}

- (void)postButtonPressed {
    [self postComment:self.commentInputView.textView.text inReplyTo:self.replyToID];
}

- (void)postComment:(NSString *)comment inReplyTo:(NSNumber *)originalCommentID {

    TNNotification *notification = [[TNNotification alloc] init];

    if (originalCommentID) {

        [[DNManager sharedManager] replyCommentWithID:[[self.story storyID] stringValue] comment:comment success:^{

            [self downloadComments];
            [self postActionCompleted];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString *errorMsg = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
            NSLog(@"%@", errorMsg);
        }];

    } else {

        [[DNManager sharedManager] replyStoryWithID:[[self.story storyID] stringValue] comment:comment success:^{

            [self downloadComments];
            [self postActionCompleted];
            [notification showSuccessNotification:@"Comment Post Successful" subtitle:nil];

        } failure:^(NSURLSessionDataTask *task, NSError *error){

            NSString *errorMsg = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
            NSLog(@"%@", errorMsg);
            [notification showFailureNotification:@"Comment Post Failed" subtitle:nil];
        }];
    }
    
}

@end
