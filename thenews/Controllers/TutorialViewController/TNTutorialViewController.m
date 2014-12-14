//
//  TNTutorialViewController.m
//  The News
//
//  Created by Tosin Afolabi on 21/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTutorialViewController.h"

@interface TNTutorialViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TNTutorialViewController

- (instancetype)initWithTutorial:(TNTutorial)type
{
    self = [super init];

    if (self) {

        switch (type) {
            case TNTutorialNavigationBarSwipe:
                // Swipe to Hacker News
                [self setScreenName:@"Nav Bar Tutorial"];
                self.image = [UIImage imageNamed:@"hnGesture"];
                self.text = @"Swipe Left on the Nav Bar to view Hacker News";
                break;

            case TNTutorialRightTableViewCellSwipe:
                // Upvote
                [self setScreenName:@"Upvote Tutorial"];
                self.image = [UIImage imageNamed:@"upvoteGesture"];
                self.text = @"Swipe Right on the Post to Upvote";
                break;
                
            case TNTutorialLeftTableViewCellSwipe:
                // View Comments
                [self setScreenName:@"View Comments Tutorial"];
                self.image = [UIImage imageNamed:@"commentGesture"];
                self.text = @"Swipe Left on the Post to View Comments";
                break;
        }

        self.type = type;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
   [[self navigationController] setNavigationBarHidden:YES];
   [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.infoLabel = [UILabel new];
    [self.infoLabel setNumberOfLines:0];
    [self.infoLabel setText:self.text];
    [self.infoLabel setFont:[UIFont fontWithName:@"Montserrat" size:18.0f]];
    [self.infoLabel setTextAlignment:NSTextAlignmentCenter];
    [self.infoLabel setTranslatesAutoresizingMaskIntoConstraints:false];

    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];

    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.imageView];

    [self layoutSubviews];
}

- (void)layoutSubviews {
    NSDictionary *views = @{
                            @"label": self.infoLabel,
                            @"image": self.imageView
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[label]-30-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[label]" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[image]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-190-[image]|" options:0 metrics:nil views:views]];

}



@end
