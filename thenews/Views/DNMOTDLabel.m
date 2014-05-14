//
//  DNMOTDLabel.m
//  The News
//
//  Created by Tosin Afolabi on 13/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNMOTDLabel.h"

@implementation DNMOTDLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setNumberOfLines:4];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];

    // Get Expected Size of String & Adjust Size of Label to Fit
    CGSize maximumLabelSize = CGSizeMake(280,150);
    CGSize expectedLabelSize = [self text:text sizeWithFont:self.font constrainedToSize:maximumLabelSize];
    CGRect newFrame = self.frame;
    newFrame.size.width = 280.0;
    newFrame.size.height = expectedLabelSize.height + 20;
    self.frame = newFrame;
}

- (CGSize)text:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size
{
    NSDictionary *attributesDictionary = @{NSFontAttributeName:font};

    CGRect frame = [text boundingRectWithSize:size
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                    attributes:attributesDictionary
                                        context:nil];
    return frame.size;
}

@end
