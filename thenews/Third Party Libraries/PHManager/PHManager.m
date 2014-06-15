//
//  PHManager.m
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHManager.h"

static NSString * const PHAPIBaseURLString  = @"http://hook-api.herokuapp.com";

@implementation PHManager

+ (instancetype)sharedManager {

    static PHManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PHManager alloc] initWithBaseURL:[NSURL URLWithString:PHAPIBaseURLString]];
    });

    return _sharedClient;
}

- (void)getTodaysProductsWithSuccess:(void (^) (NSArray *products))success
                             failure:(RequestFailureBlock)failure
{
    NSMutableArray *products = [NSMutableArray new];
    NSString *resourceURL = [NSString stringWithFormat:@"%@/today", PHAPIBaseURLString];

    [self GET:resourceURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        for (NSDictionary *product in responseObject[@"hunts"]) {
            [products addObject:[[PHProduct alloc] initWithDictionary:product]];
        }

        // Sort Products Dependent on Rank

        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedProducts = [[products sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];

        success(sortedProducts);

    } failure:failure];
}

- (void)getCommentsForProduct:(PHProduct *)product
                      success:(void (^) (NSArray *comments))success
                      failure:(RequestFailureBlock)failure
{
    NSMutableArray *comments = [NSMutableArray new];
    NSString *resourceURL = [NSString stringWithFormat:@"%@/%@", PHAPIBaseURLString, [product permalink]];

    [self GET:resourceURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        for (NSDictionary *comment in responseObject[@"comments"]) {
            [comments addObject:[[PHComment alloc] initWithDictionary:comment]];
        }

        success(comments);
        
    } failure:failure];
}


@end
