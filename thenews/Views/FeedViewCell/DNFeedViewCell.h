//
//  DNFeedViewCell.h
//  The News
//
//  Created by Tosin Afolabi on 06/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNStory.h"
#import "TNFeedViewCell.h"

@interface DNFeedViewCell : TNFeedViewCell

@property (strong, nonatomic) DNStory *story;

- (void)configureForStory:(DNStory *)story;
- (void)incrementVoteCount;

@end
