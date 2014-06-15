//
//  PHUser.h
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *username;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
