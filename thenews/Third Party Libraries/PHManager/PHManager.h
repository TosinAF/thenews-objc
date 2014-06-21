//
//  PHManager.h
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHUser.h"
#import "PHComment.h"
#import "PHProduct.h"
#import "AFHTTPSessionManager.h"

typedef void (^ActionSuccessBlock) ();
typedef void (^RequestFailureBlock) (NSURLSessionDataTask *task, NSError *error);

@interface PHManager : AFHTTPSessionManager

#pragma mark - Singleton Method

+ (instancetype)sharedManager;

- (void)getTodaysProductsWithSuccess:(void (^) (NSArray *products))success
                             failure:(RequestFailureBlock)failure;

- (void)getCommentsForProduct:(PHProduct *)product
                      success:(void (^) (NSArray *comments))success
                      failure:(RequestFailureBlock)failure;

@end
