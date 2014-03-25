//
//  DNMOTD.h
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 25/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNMOTD : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, strong) NSNumber *upvoteCount;
@property (nonatomic, strong) NSNumber *downvoteCount;

@end
