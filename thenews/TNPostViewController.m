//
//  TNPostViewController.m
//  thenews
//
//  Created by Tosin Afolabi on 19/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "UIColor+TNColors.h"
#import "TNPostViewController.h"

@interface TNPostViewController ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation TNPostViewController

- (id)initWithURL:(NSURL *)url title:(NSString *)title
{
    self = [super init];

    if (self) {
        self.url = url;
        self.titleStr = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:self.titleStr];
	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Montserrat" size:16.0f],
	                                                        NSForegroundColorAttributeName:[UIColor whiteColor] }];

    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.webView setScalesPageToFit:YES];

    [self.view addSubview:self.webView];

}


@end
