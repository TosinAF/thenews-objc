//
//  TNCommentsViewController.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNHeaderView.h"
#import "TNCommentCell.h"
#import "TNNotification.h"
#import "JSMessageTextView.h"
#import "JSMessageInputView.h"
#import "NSString+JSMessagesView.h"
#import "TNCommentsViewController.h"

DNManager *DNClient;
static NSString *CellIdentifier = @"TNCommentCell";

@interface TNCommentsViewController () <UITextViewDelegate, JSDismissiveTextViewDelegate>

@property (nonatomic) DNStory *story;
@property (nonatomic) UIColor *themeColor;
@property (nonatomic,   copy) NSArray *comments;

@property (nonatomic, strong) NSNumber *replyToID;

@property (nonatomic) UITableView *commentsView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (weak, nonatomic, readonly) JSMessageInputView *commentInputView;

@end

@implementation TNCommentsViewController

- (instancetype)initWithType:(TNType)type story:(DNStory *)story
{
    self = [super init];

    if (self) {

        switch (type) {
            case TNTypeDesignerNews:
                self.title = @"DESIGNER NEWS";
                self.themeColor = [UIColor dnColor];
                break;

            case TNTypeHackerNews:
                self.title = @"HACKER NEWS";
                self.themeColor = [UIColor hnColor];
                break;
        }

        self.story = story;
        self.comments = [NSArray new];
    }

    return self;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboardNotification:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboardNotification:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];

    [self.commentInputView.textView addObserver:self
                                     forKeyPath:@"contentSize"
                                        options:NSKeyValueObservingOptionNew
                                        context:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavbar];

    DNClient = [DNManager sharedClient];
    [self downloadComments];

    /* Set up Comments Table View */

    self.commentsView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.commentsView setDelegate:self];
    [self.commentsView setDataSource:self];
    [self.commentsView setSeparatorColor:[UIColor tnLightGreyColor]];
    [self.commentsView registerClass:[TNCommentCell class] forCellReuseIdentifier:CellIdentifier];

    [self.view addSubview:self.commentsView];

    /* Set Up Keyboard */

    [self configureKeyboard];


    /* Set Up Table Header View */

    TNHeaderView *headerView = [[TNHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 85) type:TNTypeDesignerNews];
    [headerView configureForStory:self.story];
    [headerView setButtonTitle:@"Comment"];
    [headerView setButtonAction:^{

        self.replyToID = nil;
        [self.commentInputView.textView becomeFirstResponder];
        NSLog(@"%@",self.replyToID);

    }];

    [self.commentsView setTableHeaderView:headerView];

    /* Add Table View Bottom Border */

    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, self.commentsView.tableHeaderView.bounds.origin.y + 85, self.view.bounds.size.width, 2)];
    [border setBackgroundColor:[UIColor tnLightGreyColor]];

    [self.commentsView addSubview:border];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [self.commentInputView resignFirstResponder];
    [self setEditing:NO animated:YES];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [self.commentInputView.textView removeObserver:self forKeyPath:@"contentSize"];
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
    TNCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    DNComment *comment = [self.comments objectAtIndex:[indexPath row]];
    [cell configureForComment:comment];
    [cell addSwipeGesturesToCell];

    [cell setUpvoteBlock:^(TNCommentCell *cell) {

        TNNotification *notification = [[TNNotification alloc] init];
        NSString *commentID = [[[cell comment] commentID] stringValue];

        [DNClient upvoteCommentWithID:commentID success:^{

            [notification showSuccessNotification:@"Comment Upvote Successful" subtitle:nil];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {

            [notification showFailureNotification:@"Comment Upvote Failed" subtitle:@"You can only upvote a comment once."];
        }];
    }];

    [cell setCommentBlock:^(TNCommentCell *cell) {

        self.replyToID = [comment commentID];
        NSLog(@"reply is %@", self.replyToID);
        [self.commentInputView.textView becomeFirstResponder];

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

- (void)postButtonPressed {
    [self postComment:self.commentInputView.textView.text inReplyTo:self.replyToID];
}

- (void)postComment:(NSString *)comment inReplyTo:(NSNumber *)originalCommentID {

    TNNotification *notification = [[TNNotification alloc] init];

    if (originalCommentID) {

        [DNClient replyCommentWithID:[[self.story storyID] stringValue] comment:comment success:^{

            [self downloadComments];
            [self finishSend];

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSString *errorMsg = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
            NSLog(@"%@", errorMsg);
        }];

    } else {

        [DNClient replyStoryWithID:[[self.story storyID] stringValue] comment:comment success:^{

            [self downloadComments];
            [self finishSend];
            [notification showSuccessNotification:@"Comment Post Successful" subtitle:nil];

        } failure:^(NSURLSessionDataTask *task, NSError *error){

            NSString *errorMsg = [[error userInfo] objectForKey:@"NSLocalizedDescription"];
            NSLog(@"%@", errorMsg);
            [notification showFailureNotification:@"Comment Post Failed" subtitle:nil];
        }];
    }

}

- (void)downloadComments {

    [DNClient getCommentsForStoryWithID:[[self.story storyID] stringValue] success:^(NSArray *comments) {

        self.comments = comments;
        [self.commentsView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"The task: %@ failed with error: %@", task, error);
        
    }];
}

#pragma mark - Keyboard Methods

- (void)configureKeyboard
{
    JSMessageInputViewStyle inputViewStyle = JSMessageInputViewStyleFlat;
    CGFloat inputViewHeight = 45.0f;

    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height - inputViewHeight,
                                   self.view.frame.size.width,
                                   inputViewHeight);

    [self setTableViewInsetsWithBottomValue:inputViewHeight];

    //UIPanGestureRecognizer *pan = _commentsView.panGestureRecognizer;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [_commentsView addGestureRecognizer:tap];

    JSMessageInputView *inputView = [[JSMessageInputView alloc] initWithFrame:inputFrame
                                                                        style:inputViewStyle
                                                                     delegate:self
                                                         panGestureRecognizer:nil];

    [inputView setBackgroundColor:[UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1]];
    [inputView.textView setBackgroundColor:[UIColor whiteColor]];
    [inputView.textView setPlaceHolder:@"New Comment"];

    inputView.sendButton.enabled = NO;
    [inputView.sendButton addTarget:self
                             action:@selector(postButtonPressed)
                   forControlEvents:UIControlEventTouchUpInside];

    [inputView.textView setTintColor:[UIColor tnColor]];

    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, inputView.frame.size.width, 0.5f);
    TopBorder.backgroundColor = [UIColor colorWithRed:0.678 green:0.678 blue:0.678 alpha:1].CGColor;
    [inputView.layer addSublayer:TopBorder];

    [self.view addSubview:inputView];
    _commentInputView = inputView;

}

- (void)cancelReply {
    self.replyToID = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
}

- (void)finishSend
{
    [self.commentInputView.textView setText:nil];
    [self textViewDidChange:self.commentInputView.textView];
    [self.commentsView reloadData];
}

#pragma mark - Gesture Recognizers

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    [self.commentInputView.textView resignFirstResponder];
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];

    if (!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.commentInputView.sendButton.enabled = ([[textView.text js_stringByTrimingWhitespace] length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

#pragma mark - Layout message input view

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];

    BOOL isShrinking = textView.contentSize.height < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textView.contentSize.height - self.previousTextViewContentHeight;

    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }

    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.commentsView.contentInset.bottom + changeInHeight];

                             if (isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.commentInputView adjustTextViewHeightBy:changeInHeight];
                             }

                             CGRect inputViewFrame = self.commentInputView.frame;
                             self.commentInputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);

                             if (!isShrinking) {
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.commentInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];

        self.previousTextViewContentHeight = MIN(textView.contentSize.height, maxHeight);
    }

    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, textView.contentSize.height - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.commentsView.contentInset = insets;
    self.commentsView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsZero;

    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }

    insets.bottom = bottom;

    return insets;
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.commentInputView.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark - Keyboard Notifications

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification
{
    [[notification userInfo] setValue:@(UIViewAnimationCurveEaseIn) forKey:UIKeyboardAnimationCurveUserInfoKey];
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification
{
    [[notification userInfo] setValue:@(UIViewAnimationCurveEaseOut) forKey:UIKeyboardAnimationCurveUserInfoKey];
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration
                          delay:0.0
                        options:[self animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;

                         CGRect inputViewFrame = self.commentInputView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;

                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - inputViewFrame.size.height;
                         if (inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;

                         self.commentInputView.frame = CGRectMake(inputViewFrame.origin.x,
																  inputViewFrameY,
																  inputViewFrame.size.width,
																  inputViewFrame.size.height);

                         [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
                          - self.commentInputView.frame.origin.y];
                     }
                     completion:nil];
}

#pragma mark - Dismissive Text View Delegate

- (void)keyboardDidScrollToPoint:(CGPoint)point
{
    CGRect inputViewFrame = self.commentInputView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.commentInputView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.commentInputView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.commentInputView.frame = inputViewFrame;
}

#pragma mark - Utilities

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;

        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;

        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;

        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;

        default:
            return kNilOptions;
    }
}

- (void)configureNavbar
{
    [self.navigationController.navigationBar setBarTintColor:self.themeColor];
	[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
	[self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:16.0f],
                                                                       NSForegroundColorAttributeName:[UIColor whiteColor] }];
}



@end
