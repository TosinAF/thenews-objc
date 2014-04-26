//
//  DNCommentsViewController.h
//  The News
//
//  Created by Tosin Afolabi on 18/04/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNManager.h"
#import "TNCommentsViewController.h"

@interface DNCommentsViewController : TNCommentsViewController

@property (nonatomic, strong) NSNumber *replyToID;

- (instancetype)initWithStory:(DNStory *)story;

@end
