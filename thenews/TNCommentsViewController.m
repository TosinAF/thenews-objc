//
//  TNCommentsViewController.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNCommentsViewController.h"
#import "TNCommentCell.h"
#import "MCSwipeTableViewCell.h"

@interface TNCommentsViewController ()

@end

@implementation TNCommentsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.api = [[DesignerNewsAPIClient alloc] init];
    self.commentsData = [[NSArray alloc] init];
    self.title = @"Comments";
    
    switch ([self.network intValue]) {
        case TNTypeDesignerNews: {
            [self.api getCommentsForStoryWithID:[NSString stringWithFormat:@"%d", self.storyID]
                                        success:^(NSArray *comments) {
                                            self.commentsData = comments;
                                            [self.tableView reloadData];
                                        }
                                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                                            NSLog(@"The task: %@ failed with error: %@", task, error);
                                        }];
        }
            break;
        case TNTypeHackerNews: {
            // get hacker news posts
        }
            break;
    }
    
    self.keyboardView = [[RDRStickyKeyboardView alloc] initWithScrollView:self.tableView];
    self.keyboardView.frame = self.view.bounds;
    [self.keyboardView.inputView.rightButton addTarget:self action:@selector(postButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.keyboardView.inputView.textView.text = @"Testing the API. If anyone sees this, you are probably playing with the API as well so please excuse me if the comment is posted multipul times on accident.";
    self.keyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
#warning The next line (commented) causes an EXC_BAD_ACCESS errror for an unknown reason. I contacted the original developer for help. Until then, I implemented everything as if it worked. For example calling [button sendActionsForControlEvents:UIControlEventTouchUpInside]; will act as if send was clicked. The text for the comment will be "test" as set above but removing that line will cause it to work normally and will take the value from the text field.
    //  [self.view addSubview:keyboardView];
# warning The next lines should be removed as well once keyboard works.
    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Simulate Direct"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(postButtonAction:)];
    commentButton.tag = 6;
    self.navigationItem.rightBarButtonItem = commentButton;
    UIColor *navBarColor;
    switch ([self.network intValue]) {
        case TNTypeDesignerNews:
            navBarColor = [UIColor dnColor];
            break;
            
        case TNTypeHackerNews:
            navBarColor = [UIColor hnColor];
            break;
    }
    [self.navigationController.navigationBar setBarTintColor:navBarColor];
	[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
	[self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:16.0f],
	                                       NSForegroundColorAttributeName:[UIColor whiteColor] }];
}

- (void)postButtonAction:(id)sender {
    if ([sender tag] == 6) self.replyToID = nil; // This line is associated with the simulation button only.
    NSLog(@"%@", self.keyboardView.inputView.textView.text);
    [self postComment:self.keyboardView.inputView.textView.text inReplyTo:self.replyToID];
    [self.tableView reloadData];
}

- (void)postComment:(NSString *)comment inReplyTo:(NSNumber *)originalCommentID {
    if (originalCommentID == nil) {
        NSLog(@"Replying to original story");
        [self.api replyStoryWithID:[NSString stringWithFormat:@"%d", self.storyID] comment:comment
                           success:^{
                               // This would be a good time to give feedback via the nav bar or something
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *error){
                               // cries
                           }];
    } else {
        NSLog(@"Replying to comment.");
        [self.api replyCommentWithID:[NSString stringWithFormat:@"%d", self.storyID] comment:comment
                             success:^{
                                 // Yay! How should we say how awesome there comment was posted?
                             }
                             failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 // This is bad.
                             }];
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.commentsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TNCommentCell *cell = [[TNCommentCell alloc] init];
    if (!cell) {
        cell = [[TNCommentCell alloc] init];
        
        // Remove inset of iOS 7 separators.
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Setting the background color of the cell.
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    DNComment *comment = [self.commentsData objectAtIndex:[indexPath row]];
    cell.commentTextView.text = comment.body;
    cell.commentAuthorLabel.text = [NSString stringWithFormat:@"%@ Points by %@", comment.voteCount, comment.author];
    UIView *replyView = [self viewWithImageName:@"Comment"];
    UIView *upvoteView = [self viewWithImageName:@"Upvote"];
    UIColor *tealColor = [UIColor colorWithRed:0.631 green:0.890 blue:0.812 alpha:1];
    UIColor *networkColor;
    switch ([self.network intValue]) {
        case TNTypeDesignerNews:
            networkColor = [UIColor dnColor];
            break;
        case TNTypeHackerNews:
            networkColor = [UIColor hnColor];
            break;
    }
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    [cell.textLabel setText:@"Switch Mode Cell"];
    [cell.detailTextLabel setText:@"Swipe to switch"];
    
    // Adding gestures per state basis.
    [cell setSwipeGestureWithView:replyView color:networkColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        self.replyToID = [NSNumber numberWithInt:[indexPath row]];
        [self.keyboardView.inputView.textView becomeFirstResponder];
#warning The next line simulates clicking the comment button. Remove this once the text view works.
        [self.keyboardView.inputView.rightButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [cell setSwipeGestureWithView:upvoteView color:tealColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self.api upvoteCommentWithID:comment.commentID
                              success:^{
                                  [self.tableView reloadData];
                              }
                              failure:^(NSURLSessionDataTask *task, NSError *error){
                                  //comment not upvoted
                              }];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning Insert dynamic height code here ;)
    return 200;
}

#pragma mark - MCSwipeTableView

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}
@end
