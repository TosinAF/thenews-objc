//
//  HNCommentsViewController.h
//  The News
//
//  Created by Tosin Afolabi on 20/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "libHN.h"
#import "TNCommentsViewController.h"

@interface HNCommentsViewController : TNCommentsViewController

- (instancetype)initWithPost:(HNPost *)post;

@end
