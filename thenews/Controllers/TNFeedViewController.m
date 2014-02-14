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
#import "TNFeedViewController.h"

static int CELL_HEIGHT = 70;
static NSString *CellIdentifier = @"TNFeedCell";

@interface TNFeedViewController ()


@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) UIColor *navbarColor;
@property (nonatomic, strong) UINavigationBar *navigationBar;

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) UITableView *feedView;

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *createPostButton;

@end

@implementation TNFeedViewController

- (id)initWithFeedType:(TNFeedType)type
{
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
	}
	return self;
}

- (void)viewDidLoad {

	[super viewDidLoad];
	[self downloadPosts];

	/* Set Up Navigation Bar */

    CGFloat navBarHeight = 64.0;
    CGSize screenSize = self.view.frame.size;

    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, navBarHeight)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:self.navTitle];

    //[UIApplication sharedApplication].statusBarFrame.size = 7;

    [self.navigationBar setBarTintColor:self.navbarColor];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:16.0f],
                                                    NSForegroundColorAttributeName:[UIColor whiteColor] }];

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

    navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.createPostButton];
    [self.navigationBar pushNavigationItem:navigationItem animated:NO];

    /* Set up TableView */

    CGFloat contentViewHeight = screenSize.height - navBarHeight;
    self.feedView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight, screenSize.width, contentViewHeight)];

    [self.feedView setDelegate:self];
    [self.feedView setDataSource:self];
    [self.feedView setSeparatorInset:UIEdgeInsetsZero];
    [self.feedView setSeparatorColor:[UIColor tnLightGreyColor]];
	[self.feedView registerClass:[TNFeedViewCell class] forCellReuseIdentifier:CellIdentifier];

    [self.view addSubview:self.navigationBar];
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
	Post *post = [self.posts objectAtIndex:[indexPath row]];
	TNFeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	[cell setForReuse];
	[cell setFrameHeight:CELL_HEIGHT];
	[cell setFeedType:[self.feedType intValue]];
	[cell setTitle:[post title] author:[post author] points:[post points] index:[post position] commentCount:[post comments]];

	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return CELL_HEIGHT;
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
	int index = 0;
	NSError *error;
	NSDictionary *posts = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];

	NSLog(@"%@", posts);

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
		if (index++ == 9) break;
	}

	[self.feedView reloadData];
}

@end
