//
//  TNMenuView.h
//  The News
//
//  Created by Tosin Afolabi on 12/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KeyboardWillAppearBlock)(void);
typedef void (^MenuButtonBlock) (void);

@interface TNMenuView : UIView <UITextFieldDelegate>

@property (nonatomic, copy) NSMutableArray *buttonTitles;

- (id)initWithFrame:(CGRect)frame type:(TNType)type;

- (void)setup;
- (void)toDefaultState;
- (void)setKeyboardWillAppearAction:(KeyboardWillAppearBlock)block;
- (void)setBlockForButton:(int)number block:(MenuButtonBlock)block;

@end
