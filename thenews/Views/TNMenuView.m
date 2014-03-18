//
//  TNMenuView.m
//  The News
//
//  Created by Tosin Afolabi on 12/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTypeEnum.h"
#import "TNMenuView.h"
#import "UIColor+TNColors.h"

KeyboardWillAppearBlock keyboardWillAppearAction;

@interface TNMenuView ()

@property (nonatomic, strong) NSNumber *type;
@property (strong, nonatomic) UIColor *themeColor;

@property (nonatomic,strong) UIButton *motdButton;
@property (nonatomic,strong) UIButton *storiesButton;
@property (nonatomic,strong) UIButton *settingsButton;
@property (nonatomic,strong) UITextField *searchField;

@end

@implementation TNMenuView

- (id)initWithFrame:(CGRect)frame type:(TNType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = [NSNumber numberWithInt:type];

        switch (type) {
            case TNTypeDesignerNews:
                self.themeColor = [UIColor dnColor];
                break;

            case TNTypeHackerNews:
                self.themeColor = [UIColor hnColor];
                break;
        }
    }
    return self;
}

- (void)setup
{
    CGSize viewSize = self.frame.size;
    [self setBackgroundColor:[UIColor whiteColor]];

    /* Menu Buttons */

    NSArray *buttonTitles = [NSArray arrayWithObjects:@"Recent Stories", @"M.O.T.D", @"Settings", nil];

    for (int i = 0; i < [buttonTitles count]; i++) {

        int yPos = 0 + (i * 50);

        NSString *title = [buttonTitles objectAtIndex:i];

        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setTitle:title forState:UIControlStateNormal];
        [menuButton setFrame:CGRectMake(0, yPos, viewSize.width, 50)];
        [menuButton setContentEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        [menuButton setTitleColor:self.themeColor forState:UIControlStateNormal];
        [menuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [[menuButton titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:20.0f]];
        [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        [menuButton setTag:i];

        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, yPos + 50, viewSize.width, 2)];
        [border setBackgroundColor:[UIColor tnLightGreyColor]];

        [self addSubview:border];
        [self addSubview:menuButton];
    }

    /* Search TextField */

    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(40, 150, viewSize.width - 65, 50)];
    [self.searchField setDelegate:self];
    [self.searchField setTextColor:[UIColor dnColor]];
    [self.searchField setPlaceholder:@"Search Stories"];
    [self.searchField setRightViewMode:UITextFieldViewModeWhileEditing];
    [self.searchField setFont:[UIFont fontWithName:@"Avenir-Medium" size:20.0f]];

    UIImage *cancelButtonImage = [UIImage imageNamed:@"Error"];

    UIButton *cancelSearch = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelSearch setTintColor:[UIColor lightGrayColor]];
    [cancelSearch setImage:cancelButtonImage forState:UIControlStateNormal];
    [cancelSearch setFrame:CGRectMake(0, 0, cancelButtonImage.size.width, cancelButtonImage.size.height)];
    [cancelSearch addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];

    [self.searchField setRightView:cancelSearch];

    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 200, viewSize.width, 8)];
    [border setBackgroundColor:[UIColor tnLightGreyColor]];

    [self addSubview:border];
    [self addSubview:self.searchField];
}

- (void)menuButtonClicked:(UIButton*)selector
{
    NSDictionary *dict = @{@"buttonTag":[NSNumber numberWithLong:selector.tag], @"type":self.type};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuButtonClicked" object:nil userInfo:dict];
}

- (void)clearTextField
{
    // The action is jumpy if the placeholder text still exists
    [self.searchField setText:@""];
    [self.searchField setPlaceholder:@""];
}

- (void)toDefaultState
{
    // For When the menu is hidden
    [self.searchField setText:@""];
    [self.searchField setPlaceholder:@"Search Stories"];
    [self.searchField resignFirstResponder];
}

- (void)dismissKeyboard
{
    [self resignFirstResponder];
}

#pragma mark - UITextField Delegate

- (void)setKeyboardWillAppearAction:(KeyboardWillAppearBlock)block
{
    keyboardWillAppearAction = block;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    keyboardWillAppearAction();
    return YES;
}

@end
