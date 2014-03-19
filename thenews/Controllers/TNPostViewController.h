//
//  TNPostViewController.h
//  thenews
//
//  Created by Tosin Afolabi on 19/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTypeEnum.h"
#import <UIKit/UIKit.h>

typedef void (^DismissActionBlock)(void);

@interface TNPostViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>

- (id)initWithURL:(NSURL *)url type:(TNType)type;
- (void)setDismissAction:(DismissActionBlock)dismissActionBlock;

@end
