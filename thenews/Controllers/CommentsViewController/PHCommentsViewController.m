//
//  PHCommentsViewController.m
//  The News
//
//  Created by Tosin Afolabi on 14/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNHeaderView.h"
#import "PHCommentCell.h"
#import "TNPostViewController.h"
#import "PHCommentsViewController.h"

static NSString *CellIdentifier = @"PHCommentCell";

@interface PHCommentsViewController ()

@end

@implementation PHCommentsViewController

- (instancetype)initWithProduct:(PHProduct *)product
{
    self = [super init];

    if (self) {
        [self setScreenName:@"PHComments"];
        self.title = @"PRODUCT HUNT";
        self.product = product;
        self.themeColor = [UIColor phColor];
        self.comments = [NSArray new];
        self.commentsView = [UITableView new];
    }

    return self;
}

#pragma mark - Keyboard Methods

- (BOOL)shouldKeyboardBeAdded
{
    return NO;
}

#pragma mark - View Methods

- (void)addTableHeaderView
{
    /* Set Up Table Header View */

    TNHeaderView *headerView = [[TNHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 85) type:TNTypeProductHunt];
    [headerView configureForProduct:self.product];

    [self.commentsView setTableHeaderView:headerView];
}

- (void)registerClassForCell
{
    [self.commentsView registerClass:[PHCommentCell class] forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - Table View Data Source Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHCommentCell *cell;

    if (!cell){
        cell = [[PHCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    PHComment *comment = [self.comments objectAtIndex:[indexPath row]];

    [cell configureForComment:comment];
    [cell updateSubviews];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static PHCommentCell *cell;

    if (!cell){
        cell = [[PHCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    [cell configureForComment:self.comments[[indexPath row]]];

    return [cell updateSubviews];
}

#pragma mark - Network Methods

- (void)downloadComments {

    [[PHManager sharedManager] getCommentsForProduct:self.product success:^(NSArray *comments) {

        self.comments = comments;
        [self.commentsView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"The task: %@ failed with error: %@", task, error);

    }];
}

- (void)switchAction
{
    NSURL *productURL = [NSURL URLWithString:[self.product URL]];

    TNPostViewController *vc = [[TNPostViewController alloc] initWithURL:productURL type:TNTypeProductHunt];
    vc.createdFromSwitch = YES;

    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self.navigationController pushViewController:vc animated:NO];
    } completion:nil];
}

@end
