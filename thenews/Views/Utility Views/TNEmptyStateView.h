//
//  TNEmptyStateView.h
//  The News
//
//  Created by Tosin Afolabi on 22/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNEmptyStateView : UIView

@property (nonatomic, strong) UILabel *infoLabel;

- (void)showErrorText;
- (void)showDownloadingText;
- (void)showErrorWithText:(NSString *)text;


@end
