//
//  DNMOTDViewController.m
//  The News
//
//  Created by Tosin Afolabi on 22/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNMOTDViewController.h"

@interface DNMOTDViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *attachBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIView *helloView;
@property CGPoint originalCenterOfHelloView;

@end

@implementation DNMOTDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];

    self.helloView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [_helloView setBackgroundColor:[UIColor darkGrayColor]];
    [_helloView.layer setMasksToBounds:YES];
    [_helloView.layer setCornerRadius:12.0f];

    [self.view addSubview:self.helloView];

    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];

    [self.view addGestureRecognizer:self.panGestureRecognizer];

    self.originalCenterOfHelloView = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
}

- (void)handlePanGesture:(id)sender{

    // Taken from Lars's WWDC 2014 App

    CGPoint p = [self.panGestureRecognizer locationInView:self.view];

    if ( self.panGestureRecognizer.state == UIGestureRecognizerStateBegan ) {

        CGPoint center = self.helloView.center;
        UIOffset offset = UIOffsetMake(p.x - center.x, p.y - center.y);
        self.attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:_helloView offsetFromCenter:offset attachedToAnchor:p];
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

            self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_helloView]];
            self.collisionBehavior.collisionDelegate = self;

            CGFloat diagonal = -sqrt(pow(CGRectGetWidth(_helloView.frame), 2.0) + pow(CGRectGetHeight(_helloView.frame), 2.0));

            UIEdgeInsets insets = UIEdgeInsetsMake(diagonal, diagonal, diagonal, diagonal);
            [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:insets];
            [self.animator addBehavior:self.collisionBehavior];

            self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_helloView] mode:UIPushBehaviorModeInstantaneous];
            CGPoint center = _helloView.center;

            UIOffset offset = UIOffsetMake((p.x - center.x) / 2.0, (p.y - center.y) / 2.0);

            [self.pushBehavior setTargetOffsetFromCenter:offset forItem:_helloView];
            self.pushBehavior.pushDirection = CGVectorMake(velocity.x, velocity.y);
            [self.animator addBehavior:self.pushBehavior];

            self.panGestureRecognizer.enabled = NO;

        } else {

            [UIView animateWithDuration:0.25f animations:^{
                _helloView.center = _originalCenterOfHelloView;
                _helloView.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished){

            }];
        }
    }
}

#pragma mark - UICollisionBehaviour Delegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)pq{

        [self.animator removeAllBehaviors];
        self.pushBehavior = nil;
    
    _collisionBehavior = nil;
    [_helloView setHidden:YES];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //_blurView.alpha = 1.0f;
    }completion:^(BOOL finished){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}




@end
