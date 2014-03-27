//
//  TNNotification.h
//  The News
//
//  Created by Tosin Afolabi on 26/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNNotification : NSObject

- (void)showSuccessNotification:(NSString *)title subtitle:(NSString *)subtitle;
- (void)showFailureNotification:(NSString *)title subtitle:(NSString *)subtitle;

@end
