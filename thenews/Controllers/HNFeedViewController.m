//
//  HNFeedViewController.m
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "Reachability.h"

#import "TNEmptyStateView.h"
#import "TNRefreshView.h"
#import "TNNotification.h"
#import "HNFeedViewCell.h"

#import "SVPullToRefresh.h"
#import "TNPostViewController.h"
#import "HNCommentsViewController.h"
#import "HNFeedViewController.h"

PostFilterType hnPostFilterType;
static int CELL_HEIGHT = 85;
static NSString *CellIdentifier = @"HNFeedCell";

@interface HNFeedViewController () <TNFeedViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) TNEmptyStateView *emptyStateView;

@end

@implementation HNFeedViewController

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.emptyStateView = [TNEmptyStateView new];
        hnPostFilterType = PostFilterTypeTop;
        [self addReachabilitykCheck];
    }

    return self;
}

- (instancetype)initWithPostFilterType:(PostFilterType)type
{
    self = [super init];

    if (self) {
        self.emptyStateView = [TNEmptyStateView new];
        hnPostFilterType = type;
        [self addReachabilitykCheck];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupRefreshControl];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self setFeedType:@(TNTypeHackerNews)];

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

    [self.emptyStateView setFrame:self.view.bounds];
    [self.view addSubview:self.emptyStateView];
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
    [cell setGestureDelegate:self];
	[cell setFrameHeight:CELL_HEIGHT];
	[cell setFeedType:TNTypeHackerNews];
    [cell configureForPost:post];

    if ([[HNManager sharedManager] userIsLoggedIn]) [cell addUpvoteGesture];

    [cell addViewCommentsGesture];
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

    [postViewController setDismissAction:^{ [self.navigationController popViewControllerAnimated:YES]; }];

    [self.navigationController pushViewController:postViewController animated:YES];
}

#pragma mark - TNFeedView Delegate

- (void)upvoteActionForCell:(TNFeedViewCell *)cell
{
    HNFeedViewCell *hnCell = (HNFeedViewCell *)cell;
    TNNotification *notification = [[TNNotification alloc] init];
    BOOL hasVoted = [[HNManager sharedManager] hasVotedOnObject:[hnCell post]];

    if (hasVoted) {

        [notification showFailureNotification:@"Post Upvote Failed" subtitle:@"You can only upvote a post once."];

    } else {

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

        [[HNManager sharedManager] voteOnPostOrComment:[hnCell post] direction:VoteDirectionUp completion:^(BOOL success){
            if (success) {

                [notification showSuccessNotification:@"Post Upvote Successful" subtitle:nil];
                [[HNManager sharedManager] addHNObjectToVotedOnDictionary:[hnCell post] direction:VoteDirectionUp];
                [hnCell incrementVoteCount];

            } else {

                [notification showFailureNotification:@"Network Error." subtitle:@"Check your internet connection."];
            }

            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
}

- (void)viewCommentsActionForCell:(TNFeedViewCell *)cell
{
    HNFeedViewCell *hnCell = (HNFeedViewCell *)cell;
    [self showCommentsForPost:[hnCell post]];
}

#pragma mark - Network Methods

- (void)downloadPosts
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[HNManager sharedManager] loadPostsWithFilter:hnPostFilterType completion:^(NSArray *posts){

        if (posts) {

            [self.posts removeAllObjects];
            [self.posts addObjectsFromArray:posts];
            [self.feedView reloadData];

            // Only remove if it exists
            if (self.emptyStateView) {
                [self removeEmptyState];
            }

            // scroll to top
            [self.feedView setContentOffset:CGPointZero animated:YES];

        } else {

            NSLog(@"Error Occured");
            [self.emptyStateView showErrorWithText:@"HN MIGHT BE DOWN :("];
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[self.feedView pullToRefreshView] stopAnimating];
    }];
}

- (void)downloadEvenMorePosts
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    [[HNManager sharedManager] loadPostsWithUrlAddition:[[HNManager sharedManager] postUrlAddition] completion:^(NSArray *posts){
        if (posts && posts.count > 0) {

            [self.posts addObjectsFromArray:posts];
            [self.feedView reloadData];

        } else {

            NSLog(@"Error Occured");
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[self.feedView infiniteScrollingView] stopAnimating];
    }];
}

#pragma mark - Network Reachablity Methods

- (void)addReachabilitykCheck
{
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];

    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emptyStateView showDownloadingText];
            [self downloadPosts];
        });
    };

    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emptyStateView showErrorWithText:@"NO INTERNET CONNECTION"];
            NSLog(@"No Internet Connection");
        });
    };

    [reach startNotifier];
}

#pragma mark - Private Methods

- (void)showCommentsForPost:(HNPost *)post
{
    HNCommentsViewController *vc = [[HNCommentsViewController alloc] initWithPost:post];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupRefreshControl
{
    __block HNFeedViewController *blockSelf = self;

    [self.feedView addPullToRefreshWithActionHandler:^{
        [blockSelf downloadPosts];
    }];

    [self.feedView addInfiniteScrollingWithActionHandler:^{
        [blockSelf downloadEvenMorePosts];
    }];

    TNRefreshView *pulling = [[TNRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) state:TNRefreshStatePulling];
    TNRefreshView *loading = [[TNRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) state:TNRefreshStateLoading];
    
    [[self.feedView pullToRefreshView] setCustomView:pulling forState:SVPullToRefreshStateAll];
    [[self.feedView pullToRefreshView] setCustomView:loading forState:SVPullToRefreshStateLoading];
}

- (void)removeEmptyState
{
    [self.feedView setAlpha:0.0];
    [self.view addSubview:self.feedView];

    [UIView animateWithDuration:0.5 animations:^{
        [self.emptyStateView setAlpha:0.0];
        [self.feedView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self.emptyStateView removeFromSuperview];
        self.emptyStateView = nil;
    }];
}

- (void)setPostFilterType:(int)type
{
    hnPostFilterType = type;
    [self downloadPosts];
}

@end