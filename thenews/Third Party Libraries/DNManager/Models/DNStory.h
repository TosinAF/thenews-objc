//
//  DNStory.h
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 21/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNComment.h"

@interface DNStory : NSObject

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSNumber *storyID;
@property (nonatomic, copy) NSString *siteURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, strong) NSNumber *voteCount;
@property (nonatomic, strong) NSNumber *commentCount;

@property (nonatomic, copy) NSNumber *userID;
@property (nonatomic, copy) NSString *displayName;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
