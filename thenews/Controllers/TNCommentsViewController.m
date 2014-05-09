//
//  TNCommentsViewController.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNPostViewController.h"
#import "JSMessageTextView.h"
#import "NSString+JSMessagesView.h"
#import "TNCommentsViewController.h"

@interface TNCommentsViewController () <UITextViewDelegate, JSDismissiveTextViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *switchButton;


@end

@implementation TNCommentsViewController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self configureNavbar];
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
    [self setTitle:@"COMMENTS"];

    // Remove back button text in any view pushed on top
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self downloadComments];

    /* Set up Comments Table View */
    // allocated in subclass
    [self.commentsView setFrame:self.view.bounds];
    [self.commentsView setDelegate:self];
    [self.commentsView setDataSource:self];
    [self.commentsView setSeparatorColor:[UIColor tnLightGreyColor]];
    [self registerClassForCell];

    [self.view addSubview:self.commentsView];

    [self addBarButtonItems];

    /* Set Up Keyboard */

    [self configureKeyboard];
    [self addTableHeaderView];


    /* Add Table View Bottom Border */
    CGFloat viewHeaderHeight = self.commentsView.tableHeaderView.bounds.origin.y + self.commentsView.tableHeaderView.frame.size.height;
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeaderHeight, self.view.bounds.size.width, 2)];
    [border setBackgroundColor:[UIColor tnLightGreyColor]];

    [self.commentsView addSubview:border];
}

- (void)addBarButtonItems
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Story"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 30, 30)];

    self.switchButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.rightBarButtonItem = self.switchButton;
}

- (void)switchAction
{
    NSAssert(NO, @"Subclasses need to overwrite this method");
}

- (void)addTableHeaderView
{
    NSAssert(NO, @"Subclasses need to overwrite this method");
}

- (void)registerClassForCell
{
    NSAssert(NO, @"Subclasses need to overwrite this method");
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
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(NO, @"Subclasses need to overwrite this method");
    return 0.0;
}

#pragma mark - Network Methods

- (void)postButtonPressed {
    
    NSAssert(NO, @"Subclasses need to overwrite this method");
}


- (void)downloadComments {

    NSAssert(NO, @"Subclasses need to overwrite this method");
}

#pragma mark - Keyboard Methods

- (void)configureKeyboard
{
    CGFloat inputViewHeight = 45.0f;
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height - inputViewHeight,
                                   self.view.frame.size.width,
                                   inputViewHeight);

    [self setTableViewInsetsWithBottomValue:inputViewHeight];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [_commentsView addGestureRecognizer:tap];

    JSMessageInputView *inputView = [[JSMessageInputView alloc] initWithFrame:inputFrame
                                                                        style:JSMessageInputViewStyleFlat
                                                                     delegate:self
                                                         panGestureRecognizer:nil];

    [inputView setBackgroundColor:[UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:1]];
    [inputView.textView setBackgroundColor:[UIColor whiteColor]];
    [inputView.textView setTintColor:self.themeColor];
    [inputView.textView setPlaceHolder:@"New Comment"];

    [inputView.sendButton setEnabled:NO];
    [[inputView.sendButton titleLabel] setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [inputView.sendButton setTitleColor:self.themeColor forState:UIControlStateNormal];
    [inputView.sendButton setTitleColor:self.themeColor forState:UIControlStateSelected];
    [inputView.sendButton addTarget:self action:@selector(postButtonPressed) forControlEvents:UIControlEventTouchUpInside];


    CALayer *TopBorder = [CALayer layer];
    TopBorder.frame = CGRectMake(0.0f, 0.0f, inputView.frame.size.width, 0.5f);
    TopBorder.backgroundColor = [UIColor colorWithRed:0.678 green:0.678 blue:0.678 alpha:1].CGColor;
    [inputView.layer addSublayer:TopBorder];

    [self.view addSubview:inputView];
    _commentInputView = inputView;

}

- (void)postActionCompleted
{
    [self.commentInputView.textView setText:nil];
    [self textViewDidChange:self.commentInputView.textView];
}

#pragma mark - Gesture Recognizers

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    [self.commentInputView.textView resignFirstResponder];
}

#pragma mark - Text View delegate

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
