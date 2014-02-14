//
//  Post.h
//  The News
//
//  Created by Tosin Afolabi on 12/02/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *authorLink;
@property (strong, nonatomic) NSNumber *comments;
@property (strong, nonatomic) NSString *commentsLink;
@property (strong, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSNumber *points;
@property (strong, nonatomic) NSNumber *position;
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *updatedAt;

@end
