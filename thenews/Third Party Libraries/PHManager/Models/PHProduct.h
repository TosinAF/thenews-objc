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

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tagline;
@property (nonatomic, copy) NSString *titleWithTagline;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *permalink;
@property (nonatomic, strong) NSNumber *rank;
@property (nonatomic, strong) NSNumber *voteCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) PHUser *hunter;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
