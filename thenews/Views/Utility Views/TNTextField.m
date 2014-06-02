//
//  TNTextField.m
//  The News
//
//  Created by Tosin Afolabi on 05/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNTextField.h"

@implementation TNTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setReturnKeyType:UIReturnKeyNext];
        [self setFont:[UIFont fontWithName:@"Avenir-Medium" size:20.0f]];
    }
    return self;
}

- (void)setPlaceholderColor:(UIColor*)color
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:color}];
}

@end
