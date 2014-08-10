//
//  PHFeedViewController.m
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHManager.h"
#import "PHProduct.h"
#import "Reachability.h"

#import "TNRefreshView.h"
#import "TNNotification.h"
#import "PHFeedViewCell.h"
#import "TNEmptyStateView.h"

#import "SVPullToRefresh.h"
#import "TNPostViewController.h"
#import "PHCommentsViewController.h"
#import "PHFeedViewController.h"

static int CELL_HEIGHT = 85;
static NSString *CellIdentifier = @"PHFeedCell";

@interface PHFeedViewController () <UITableViewDelegate, UITableViewDataSource, TNFeedViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) TNEmptyStateView *emptyStateView;
@property (nonatomic, strong) NSString *emptyStateText;

@end

@implementation PHFeedViewController

- (instancetype)init
{
    self = [super init];

    if (self) {

        self.emptyStateView = [TNEmptyStateView new];
        [self addReachabilitykCheck];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self setFeedType:@(TNTypeProductHunt)];

    self.products = [[NSMutableArray alloc] init];

	CGFloat navBarHeight = 64.0;
	CGSize screenSize = self.view.frame.size;
    CGRect contentViewFrame = CGRectMake(0, navBarHeight, screenSize.width, screenSize.height - navBarHeight);

	self.feedView = [[UITableView alloc] initWithFrame:contentViewFrame];
	[self.feedView setDelegate:self];
	[self.feedView setDataSource:self];
	[self.feedView setSeparatorInset:UIEdgeInsetsZero];
	[self.feedView setSeparatorColor:[UIColor tnLightGreyColor]];
	[self.feedView registerClass:[PHFeedViewCell class] forCellReuseIdentifier:CellIdentifier];

    [self.emptyStateView setFrame:self.view.bounds];
    [self.view addSubview:self.emptyStateView];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PHFeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    PHProduct *product = (self.products)[[indexPath row]];

	[cell setForReuse];
	[cell setFrameHeight:CELL_HEIGHT];
    [cell setGestureDelegate:self];
    [cell configureForProduct:product];
    [cell addViewCommentsGesture];

    [cell setSeparatorInset:UIEdgeInsetsZero];

    if ([[PHManager sharedManager] hasUserReadStory:[product id]]) {
        [[cell contentView] setAlpha:0.6];
    }
    return cell;
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHProduct *product = (self.products)[[indexPath row]];
    [[PHManager sharedManager] addStoryToReadList:[product id]];

    TNPostViewController *postViewController = [[TNPostViewController alloc] initWithURL:[NSURL URLWithString:[product redirectURL]] type:TNTypeProductHunt];

    __weak PHFeedViewController *weakSelf = self;
    [postViewController setDismissAction:^{ [weakSelf.navigationController popViewControllerAnimated:YES]; }];

    [self.navigationController pushViewController:postViewController animated:YES];

    UITableViewCell *cell = [self.feedView cellForRowAtIndexPath:indexPath];
    [[cell contentView] setAlpha:0.6];
}

#pragma mark - TNFeedView Delegate

- (void)viewCommentsActionForCell:(TNFeedViewCell *)cell
{
    PHFeedViewCell *phcell = (PHFeedViewCell *)cell;
    PHCommentsViewController *vc = [[PHCommentsViewController alloc] initWithProduct:[phcell product]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Network Methods

- (void)downloadProducts {

    [[PHManager sharedManager] getTodaysProductsWithSuccess:^(NSArray *products) {

        [self.products removeAllObjects];
        [self.products addObjectsFromArray:products];
        [self.feedView.pullToRefreshView stopAnimating];

        if (self.emptyStateView) {
            [self removeEmptyState];
        }

        [self.feedView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"PHProucts for today could not be downloaded");

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
            [self downloadProducts];
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
    __block PHFeedViewController *blockSelf = self;

    [self.feedView addPullToRefreshWithActionHandler:^{
        [blockSelf downloadProducts];
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

@end
