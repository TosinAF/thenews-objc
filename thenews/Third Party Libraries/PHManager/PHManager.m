//
//  PHManager.m
//  The News
//
//  Created by Tosin Afolabi on 13/06/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PHManager.h"

static NSString * const PHAPIBaseURLString      = @"https://api.producthunt.com/v1";
static NSString * const PHAPIClientID           = @"7f42a1a52a449fcd9b664ce2cf875564e1f5066c13531e31d307daafb8f630fc";
static NSString * const PHAPIClientSecret       = @"a2de27344ee25af63b97e8479602d7e0a113592b6d0554f22c4541cc28c3f291";

static NSString * const PHReadPostsKey                      = @"PHReadPostsKey";
static NSString * const PHReadPostsCacheDateKey             = @"PHReadPostsCacheDateKey";
static NSString * const PHClientAccessTokenKey              = @"PHClientAccessToken";
static NSString * const PHClientAccessTokenExpiryKey        = @"PHClientAccessTokenExpiry";
static NSString * const PHClientAccessTokenCreationDateKey  = @"PHClientAccessTokenCreationDate";

@implementation PHManager

+ (instancetype)sharedManager {

    static PHManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PHManager alloc] initWithBaseURL:[NSURL URLWithString:PHAPIBaseURLString]];
        [_sharedClient requestClientTokenWithCompletionHandler:nil];
    });

    return _sharedClient;
}

#pragma mark - Product Methods

- (void)getTodaysProductsWithSuccess:(void (^) (NSArray *products))success
                             failure:(RequestFailureBlock)failure
{
    if ([self hasClientTokenExpired]) {

        [self requestClientTokenWithCompletionHandler:^(NSString *clientAccessToken) {

            [self getProductsForDay:@(0) usingAccessToken:clientAccessToken withSuccess:success failure:failure];
        }];

    } else {

        NSString *clientAccessToken = [self retrieveClientAccessToken];
        [self getProductsForDay:@(0) usingAccessToken:clientAccessToken withSuccess:success failure:failure];

    }
}

- (void)getProductsForDay:(NSNumber *)day
              withSuccess:(void (^) (NSArray *products))success
                  failure:(RequestFailureBlock)failure
{
    if ([self hasClientTokenExpired]) {

        [self requestClientTokenWithCompletionHandler:^(NSString *clientAccessToken) {

            [self getProductsForDay:day usingAccessToken:clientAccessToken withSuccess:success failure:failure];
        }];

    } else {

        NSString *clientAccessToken = [self retrieveClientAccessToken];
        [self getProductsForDay:day usingAccessToken:clientAccessToken withSuccess:success failure:failure];

    }
}

- (void)getProductsForDay:(NSNumber *)day
         usingAccessToken:(NSString *)clientAccessToken
              withSuccess:(void (^) (NSArray *products))success
                  failure:(RequestFailureBlock)failure
{
    NSMutableArray *products = [NSMutableArray new];
    NSString *resourceURL = [NSString stringWithFormat:@"%@/posts", PHAPIBaseURLString];

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", clientAccessToken] forHTTPHeaderField:@"Authorization"];

    [self GET:resourceURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        for (NSDictionary *product in responseObject[@"posts"]) {
            [products addObject:[[PHProduct alloc] initWithDictionary:product]];
        }

        success(products);

    } failure:failure];
}

#pragma mark - Comments Methods

- (void)getCommentsForProduct:(PHProduct *)product
                      success:(void (^) (NSArray *comments))success
                      failure:(RequestFailureBlock)failure
{
    if ([self hasClientTokenExpired]) {

        [self requestClientTokenWithCompletionHandler:^(NSString *clientAccessToken) {

            [self getCommentsForProduct:product usingAccessToken:clientAccessToken success:success failure:failure];

        }];

    } else {

        NSString *clientAccessToken = [self retrieveClientAccessToken];
        [self getCommentsForProduct:product usingAccessToken:clientAccessToken success:success failure:failure];
    }
}

- (void)getCommentsForProduct:(PHProduct *)product
             usingAccessToken:(NSString *)clientAccessToken
                      success:(void (^) (NSArray *comments))success
                      failure:(RequestFailureBlock)failure
{

    NSMutableArray *comments = [NSMutableArray new];
    NSString *resourceURL = [NSString stringWithFormat:@"%@/posts/%@", PHAPIBaseURLString, [product id]];

    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", clientAccessToken] forHTTPHeaderField:@"Authorization"];

    [self GET:resourceURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        for (NSDictionary *comment in responseObject[@"post"][@"comments"]) {
            [comments addObject:[[PHComment alloc] initWithDictionary:comment]];
        }

        success(comments);
        
    } failure:failure];


}

#pragma mark - Tracking Read Posts

- (BOOL)hasUserReadStory:(NSNumber *)id
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *currentReadArticles = [defaults arrayForKey:PHReadPostsKey];

    return [currentReadArticles containsObject:id];
}

- (void)checkReadPostsCache
{
    NSDate *cacheDate = [[NSUserDefaults standardUserDefaults] objectForKey:PHReadPostsCacheDateKey];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (!cacheDate) {
        [defaults setObject:[NSDate date] forKey:PHReadPostsCacheDateKey];
        return;
    }

    int diff = abs([cacheDate timeIntervalSinceNow]);
    if (diff > 60 * 60 * 24 * 3) {
        [defaults setObject:[NSArray new] forKey:PHReadPostsKey];
    }
}

- (void)addStoryToReadList:(NSNumber *)id
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *currentReadArticles = [defaults arrayForKey:PHReadPostsKey];

    if ([self hasUserReadStory:id]) {
        return;
    }

    NSMutableArray *newReadArticles = [NSMutableArray arrayWithArray:currentReadArticles];
    [newReadArticles addObject:id];

    [defaults setObject:[NSArray arrayWithArray:newReadArticles] forKey:PHReadPostsKey];
    [defaults synchronize];
}

#pragma mark - Client Tokens

- (BOOL)hasClientTokenExpired
{
    NSNumber *tokenExpiry = [[NSUserDefaults standardUserDefaults] objectForKey:PHClientAccessTokenExpiryKey];
    NSDate *tokenCreationDate = [[NSUserDefaults standardUserDefaults] objectForKey:PHClientAccessTokenCreationDateKey];

    int diff = abs([tokenCreationDate timeIntervalSinceNow]);
    return diff >= [tokenExpiry intValue];
}

- (void)requestClientTokenWithCompletionHandler:(void (^)(NSString *clientAccessToken))handler
{
    NSString *resourceURL = [NSString stringWithFormat:@"%@/oauth/token", PHAPIBaseURLString];

    NSDictionary *parameters = @{@"client_id": PHAPIClientID,
                                 @"client_secret" : PHAPIClientSecret,
                                 @"grant_type" : @"client_credentials"};

    [self POST:resourceURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        NSString *clientAccessToken = responseObject[@"access_token"];
        NSNumber *clientAccessTokenExpiry = responseObject[@"expires_in"];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:clientAccessToken forKey:PHClientAccessTokenKey];
        [defaults setObject:clientAccessTokenExpiry forKey:PHClientAccessTokenExpiryKey];
        [defaults setObject:[NSDate date] forKey:PHClientAccessTokenCreationDateKey];
        [defaults synchronize];

        if (handler) {
            handler(clientAccessToken);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSLog(@"Error - %@", error);

    }];
}

- (NSString *)retrieveClientAccessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:PHClientAccessTokenKey];
    
    return accessToken;
}

@end
