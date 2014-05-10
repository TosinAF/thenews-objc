//
//  TNNotification.m
//  The News
//
//  Created by Tosin Afolabi on 26/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "CRToast.h"
#import "TNNotification.h"

@implementation TNNotification

- (NSDictionary *)defaultNotificationOptions
{
    NSDictionary *options = @{
                              kCRToastTextKey : @"Post Upvote Successful",
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastSubtitleTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastFontKey : [UIFont fontWithName:@"Avenir-Light" size:14],
                              kCRToastSubtitleFontKey : [UIFont fontWithName:@"Avenir-Light" size:9],
                              kCRToastBackgroundColorKey : [UIColor tnColor],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationPresentationTypeKey : @(YES),
                              kCRToastNotificationTypeKey : @(YES),
                              kCRToastUnderStatusBarKey: @(NO),
                              kCRToastStatusBarStyle : @(UIStatusBarStyleLightContent),
                              kCRToastImageKey : [UIImage imageNamed:@"Checkmark"]
                              };
    return options;
}

- (void)showSuccessNotification:(NSString *)title subtitle:(NSString *)subtitle
{
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:[self defaultNotificationOptions]];

    options[kCRToastTextKey] = title;

    if (subtitle != nil) {
        options[kCRToastSubtitleTextKey] = subtitle;
    }

    [CRToastManager showNotificationWithOptions:options completionBlock:^{}];
}

- (void)showFailureNotification:(NSString *)title subtitle:(NSString *)subtitle
{
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:[self defaultNotificationOptions]];

    options[kCRToastTextKey] = title;

    if (subtitle != nil) {
        options[kCRToastSubtitleTextKey] = subtitle;
    }

    options[kCRToastImageKey] = [UIImage imageNamed:@"Error"];
    options[kCRToastBackgroundColorKey] = [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1];

    [CRToastManager showNotificationWithOptions:options completionBlock:^{}];
}

@end
