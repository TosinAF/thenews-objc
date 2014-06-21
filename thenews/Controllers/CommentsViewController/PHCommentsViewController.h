//
//  PHCommentsViewController.h
//  The News
//
//  Created by Tosin Afolabi on 14/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHManager.h"
#import "TNCommentsViewController.h"

@interface PHCommentsViewController : TNCommentsViewController

@property (nonatomic, strong) PHProduct *product;

- (instancetype)initWithProduct:(PHProduct *)product;

@end
