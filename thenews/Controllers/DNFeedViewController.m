//
//  DNFeedViewController.m
//  The News
//
//  Created by Tosin Afolabi on 25/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNRefreshView.h"
#import "TNNotification.h"
#import "TNFeedViewCell.h"
#import "SVPullToRefresh.h"
#import "TNPostViewController.h"
#import "DNFeedViewController.h"
#import "DesignerNewsAPIClient.h"


static int CELL_HEIGHT = 70;
static NSString *CellIdentifier = @"TNFeedCell";

DesignerNewsAPIClient *DNClient;

@interface DNFeedViewController () 

@property (nonatomic, strong) NSMutableArray *stories;
@property (nonatomic, strong) UITableView *feedView;

@end

@implementation DNFeedViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self setFeedType:TNTypeDesignerNews];

    self.stories = [[NSMutableArray alloc] init];
    DNClient = [DesignerNewsAPIClient sharedClient];
    [self downloadFeedAndReset:NO];

	CGFloat navBarHeight = 64.0;
	CGSize screenSize = self.view.frame.size;
    CGRect contentViewFrame = CGRectMake(0, navBarHeight, screenSize.width, screenSize.height - navBarHeight);

	self.feedView = [[UITableView alloc] initWithFrame:contentViewFrame];
	[self.feedView setDelegate:self];
	[self.feedView setDataSource:self];
	[self.feedView setSeparatorInset:UIEdgeInsetsZero];
	[self.feedView setSeparatorColor:[UIColor tnLightGreyColor]];
	[self.feedView registerClass:[TNFeedViewCell class] forCellReuseIdentifier:CellIdentifier];

	[self.view addSubview:self.feedView];
    [self setupRefreshControl];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TNFeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    DNStory *story = (self.stories)[[indexPath row]];

	[cell setForReuse];
	[cell setFrameHeight:CELL_HEIGHT];
	[cell setFeedType:TNTypeDesignerNews];
    [cell configureForStory:story index:(int)[indexPath row] + 1];

    [cell setUpvoteBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        TNFeedViewCell *tncell = (TNFeedViewCell *)cell;
        DNStory *story = [tncell story];
        [self upvoteStoryWithID:[story storyID]];

    }];

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
    DNStory *story = (self.stories)[[indexPath row]];
    TNPostViewController *postViewController = [[TNPostViewController alloc] initWithURL:[NSURL URLWithString:[story URL]] type:TNTypeDesignerNews];

    __weak DNFeedViewController *weakSelf = self;
    [postViewController setDismissAction:^{ [weakSelf.navigationController popViewControllerAnimated:YES]; }];

    [self.navigationController pushViewController:postViewController animated:YES];
}

#pragma mark - Network Methods

- (void)downloadFeedAndReset:(BOOL)reset
{
    static int page = 0;

    if(reset) {
        page = 0;
    }

    page++;

    [DNClient getStoriesOnPage:[NSString stringWithFormat:@"%d", page] feedType:DNFeedTypeTop success:^(NSArray *dnStories) {

        if (reset) {
            [self.stories removeAllObjects];
        }

        [self.stories addObjectsFromArray:dnStories];
        [self.feedView reloadData];
        [self.feedView.pullToRefreshView stopAnimating];
        [self.feedView.pullToRefreshView stopAnimating];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"%@", [[error userInfo] objectForKey:@"NSLocalizedDescription"]);

    }];
}

- (void)upvoteStoryWithID:(NSNumber *)storyID
{
    TNNotification *notification = [[TNNotification alloc] init];

    [DNClient upvoteStoryWithID:[storyID stringValue] success:^{

        [notification showSuccessNotification:@"Story Upvote Successful" subtitle:nil];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        //NSString *errorMsg = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
        [notification showFailureNotification:@"Story Upvote Failed" subtitle:@"You can only upvote a story once."];

    }];
}

- (void)showCommentView
{
    NSLog(@"CommentViewShown");
}

#pragma mark - Private Methods

- (void)setupRefreshControl
{

    /* Pull To Refresh & Infinite Scrolling */

    __weak DNFeedViewController *weakself = self;

    [self.feedView addPullToRefreshWithActionHandler:^{
        [weakself downloadFeedAndReset:YES];
    }];

    [self.feedView addInfiniteScrollingWithActionHandler:^{
        [weakself downloadFeedAndReset:NO];
    }];

    TNRefreshView *pulling = [[TNRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) state:TNRefreshStatePulling];
    TNRefreshView *loading = [[TNRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 60) state:TNRefreshStateLoading];

    [[self.feedView pullToRefreshView] setCustomView:loading forState:SVPullToRefreshStateAll];
    [[self.feedView pullToRefreshView] setCustomView:pulling forState:SVPullToRefreshStateTriggered];
}

@end