//
//  TNRefreshView.h
//  The News
//
//  Created by Tosin Afolabi on 28/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, TNRefreshState) {
    TNRefreshStatePulling,
	TNRefreshStateLoading,
	TNRefreshStateEnded
};

@interface TNRefreshView : UIView

- (instancetype)initWithFrame:(CGRect)frame state:(TNRefreshState)state;

@end
