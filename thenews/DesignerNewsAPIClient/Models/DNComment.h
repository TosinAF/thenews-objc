//
//  DNComment.h
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 21/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNComment : NSObject

@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, strong) NSNumber *authorID;
@property (nonatomic, strong) NSNumber *depth;
@property (nonatomic, strong) NSNumber *voteCount;
@property (nonatomic, strong) NSNumber *commentID;
@property (nonatomic, strong) NSDate *createdAt;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
