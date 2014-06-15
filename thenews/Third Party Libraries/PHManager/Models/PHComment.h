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

@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *commentHTML;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, strong) PHUser *hunter;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
