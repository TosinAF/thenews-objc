//
//  DNUser.h
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 22/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNUser : NSObject

@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *portraitURL;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSDate *createdAt;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
