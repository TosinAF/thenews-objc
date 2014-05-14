//
//  DNMOTDViewController.m
//  The News
//
//  Created by Tosin Afolabi on 22/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <POP/POP.h>
#import "DNManager.h"
#import "DNMOTDLabel.h"
#import "TNNotification.h"
#import "DNMOTDViewController.h"

@interface DNMOTDViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIView *contentView;
@property CGPoint originalCenterOfContentView;

// Content View Properties

@property (nonatomic, strong) DNMOTDLabel *messageLabel;
@property (nonatomic, strong) UIButton *upvoteButton;
@property (nonatomic, strong) UIButton *downvoteButton;
@property (nonatomic, strong) UILabel *upvoteCountLabel;
@property (nonatomic, strong) UILabel *downvoteCountLabel;

@property (nonatomic, strong) DNMOTD *motd;

@end

@implementation DNMOTDViewController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0.1, 0.1f)];
    scaleAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];

    [self.contentView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setScreenName:@"DNMOTD"];
    [self.view setBackgroundColor:[UIColor clearColor]];

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 130, 300, 300)];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView.layer setMasksToBounds:YES];
    [self.contentView.layer setCornerRadius:12.0f];

    [self.view addSubview:self.contentView];
    [self configureContentView];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];

    [self.view addGestureRecognizer:self.panGestureRecognizer];

    self.originalCenterOfContentView = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
}

#pragma mark - Content View

- (void)configureContentView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    [titleLabel setText:@"M.O.T.D"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor dnColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"Montserrat" size:20.0f]];

    self.messageLabel = [[DNMOTDLabel alloc] initWithFrame:CGRectMake(10, 65, 280, 200)];
    [self.messageLabel setTextAlignment:NSTextAlignmentJustified];
    [self.messageLabel setFont:[UIFont fontWithName:@"Avenir-BookOblique" size:20.0f]];

    [self.messageLabel setText:@"What wise words shall we read now?"];
    [self.messageLabel setTextColor:[UIColor tnGreyColor]];
    [self.messageLabel setTextAlignment:NSTextAlignmentCenter];

    self.upvoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.upvoteButton setFrame:CGRectMake(50, 220, 50, 57)];
    [self.upvoteButton setBackgroundImage:[UIImage imageNamed:@"ThumbsUp"] forState:UIControlStateNormal];
    [self.upvoteButton setBackgroundImage:[UIImage imageNamed:@"ThumbsUpSelected"] forState:UIControlStateSelected];
    [self.upvoteButton addTarget:self action:@selector(upvoteMOTD) forControlEvents:UIControlEventTouchUpInside];

    self.upvoteCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 220, 30, 15)];
    [self.upvoteCountLabel setTextColor:[UIColor tnColor]];
    [self.upvoteCountLabel setFont:[UIFont fontWithName:@"Montserrat" size:15.0f]];

    self.downvoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downvoteButton setFrame:CGRectMake(200, 220, 50, 57)];
    [self.downvoteButton setBackgroundImage:[UIImage imageNamed:@"ThumbsDown"] forState:UIControlStateNormal];
    [self.downvoteButton setBackgroundImage:[UIImage imageNamed:@"ThumbsDownSelected"] forState:UIControlStateSelected];
    [self.downvoteButton addTarget:self action:@selector(downvoteMOTD) forControlEvents:UIControlEventTouchUpInside];

    self.downvoteCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 260, 30, 15)];
    [self.downvoteCountLabel setTextColor:[UIColor colorWithRed:0.949 green:0.635 blue:0.600 alpha:1]];
    [self.downvoteCountLabel setFont:[UIFont fontWithName:@"Montserrat" size:15.0f]];

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.upvoteButton];
    [self.contentView addSubview:self.downvoteButton];
    [self.contentView addSubview:self.upvoteCountLabel];
    [self.contentView addSubview:self.downvoteCountLabel];

    [self getMOTD];
}

#pragma mark - Network Methods

- (void)getMOTD
{
    [[DNManager sharedManager] getMOTD:^(DNMOTD *motd) {

        self.motd = motd;

        [self.messageLabel setTextColor:[UIColor blackColor]];
        [self.messageLabel setText:[motd message]];
        [self.upvoteCountLabel setText:[[motd upvoteCount] stringValue]];
        [self.downvoteCountLabel setText:[[motd downvoteCount] stringValue]];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failure");
    }];
}

