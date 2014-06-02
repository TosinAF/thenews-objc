//
//  DNSearchViewCell.h
//  The News
//
//  Created by Tosin Afolabi on 18/05/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNFeedViewCell.h"

@interface DNSearchViewCell : TNFeedViewCell

@property (strong, nonatomic) DNStory *story;

- (void)configureForStory:(DNStory *)story;

@end
