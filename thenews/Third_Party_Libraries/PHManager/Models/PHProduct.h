//
//  PHProduct.h
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHUser.h"
#import <Foundation/Foundation.h>

@interface PHProduct : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tagline;
@property (nonatomic, strong) NSNumber *upvotes;
@property (nonatomic, strong) NSNumber *commentsCount;
@property (nonatomic, copy) NSString *nameWithTagline;
@property (nonatomic, copy) NSString *discussionURL;
@property (nonatomic, copy) NSString *redirectURL;

@property (nonatomic, strong) PHUser *hunter;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
