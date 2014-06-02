//
//  TNButton.m
//  The News
//
//  Created by Tosin Afolabi on 04/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNButton.h"

@implementation TNButton

- (void)setBackgroundImageWithNormalColor:(UIColor *)normalColor highlightColor:(UIColor *)highlightColor
{
    [self setBackgroundImage:[self roundedImageWithColor:normalColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[self roundedImageWithColor:highlightColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[self roundedImageWithColor:highlightColor] forState:UIControlStateSelected];

    [self setTitleColor:highlightColor forState:UIControlStateNormal];
    [self setTitleColor:normalColor forState:UIControlStateHighlighted];
    [self setTitleColor:highlightColor forState:UIControlStateSelected];

    [[self titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20]];

    [[self layer] setBorderColor:highlightColor.CGColor];
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setCornerRadius:self.frame.size.height / 2];
}

- (void)removeHighlightBackgroundImage
{
    [self setBackgroundImage:[self roundedImageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
}

- (UIImage *)roundedImageWithColor:(UIColor *)color {

    UIView *imageView = [[UIView alloc] initWithFrame:self.frame];
    [imageView setBackgroundColor:color];
    [[imageView layer] setCornerRadius:self.frame.size.height / 2];

    UIGraphicsBeginImageContext(imageView.frame.size);
    [[imageView layer] renderInContext:UIGraphicsGetCurrentContext()];

    return UIGraphicsGetImageFromCurrentImageContext();
}

@end