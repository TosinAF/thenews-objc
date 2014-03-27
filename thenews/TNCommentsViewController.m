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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.api = [[DesignerNewsAPIClient alloc] init];
    self.commentsData = [[NSArray alloc] init];
    self.title = @"Comments";
    
    [self updateTableData];

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
    NSLog(@"%@", self.keyboardView.inputView.textView.text);
    [self postComment:self.keyboardView.inputView.textView.text inReplyTo:self.replyToID];
    [self updateTableData];
}

- (void)postComment:(NSString *)comment inReplyTo:(NSNumber *)originalCommentID {
    if (originalCommentID == nil) {
        NSLog(@"Replying to original story");
        [self.api replyStoryWithID:[NSString stringWithFormat:@"%d", self.storyID] comment:comment
                           success:^{
                               [self updateTableData];
                           }
                           failure:^(NSURLSessionDataTask *task, NSError *error){
                               // cries
                           }];
    } else {
        NSLog(@"Replying to comment.");
        [self.api replyCommentWithID:[NSString stringWithFormat:@"%d", self.storyID] comment:comment
                             success:^{
                                 [self updateTableData];
                             }
                             failure:^(NSURLSessionDataTask *task, NSError *error) {
                                 // This is bad.
                             }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.keyboardView = [[RDRStickyKeyboardView alloc] initWithScrollView:self.tableView];
    self.keyboardView.frame = self.view.bounds;
    [self.keyboardView.inputView.rightButton addTarget:self action:@selector(postButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.keyboardView.inputView.leftButton.hidden = YES;
    self.keyboardView.inputView.textView.delegate = self;
    [self.keyboardView.inputView.leftButton setTitle:NSLocalizedString(@"↳", nil) forState:UIControlStateNormal];
    self.keyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.keyboardView];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTableData {
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
}

- (void)cancelReply {
    self.replyToID = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView :(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
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
    [cell.commentTextView  sizeToFit];
    
    // Moves the author label to under the text view
    int textViewHeight = cell.commentTextView.frame.size.height;
    CGRect authorLabelFrame = cell.commentAuthorLabel.frame;
    authorLabelFrame.origin.y = 10 + textViewHeight + 5;
    cell.commentAuthorLabel.frame = authorLabelFrame;
    
    cell.commentAuthorLabel.text = [NSString stringWithFormat:@"%@ Votes by %@", comment.voteCount, comment.author];
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
    
    // Adding gestures per state basis.
    [cell setSwipeGestureWithView:replyView color:networkColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        self.replyToID = [NSNumber numberWithInteger:[indexPath row]];
        UIBarButtonItem *commentButton = [[UIBarButtonItem alloc]
                                          initWithTitle:@"Cancel Reply"
                                          style:UIBarButtonItemStyleBordered
                                          target:self
                                          action:@selector(cancelReply)];
        self.navigationItem.rightBarButtonItem = commentButton;
            }];
    
    [cell setSwipeGestureWithView:upvoteView color:tealColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        [self.api upvoteCommentWithID:[NSString stringWithFormat:@"%@", comment.commentID]
                              success:^{
                                  [self updateTableData];
                              }
                              failure:^(NSURLSessionDataTask *task, NSError *error){
                                  //comment not upvoted
                              }];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TNCommentCell *cell = [[TNCommentCell alloc] init];
    DNComment *comment = [self.commentsData objectAtIndex:[indexPath row]];
    
    // First lets get the main text view height
    cell.commentTextView.text = comment.body;
    [cell.commentTextView  sizeToFit];
    int textViewHeight = cell.commentTextView.frame.size.height;
    
    int authorLabelHeight = cell.commentAuthorLabel.frame.size.height;
    // Now let's return all of them added up :)
    return textViewHeight + authorLabelHeight + 40;
}

#pragma mark - MCSwipeTableView

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
