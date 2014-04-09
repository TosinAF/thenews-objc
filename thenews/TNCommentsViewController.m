//
//  TNCommentsViewController.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNHeaderView.h"
#import "TNCommentCell.h"
#import "RDRStickyKeyboardView.h"
#import "TNCommentsViewController.h"

DNManager *DNClient;

@interface TNCommentsViewController ()

@property (nonatomic, strong) NSNumber *storyID;
@property (nonatomic, strong) UIColor *navbarColor;

@property (nonatomic, strong) DNStory *story;
@property (nonatomic,   copy) NSArray *comments;
@property (nonatomic, strong) UITableView *commentsView;

@property (nonatomic, strong) RDRStickyKeyboardView *keyboardView;

@end

@implementation TNCommentsViewController

- (instancetype)initWithType:(TNType)type story:(DNStory *)story
{
    self = [super init];

    if (self) {

        switch (type) {
            case TNTypeDesignerNews:
                self.title = @"DESIGNER NEWS";
                self.navbarColor = [UIColor dnColor];
                self.storyID = [story storyID];
                break;

            case TNTypeHackerNews:
                self.title = @"HACKER NEWS";
                self.navbarColor = [UIColor hnColor];
                break;
        }

        self.story = story;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavbar];

    DNClient = [DNManager sharedClient];
    self.comments = [[NSArray alloc] init];
    [self downloadComments];

    /* Set up Comments Table View */

    self.commentsView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.commentsView setDelegate:self];
    [self.commentsView setDataSource:self];
    [self.commentsView setSeparatorColor:[UIColor tnLightGreyColor]];

    [self.view addSubview:self.commentsView];

    /* Set Up Sticky Keyboard */

    [self configureKeyboard];

    /* Set Up Table Header View */

    TNHeaderView *headerView = [[TNHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 85) type:TNTypeDesignerNews];
    [headerView configureForStory:self.story];

    [self.commentsView setTableHeaderView:headerView];

    /* Add Table View Bottom Border */

    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, self.commentsView.tableHeaderView.bounds.origin.y + 85, self.view.bounds.size.width, 2)];
    [border setBackgroundColor:[UIColor tnLightGreyColor]];

    [self.commentsView addSubview:border];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TNCommentCell *cell = [[TNCommentCell alloc] init];

    if (!cell) {
        cell = [[TNCommentCell alloc] init];
    }

    DNComment *comment = [self.comments objectAtIndex:[indexPath row]];
    [cell configureForComment:comment];
    [cell addSwipeGesturesToCell];

    [cell setUpvoteBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        //DNFeedViewCell *dncell = (DNFeedViewCell *)cell;
        //DNStory *story = [dncell story];
        //[self upvoteStoryWithID:[story storyID]];

        NSLog(@"upvote");

    }];

    [cell setCommentBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {

        //DNFeedViewCell *dncell = (DNFeedViewCell *)cell;
        //DNStory *story = [dncell story];
        //[self showCommentsForStory:story];

        NSLog(@"comment");
    }];


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TNCommentCell *cell = [[TNCommentCell alloc] init];
    CGFloat height = [cell estimateHeightWithComment:self.comments[[indexPath row]]];

    return height;
}

#pragma mark - Network Methods

- (void)postButtonAction:(id)sender {
    NSLog(@"%@", self.keyboardView.inputView.textView.text);
    [self postComment:self.keyboardView.inputView.textView.text inReplyTo:self.replyToID];
    [self downloadComments];
}

- (void)postComment:(NSString *)comment inReplyTo:(NSNumber *)originalCommentID {

    if (originalCommentID) {

        [DNClient replyCommentWithID:[self.storyID stringValue] comment:comment success:^{

            [self downloadComments];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString *errorMsg = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
            NSLog(@"%@", errorMsg);
        }];

    } else {

        [DNClient replyStoryWithID:[self.storyID stringValue] comment:comment success:^{

            [self downloadComments];

        } failure:^(NSURLSessionDataTask *task, NSError *error){
            NSString *errorMsg = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
            NSLog(@"%@", errorMsg);
        }];
    }

}

- (void)downloadComments {

    [DNClient getCommentsForStoryWithID:[self.storyID stringValue] success:^(NSArray *comments) {

        self.comments = comments;
        [self.commentsView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"The task: %@ failed with error: %@", task, error);
        
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Private Methods

- (void)configureNavbar
{
    [self.navigationController.navigationBar setBarTintColor:self.navbarColor];
	[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
	[self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:16.0f],
                                                                       NSForegroundColorAttributeName:[UIColor whiteColor] }];
}

- (void)configureKeyboard
{
    self.keyboardView = [[RDRStickyKeyboardView alloc] initWithScrollView:self.commentsView];

    [self.keyboardView setFrame:self.view.bounds];
    [self.keyboardView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];

    [self.keyboardView.inputView.leftButton removeFromSuperview];
    [self.keyboardView.inputView.textView setDelegate:self];

    //[self.keyboardView.inputView.leftButton setTitle:NSLocalizedString(@"↳", nil) forState:UIControlStateNormal];
    [self.keyboardView.inputView.rightButton addTarget:self action:@selector(postButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.keyboardView];
}

- (void)cancelReply {
    self.replyToID = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
}

@end
