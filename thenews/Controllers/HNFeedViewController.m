//
//  HNFeedViewController.m
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "libHN.h"
#import "TNRefreshView.h"
#import "TNNotification.h"
#import "HNFeedViewCell.h"
#import "SVPullToRefresh.h"
#import "TNPostViewController.h"
#import "HNFeedViewController.h"

static int CELL_HEIGHT = 85;
static NSString *CellIdentifier = @"HNFeedCell";

__weak HNFeedViewController *weakSelf;

@interface HNFeedViewController ()

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) UITableView *feedView;

@end

@implementation HNFeedViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self setFeedType:@(TNTypeHackerNews)];
    //[self setupRefreshControl];
    weakSelf = self;

    self.posts = [[NSMutableArray alloc] init];

	CGFloat navBarHeight = 64.0;
	CGSize screenSize = self.view.frame.size;
    CGRect contentViewFrame = CGRectMake(0, navBarHeight, screenSize.width, screenSize.height - navBarHeight);

	self.feedView = [[UITableView alloc] initWithFrame:contentViewFrame];
	[self.feedView setDelegate:self];
	[self.feedView setDataSource:self];
	[self.feedView setSeparatorInset:UIEdgeInsetsZero];
	[self.feedView setSeparatorColor:[UIColor tnLightGreyColor]];
	[self.feedView registerClass:[HNFeedViewCell class] forCellReuseIdentifier:CellIdentifier];

	[self.view addSubview:self.feedView];
    [self downloadPosts];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	HNFeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    HNPost *post = (self.posts)[[indexPath row]];

	[cell setForReuse];
	[cell setFrameHeight:CELL_HEIGHT];
	[cell setFeedType:TNTypeHackerNews];
    [cell configureForPost:post];

    if ([[HNManager sharedManager] userIsLoggedIn]) {

        [cell addUpvoteGesture];

        [cell setUpvoteBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {


        }];
    }

    [cell addViewCommentsGesture];

    [cell setCommentBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        [self showCommentView];
    }];

    [cell setSeparatorInset:UIEdgeInsetsZero];
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNPost *post = (self.posts)[[indexPath row]];
    TNPostViewController *postViewController = [[TNPostViewController alloc] initWithURL:[NSURL URLWithString:[post UrlString]] type:TNTypeHackerNews];

    [postViewController setDismissAction:^{ [weakSelf.navigationController popViewControllerAnimated:YES]; }];

    [self.navigationController pushViewController:postViewController animated:YES];
}

#pragma mark - Network Methods

- (void)downloadPosts
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[HNManager sharedManager] loadPostsWithFilter:PostFilterTypeTop completion:^(NSArray *posts){

        if (posts) {
            [self.posts addObjectsFromArray:posts];
            [self.feedView reloadData];
        }
        else {
            // No posts retrieved, handle the error
            NSLog(@"Error Occured");
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)showCommentView
{
    NSLog(@"CommentViewShown");
}


#pragma mark - Private Methods

- (void)setupRefreshControl
{
    [self.feedView addPullToRefreshWithActionHandler:^{

    }];

    [self.feedView addInfiniteScrollingWithActionHandler:^{

    }];

    TNRefreshView *pulling = [[TNRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) state:TNRefreshStatePulling];
    TNRefreshView *loading = [[TNRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) state:TNRefreshStateLoading];
    
    [[self.feedView pullToRefreshView] setCustomView:pulling forState:SVPullToRefreshStateAll];
    [[self.feedView pullToRefreshView] setCustomView:loading forState:SVPullToRefreshStateLoading];
}


@end