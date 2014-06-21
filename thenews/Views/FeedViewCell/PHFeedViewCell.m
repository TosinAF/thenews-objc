//
//  PHFeedViewCell.m
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHProduct.h"
#import "PHFeedViewCell.h"

@implementation PHFeedViewCell

- (void)configureForProduct:(PHProduct *)product
{
    [self setFeedType:TNTypeProductHunt];

    NSDictionary *cellContent = @{@"title":[product titleWithTagline],
                                  @"author":[[product hunter] name],
                                  @"points":[product voteCount],
                                  @"count":[product commentCount]};

    self.product = product;
    [self updateLabels:cellContent];
}


@end
