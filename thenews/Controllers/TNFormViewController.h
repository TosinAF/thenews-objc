//
//  TNFormViewController.h
//  The News
//
//  Created by Tosin Afolabi on 20/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNTextField.h"

bool validNameField;
bool validEmailField;
bool validPasswordField;

static NSString *authErrorMessage = @"Your login credentials are invalid";
static NSString *networkErrorMessage = @"There is no network connection";
static NSString *invalidFieldErrorMessage = @"Please correct the indicated errors.";

@interface TNFormViewController : GAITrackedViewController <UITextFieldDelegate>

typedef NS_ENUM (NSInteger, TNTextFieldType) {
	TNTextFieldTypeName,
	TNTextFieldTypeEmail,
    TNTextFieldTypePassword,
};

@property (strong, nonatomic) TNTextField *nameField;
@property (strong, nonatomic) TNTextField *usernameField;
@property (strong, nonatomic) TNTextField *passwordField;
@property (strong, nonatomic) UILabel *errorLabel;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;

- (void)pushHomeView;

- (void)checkAllFields;
- (void)checkField:(TNTextField *)textField;
- (void)resetTextField:(TNTextField *)textField;

- (void)fadeInAnimation:(UIView *)view;

@end
