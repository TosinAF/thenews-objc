//
//  TNButton.m
//  The News
//
//  Created by Tosin Afolabi on 04/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNButton.h"
#import "UIColor+TNColors.h"

@implementation TNButton

- (void)withText:(NSString *)text normalColor:(UIColor *)normalColor highlightColor:(UIColor *)highlightColor border:(BOOL)borderExists
{
    [self setBackgroundImage:[self imageWithColor:normalColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [self setTitleColor:highlightColor forState:UIControlStateNormal];
    [self setTitleColor:normalColor forState:UIControlStateSelected];
    [self setTitle:text forState:UIControlStateNormal];
    [[self titleLabel] setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20]];

    if (borderExists) {
        [[self layer] setBorderColor:highlightColor.CGColor];
        [[self layer] setBorderWidth:2.0f];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {

    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end