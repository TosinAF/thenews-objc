//
//  PHFeedViewCell.h
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNFeedViewCell.h"

@interface PHFeedViewCell : TNFeedViewCell

@property (nonatomic, strong) PHProduct *product;

- (void)configureForProduct:(PHProduct *)product;

@end
