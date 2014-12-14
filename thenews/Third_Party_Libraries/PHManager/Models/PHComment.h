//
//  PHComment.h
//  The News
//
//  Created by Tosin Afolabi on 14/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHUser.h"
#import <Foundation/Foundation.h>

@interface PHComment : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *postID;
@property (nonatomic, strong) NSNumber *parentCommentID;
@property (nonatomic, strong) NSNumber *childCommentsCount;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSArray *childComments;
@property (nonatomic, strong) PHUser *hunter;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
