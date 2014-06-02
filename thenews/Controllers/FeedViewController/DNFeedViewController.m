//
//  DNFeedViewController.m
//  The News
//
//  Created by Tosin Afolabi on 25/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//
//  This & HNFeed have a bunch of repeated code so beware
//  Right now, it's about getting the product out
//  If people like it so much, then i use that motivation to improve the codebase & add new features

#import "DNManager.h"
#import "Reachability.h"

#import "TNRefreshView.h"
#import "TNNotification.h"
#import "DNFeedViewCell.h"
#import "TNEmptyStateView.h"

#import "SVPullToRefresh.h"
#import "TNPostViewController.h"
#import "DNCommentsViewController.h"
#import "DNFeedViewController.h"

static int CELL_HEIGHT = 85;
static NSString *CellIdentifier = @"DNFeedCell";

@interface DNFeedViewController () <TNFeedViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *stories;
@property (nonatomic, strong) TNEmptyStateView *emptyStateView;
@property (nonatomic, strong) NSString *emptyStateText;
@property (nonatomic, strong) NSNumber *dnFeedType;

@end

@implementation DNFeedViewController

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.emptyStateView = [TNEmptyStateView new];
        [self addReachabilitykCheck];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self setFeedType:@(TNTypeDesignerNews)];

    self.dnFeedType = @(DNFeedTypeTop);

    self.stories = [[NSMutableArray alloc] init];

	CGFloat navBarHeight = 64.0;
	CGSize screenSize = self.view.frame.size;
    CGRect contentViewFrame = CGRectMake(0, navBarHeight, screenSize.width, screenSize.height - navBarHeight);

	self.feedView = [[UITableView alloc] initWithFrame:contentViewFrame];
	[self.feedView setDelegate:self];
	[self.feedView setDataSource:self];
	[self.feedView setSeparatorInset:UIEdgeInsetsZero];
	[self.feedView setSeparatorColor:[UIColor tnLightGreyColor]];
	[self.feedView registerClass:[DNFeedViewCell class] forCellReuseIdentifier:CellIdentifier];

    [self.emptyStateView setFrame:self.view.bounds];
    [self.view addSubview:self.emptyStateView];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DNFeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    DNStory *story = (self.stories)[[indexPath row]];

	[cell setForReuse];
	[cell setFrameHeight:CELL_HEIGHT];
    [cell setGestureDelegate:self];
    [cell configureForStory:story];

    if ([[DNManager sharedManager] isUserAuthenticated]) {

        [cell addUpvoteGesture];
    }

    [cell addViewCommentsGesture];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    return cell;
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNStory *story = (self.stories)[[indexPath row]];

    TNPostViewController *postViewController = [[TNPostViewController alloc] initWithURL:[NSURL URLWithString:[story URL]] type:TNTypeDesignerNews];

    __weak DNFeedViewController *weakSelf = self;
    [postViewController setDismissAction:^{ [weakSelf.navigationController popViewControllerAnimated:YES]; }];

    [self.navigationController pushViewController:postViewController animated:YES];
}

#pragma mark - TNFeedView Delegate

- (void)upvoteActionForCell:(TNFeedViewCell *)cell
{
    DNFeedViewCell *dncell = (DNFeedViewCell *)cell;
    DNStory *story = [dncell story];

    TNNotification *notification = [[TNNotification alloc] init];

    [[DNManager sharedManager] upvoteStoryWithID:[[story storyID] stringValue] success:^{

        [notification showSuccessNotification:@"Story Upvote Successful" subtitle:nil];
        [dncell incrementVoteCount];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [notification showFailureNotification:@"Story Upvote Failed" subtitle:@"You can only upvote a story once."];
        
    }];
}

- (void)viewCommentsActionForCell:(TNFeedViewCell *)cell
{
    DNFeedViewCell *dncell = (DNFeedViewCell *)cell;
    DNStory *story = [dncell story];
    [self showCommentsForStory:story];
}

#pragma mark - Network Methods

- (void)downloadFeedAndReset:(BOOL)reset
{
    static int page = 0;

    if(reset) {
        page = 0;
    }

    page++;

    [[DNManager sharedManager] getStoriesOnPage:[NSString stringWithFormat:@"%d", page] feedType:[self.dnFeedType intValue] success:^(NSArray *dnStories) {

        if (reset) {
            [self.stories removeAllObjects];
            [self.feedView.pullToRefreshView stopAnimating];

            // scroll to top
            [self.feedView setContentOffset:CGPointZero animated:YES];

        } else {

            [self.feedView.infiniteScrollingView stopAnimating];
        }

        [self.stories addObjectsFromArray:dnStories];
        [self.feedView reloadData];

        if (self.emptyStateView) {
            [self removeEmptyState];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        // maybe a tnnotification?
        NSLog(@"%@", [[error userInfo] objectForKey:@"NSLocalizedDescription"]);
        [self.emptyStateView.infoLabel setText:@"NO INTERNET CONNECTION :("];
        [self.feedView.pullToRefreshView stopAnimating];
        [self.feedView.infiniteScrollingView stopAnimating];
    }];
}

- (void)upvoteStoryWithID:(NSNumber *)storyID
{
    TNNotification *notification = [[TNNotification alloc] init];

    [[DNManager sharedManager] upvoteStoryWithID:[storyID stringValue] success:^{

        [notification showSuccessNotification:@"Story Upvote Successful" subtitle:nil];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [notification showFailureNotification:@"Story Upvote Failed" subtitle:@"You can only upvote a story once."];

    }];
}

- (void)showCommentsForStory:(DNStory *)story
{
    DNCommentsViewController *vc = [[DNCommentsViewController alloc] initWithStory:story];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Network Reachablity Methods

- (void)addReachabilitykCheck
{
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];

    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emptyStateView showDownloadingText];
            [self downloadFeedAndReset:YES];
        });
    };

    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emptyStateView showErrorText];
            NSLog(@"No Internet Connection");
        });
    };

    [reach startNotifier];
}

#pragma mark - Private Methods

- (void)setupRefreshControl
{
    __block DNFeedViewController *blockSelf = self;

    [self.feedView addPullToRefreshWithActionHandler:^{
        [blockSelf downloadFeedAndReset:YES];
    }];

    [self.feedView addInfiniteScrollingWithActionHandler:^{
        [blockSelf downloadFeedAndReset:NO];
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
    [self setupRefreshControl];

    [UIView animateWithDuration:0.5 animations:^{
        [self.emptyStateView setAlpha:0.0];
        [self.feedView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self.emptyStateView removeFromSuperview];
        self.emptyStateView = nil;
    }];
}

- (int)switchDNFeedType
{
    int type = [self.dnFeedType intValue];

    switch (type) {

        case DNFeedTypeTop:
            self.dnFeedType = @(DNFeedTypeRecent);
            break;

        case DNFeedTypeRecent:
            self.dnFeedType = @(DNFeedTypeTop);
            break;
    }

    [self downloadFeedAndReset:YES];
    return type;
}

@end