- (void)upvoteMOTD
{
    [[DNManager sharedManager] upvoteMOTD:^(NSURLSessionDataTask *task, id responseObject) {

        NSNumber *upvoteCount = @([[self.motd upvoteCount] intValue] + 1);
        [self.upvoteCountLabel setText:[upvoteCount stringValue]];

        [self.upvoteButton setSelected:YES];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        TNNotification *notification = [[TNNotification alloc] init];
        [notification showFailureNotification:@"MOTD Upvote Failed" subtitle:nil];

    }];
}

- (void)downvoteMOTD
{
    [[DNManager sharedManager] downvoteMOTD:^(NSURLSessionDataTask *task, id responseObject) {

        NSNumber *downvoteCount = @([[self.motd downvoteCount] intValue] + 1);
        [self.downvoteCountLabel setText:[downvoteCount stringValue]];

        [self.downvoteButton setSelected:YES];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        TNNotification *notification = [[TNNotification alloc] init];
        [notification showFailureNotification:@"MOTD Downvote Failed" subtitle:nil];
        
    }];
}

#pragma mark - UIDyanmics

- (void)handlePanGesture:(id)sender{

    // Taken from Lars's WWDC 2014 App

    CGPoint p = [self.panGestureRecognizer locationInView:self.view];

    if ( self.panGestureRecognizer.state == UIGestureRecognizerStateBegan ) {

        CGPoint center = self.contentView.center;
        UIOffset offset = UIOffsetMake(p.x - center.x, p.y - center.y);
        self.attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:_contentView offsetFromCenter:offset attachedToAnchor:p];
        [self.animator addBehavior:self.attachBehavior];

    }  else if ( self.panGestureRecognizer.state == UIGestureRecognizerStateChanged ) {

        self.attachBehavior.anchorPoint = p;

    } else if ( ( self.panGestureRecognizer.state == UIGestureRecognizerStateEnded || self.panGestureRecognizer.state == UIGestureRecognizerStateCancelled ) && self.attachBehavior ) {

        [self.animator removeBehavior:self.attachBehavior];
        self.attachBehavior = nil;

        CGPoint velocity = [self.panGestureRecognizer velocityInView:self.view];
        velocity = CGPointMake(velocity.x / 30, velocity.y / 30);

        CGFloat magnitude = (CGFloat)sqrt(pow((double)velocity.x, 2.0) + pow((double)velocity.y, 2.0));

        if (magnitude > 30) {

            self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_contentView]];
            self.collisionBehavior.collisionDelegate = self;

            CGFloat diagonal = -sqrt(pow(CGRectGetWidth(_contentView.frame), 2.0) + pow(CGRectGetHeight(_contentView.frame), 2.0));

            UIEdgeInsets insets = UIEdgeInsetsMake(diagonal, diagonal, diagonal, diagonal);
            [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:insets];
            [self.animator addBehavior:self.collisionBehavior];

            self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_contentView] mode:UIPushBehaviorModeInstantaneous];
            CGPoint center = _contentView.center;

            UIOffset offset = UIOffsetMake((p.x - center.x) / 2.0, (p.y - center.y) / 2.0);

            [self.pushBehavior setTargetOffsetFromCenter:offset forItem:_contentView];
            self.pushBehavior.pushDirection = CGVectorMake(velocity.x, velocity.y);
            [self.animator addBehavior:self.pushBehavior];

            self.panGestureRecognizer.enabled = NO;

        } else {

            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            anim.toValue = [NSValue valueWithCGPoint:self.originalCenterOfContentView];

            [UIView animateWithDuration:0.25f animations:^{

                [self.contentView pop_addAnimation:anim forKey:@"center"];
                _contentView.transform = CGAffineTransformIdentity;

            } completion:nil];
        }
    }
}

#pragma mark - UICollisionBehaviour Delegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)pq{

        [self.animator removeAllBehaviors];
        self.pushBehavior = nil;
    
    _collisionBehavior = nil;
    [_contentView setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
