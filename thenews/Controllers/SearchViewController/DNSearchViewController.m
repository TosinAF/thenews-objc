//
//  DNSearchViewController.m
//  The News
//
//  Created by Tosin Afolabi on 23/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNManager.h"
#import "TNNotification.h"
#import "DNSearchViewCell.h"
#import "TNPostViewController.h"
#import "DNSearchViewController.h"
#import "DNCommentsSearchViewController.h"

static int CELL_HEIGHT = 85;
static NSString *CellIdentifier = @"DNSearchCell";

@interface DNSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, TNFeedViewCellDelegate>

@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DNSearchViewController

- (instancetype)initWithQuery:(NSString *)query
{
    self = [super init];

    if (self) {
        [self searchDNWithQuery:query];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScreenName:@"DNSearch"];

    // Search Bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    [self.searchBar setDelegate:self];

    [self.searchBar setTintColor:[UIColor dnColor]];
    // Set the tint color of cancel button to white
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    [self.searchBar setBarTintColor:[UIColor dnNavBarColor]];
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];

    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [[UIColor dnNavBarColor] CGColor];

    // Table View

	CGSize screenSize = self.view.frame.size;
    CGRect contentViewFrame = CGRectMake(0, 64, screenSize.width, screenSize.height - 64);

	self.tableView = [[UITableView alloc] initWithFrame:contentViewFrame];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];

    [self.tableView setContentOffset:CGPointMake(0,44)];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
	[self.tableView setSeparatorColor:[UIColor tnLightGreyColor]];
	[self.tableView registerClass:[DNSearchViewCell class] forCellReuseIdentifier:CellIdentifier];

    [self.tableView setTableHeaderView:self.searchBar];
    [self.view addSubview:self.tableView];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DNSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

    [postViewController setDismissAction:^{ [self.navigationController popViewControllerAnimated:YES]; }];

    [self.navigationController pushViewController:postViewController animated:YES];
}

#pragma mark - UISearchBar Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] != 0) {
        [[DNManager sharedManager] cancelAllRequests];
        [self searchDNWithQuery:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = [searchBar text];
    [[DNManager sharedManager] cancelAllRequests];
    [self searchDNWithQuery:searchText];
    [self.searchBar resignFirstResponder];

    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - Network Methods

- (void)searchDNWithQuery:(NSString *)query
{
    [[DNManager sharedManager] search:query success:^(NSArray *dnStories) {

        self.stories = dnStories;
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"%@", [[error userInfo] objectForKey:@"NSLocalizedDescription"]);
    }];
}

- (void)upvoteActionForCell:(TNFeedViewCell *)cell
{
    DNSearchViewCell *dncell = (DNSearchViewCell *)cell;
    DNStory *story = [dncell story];

    TNNotification *notification = [[TNNotification alloc] init];

    [[DNManager sharedManager] upvoteStoryWithID:[[story storyID] stringValue] success:^{

        [notification showSuccessNotification:@"Story Upvote Successful" subtitle:nil];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        [notification showFailureNotification:@"Story Upvote Failed" subtitle:@"You can only upvote a story once."];

    }];
}

- (void)viewCommentsActionForCell:(TNFeedViewCell *)cell
{
    DNSearchViewCell *dncell = (DNSearchViewCell *)cell;
    DNStory *story = [dncell story];

    DNCommentsSearchViewController *vc = [[DNCommentsSearchViewController alloc] initWithStory:story];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
