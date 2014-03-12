//
//  TNMenuView.m
//  The News
//
//  Created by Tosin Afolabi on 12/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNMenuView.h"
#import "UIColor+TNColors.h"


@implementation TNMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutViews
{
    CGSize viewSize = self.frame.size;
    [self setBackgroundColor:[UIColor whiteColor]];

    NSArray *buttonTitles = [NSArray arrayWithObjects:@"M.O.T.D", @"Recent Stories", @"Settings", nil];

    for (int i = 0; i < [buttonTitles count]; i++) {

        int yPos = 0 + (i * 50);

        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setTitleColor:[UIColor dnColor] forState:UIControlStateNormal];
        [menuButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [menuButton setContentEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        [[menuButton titleLabel] setFont:[UIFont fontWithName:@"Avenir-Medium" size:20.0f]];
        [menuButton setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [menuButton setFrame:CGRectMake(0, yPos, viewSize.width, 50)];

        [self addSubview:menuButton];
    }

    for (int i = 0; i < 3; i++) {

        int yPos = 50 + (i * 50);

        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, viewSize.width, 2)];
        [border setBackgroundColor:[UIColor tnLightGreyColor]];

        [self addSubview:border];
    }
}



@end
