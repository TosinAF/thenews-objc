//
//  UIColor+TNColors.m
//  thenews
//
//  Created by Tosin Afolabi on 30/01/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "UIColor+TNColors.h"

@implementation UIColor (TNColors)

+ (UIColor *)tnGreyColor {
    return [UIColor colorWithRed:0.765 green:0.765 blue:0.765 alpha:1];
}

+ (UIColor *)tnLightGreyColor {
    return [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1];
}

+ (UIColor *)tnLightGreenColor {
    return [UIColor colorWithRed:0.631 green:0.890 blue:0.812 alpha:1];
}

+ (UIColor *)dnColor {
    return [UIColor colorWithRed:0.349 green:0.518 blue:0.816 alpha:1];
}

+ (UIColor *)dnLightColor {
    return [UIColor colorWithRed:0.349 green:0.518 blue:0.816 alpha:0.8];
}

+ (UIColor *)hnColor {
    return [UIColor colorWithRed:0.380 green:0.749 blue:0.639 alpha:1];
}

+ (UIColor *)hnLightColor {
    return [UIColor colorWithRed:0.380 green:0.749 blue:0.639 alpha:0.8];
}

+ (UIColor *)alternateHnColor {
    return [UIColor colorWithRed:1.000 green:0.408 blue:0.216 alpha:1];
}

+ (UIColor *)alternateHnLightColor {
    return [UIColor colorWithRed:1.000 green:0.408 blue:0.216 alpha:0.8];
}

@end
