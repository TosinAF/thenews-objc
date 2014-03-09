//
//  TNFeedViewController.m
//  The News
//
//  Created by Tosin Afolabi on 06/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "Post.h"
#import "TNFeedViewCell.h"
#import "UIColor+TNColors.h"
#import "TNPostViewController.h"
#import "TNFeedViewController.h"

static int CELL_HEIGHT = 70;
static int NUMBER_OF_POSTS_TO_DOWNLOAD = 10;
static NSString *CellIdentifier = @"TNFeedCell";

@interface TNFeedViewController ()

@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) UIColor *navbarColor;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UINavigationItem *navItem;

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) UITableView *feedView;

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *createPostButton;

@end

@implementation TNFeedViewController

- (id)initWithFeedType:(TNFeedType)type {
	self = [super init];
	if (self) {
		self.feedType = [NSNumber numberWithInt:type];
		self.posts = [NSMutableArray array];

		switch (type) {
			case TNFeedTypeDesignerNews:
				self.navTitle = @"DESIGNER NEWS";
				self.navbarColor = [UIColor dnColor];
				break;

			case TNFeedTypeHackerNews:
				self.navTitle = @"HACKER NEWS";
				self.navbarColor = [UIColor hnColor];
				break;
		}
        
        [self downloadPosts];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self configureNavbarApperance];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPostView) name:@"dismissPostView" object:nil];

	/* Set Up Navigation Bar */

	CGFloat navBarHeight = 64.0;
	CGSize screenSize = self.view.frame.size;

	self.navBar = [[GTScrollNavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, navBarHeight)];
	self.navItem = [[UINavigationItem alloc] initWithTitle:self.navTitle];

	[self configureNavbarApperance];

	self.menuButton = ({
       UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [menuButton setFrame:CGRectMake(0, 0, 30, 30)];
       [menuButton setTitle:@"\u2630" forState:UIControlStateNormal];
       [menuButton.titleLabel setFont:[UIFont fontWithName:@"Entypo" size:50]];
       [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       menuButton;
   });

	self.createPostButton = ({
         UIButton *createPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [createPostButton setFrame:CGRectMake(0, 0, 30, 30)];
         [createPostButton setTitle:@"\u2795" forState:UIControlStateNormal];
         [createPostButton.titleLabel setFont:[UIFont fontWithName:@"Entypo" size:50]];
         [createPostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         createPostButton;
     });

	self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
	self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.createPostButton];
	[self.navBar pushNavigationItem:self.navItem animated:NO];

	/* Set up TableView */

	CGFloat contentViewHeight = screenSize.height - navBarHeight;
	self.feedView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight, screenSize.width, contentViewHeight)];

	[self.feedView setDelegate:self];
	[self.feedView setDataSource:self];
	[self.feedView setSeparatorInset:UIEdgeInsetsZero];
	[self.feedView setSeparatorColor:[UIColor tnLightGreyColor]];
	[self.feedView registerClass:[TNFeedViewCell class] forCellReuseIdentifier:CellIdentifier];

	[self.view addSubview:self.navBar];
	[self.view addSubview:self.feedView];
}

#pragma mark - Table view data source

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

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [self.posts objectAtIndex:[indexPath row]];
    TNPostViewController *postViewController = [[TNPostViewController alloc] initWithURL:[NSURL URLWithString:[post link]]];
    [self.navigationController pushViewController:postViewController animated:YES];
}


#pragma mark - Data Methods

- (void)downloadPosts {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	    NSURL *dataURL = [[NSURL alloc] init];

	    switch ([self.feedType intValue]) {
			case TNFeedTypeDesignerNews:
				dataURL = [NSURL URLWithString:@"http://thenews-api.herokuapp.com/top/dn"];
				break;

			case TNFeedTypeHackerNews:
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

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)configureNavbarApperance
{
    [self.navBar setBarTintColor:self.navbarColor];
	[self.navBar setTintColor:[UIColor whiteColor]];
	[self.navBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:16.0f],
	                                       NSForegroundColorAttributeName:[UIColor whiteColor] }];
}


- (void)dismissPostView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissPostWebView" object:nil];
}

@end
