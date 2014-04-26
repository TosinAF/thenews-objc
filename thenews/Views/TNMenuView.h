//
//  TNMenuView.h
//  The News
//
//  Created by Tosin Afolabi on 12/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TNMenuViewDelegate;

@interface TNMenuView : UIView <UITextFieldDelegate>

@property (nonatomic,strong) UIButton *buttonOne;
@property (nonatomic, copy) NSArray *buttonTitles;
@property (nonatomic, weak) id<TNMenuViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame type:(TNType)type;

- (void)setup;
- (void)toDefaultState;

@end

@protocol TNMenuViewDelegate <NSObject>

@optional

- (void)menuActionForButtonOne;
- (void)menuActionForButtonTwo;
- (void)menuActionForButtonThree;
- (void)menuActionForButtonFour;
- (void)menuActionForSearchFieldWithText:(NSString *)text;
- (void)menuActionForKeyboardWillAppear;

@end
