//
//  TNFeedViewController.m
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "Post.h"
#import "CRToast.h"
#import "TNFeedViewCell.h"
#import "UIColor+TNColors.h"
#import "TNPostViewController.h"
#import "TNFeedViewController.h"

static int CELL_HEIGHT = 70;
static int NUMBER_OF_POSTS_TO_DOWNLOAD = 10;
static NSString *CellIdentifier = @"TNFeedCell";

@interface TNFeedViewController ()

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) UITableView *feedView;

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *createPostButton;

@end

@implementation TNFeedViewController

- (id)initWithType:(TNType)type
{
	self = [super init];

	if (self) {

		self.feedType = [NSNumber numberWithInt:type];
		self.posts = [NSMutableArray array];
        [self downloadPosts];
	}

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

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
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TNFeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	[cell setForReuse];
	[cell setFrameHeight:CELL_HEIGHT];
	[cell setFeedType:[self.feedType intValue]];
    [cell configureForPost:[self.posts objectAtIndex:[indexPath row]]];

    [self addSwipeGesturesToCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [self.posts objectAtIndex:[indexPath row]];
    TNPostViewController *postViewController = [[TNPostViewController alloc] initWithURL:[NSURL URLWithString:[post link]]];

    __weak TNFeedViewController *weakSelf = self;
    [postViewController setDismissAction:^{ [weakSelf.navigationController popViewControllerAnimated:YES]; }];

    [self.navigationController pushViewController:postViewController animated:YES];
}

#pragma mark - Data Methods

- (void)downloadPosts {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	    NSURL *dataURL = [[NSURL alloc] init];

	    switch ([self.feedType intValue]) {
			case TNTypeDesignerNews:
				dataURL = [NSURL URLWithString:@"http://thenews-api.herokuapp.com/top/dn"];
				break;

			case TNTypeHackerNews:
				dataURL = [NSURL URLWithString:@"http://thenews-api.herokuapp.com/top/hn"];
				break;
		}

	    NSData *responseData = [[NSData alloc] initWithContentsOfURL:dataURL];
	    [self performSelectorOnMainThread:@selector(storeData:) withObject:responseData waitUntilDone:YES];
	});
}

- (void)storeData:(NSData *)responseData {
	int index = 1;
	NSError *error;
	NSDictionary *posts = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

	for (NSDictionary *collection in posts) {
		Post *post = [[Post alloc] init];
		[post setAuthor:[collection objectForKey:@"author"]];
		[post setAuthorLink:[collection objectForKey:@"authorLink"]];
		[post setComments:[collection objectForKey:@"comments"]];
		[post setCommentsLink:[collection objectForKey:@"commentsLink"]];
		[post setCreatedAt:[collection objectForKey:@"createdAt"]];
		[post setLink:[collection objectForKey:@"link"]];
		[post setPoints:[collection objectForKey:@"points"]];
		[post setPosition:[collection objectForKey:@"position"]];
		[post setSource:[collection objectForKey:@"source"]];
		[post setTitle:[collection objectForKey:@"title"]];
		[post setUpdatedAt:[collection objectForKey:@"updatedAt"]];

		[self.posts addObject:post];
		if (index++ == NUMBER_OF_POSTS_TO_DOWNLOAD) break;
	}

	[self.feedView reloadData];
}

#pragma mark - Gesture Methods

- (void)addSwipeGesturesToCell:(TNFeedViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIView *commentView = [self viewWithImageName:@"Comment"];
    UIView *upvoteView = [self viewWithImageName:@"Upvote"];

    [cell setDefaultColor:[UIColor tnLightGreyColor]];

    [cell setSwipeGestureWithView:upvoteView color:[UIColor tnLightGreenColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self upvotePost];
    }];

    [cell setSwipeGestureWithView:commentView color:[UIColor dnColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self showCommentView];
    }];
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

#pragma mark - Notification Methods

- (NSDictionary *)defaultNotificationOptions
{
    NSDictionary *options = @{
                              kCRToastTextKey : @"Post Upvote Successful",
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastSubtitleTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastFontKey : [UIFont fontWithName:@"Avenir-Light" size:14],
                              kCRToastSubtitleFontKey : [UIFont fontWithName:@"Avenir-Light" size:9],
                              kCRToastBackgroundColorKey : [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationPresentationTypeKey : @(YES),
                              kCRToastNotificationTypeKey : @(YES),
                              kCRToastUnderStatusBarKey: @(NO),
                              kCRToastStatusBarStyle : @(UIStatusBarStyleLightContent),
                              kCRToastImageKey : [UIImage imageNamed:@"Checkmark"]
                              };
    return options;
}

- (void)showNotification
{
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:[self defaultNotificationOptions]];

    if (rand() % 2) {
        // Upvote Failed
        options[kCRToastTextKey] = @"Post Upvote Failed";
        options[kCRToastSubtitleTextKey] = @"Authentication Error";
        options[kCRToastImageKey] = [UIImage imageNamed:@"Error"];
        options[kCRToastBackgroundColorKey] = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1];
    }

    [CRToastManager showNotificationWithOptions:options completionBlock:^{}];
}

#pragma mark - Private Methods

- (void)upvotePost
{
    [self showNotification];
}

- (void)showCommentView
{
    NSLog(@"CommentViewShown");
}

- (void)dismissPostView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end