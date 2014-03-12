//
//  TNViewController.m
//  The News
//
//  Created by Tosin Afolabi on 11/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNViewController.h"

@interface TNViewController ()


@end

@implementation TNViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.x = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64)];
    [self.x setText:@"hello"];
    [self.x setBackgroundColor:[UIColor greenColor]];

    UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    [h setBackgroundColor:[UIColor blackColor]];


    [self.view addSubview:self.x];
    [self.view addSubview:h];

}



@end
