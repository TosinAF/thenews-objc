//
//  TNPostViewController.h
//  thenews
//
//  Created by Tosin Afolabi on 19/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface TNPostViewController : UIViewController <UIWebViewDelegate, NJKWebViewProgressDelegate>

- (id)initWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL*)url title:(NSString *)title;

@end
