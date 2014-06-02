//
//  TNButton.h
//  The News
//
//  Created by Tosin Afolabi on 04/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNButton : UIButton

- (void)setBackgroundImageWithNormalColor:(UIColor *)normalColor highlightColor:(UIColor *)highlightColor;
- (void)removeHighlightBackgroundImage;

@end
