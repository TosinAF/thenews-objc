//
//  DesignerNewsAPIClient.m
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 21/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//


#import "DNManager.h"

static NSString * const DNAPIAccessTokenKey = @"DNAPIAccessTokenKey";
static NSString * const DNAPIBaseURLString  = @"https://api-news.layervault.com/api/v1";
static NSString * const DNAPIClientID       = @"3ba6addb82f5746189bbf3e59ac06a0d498f02309ae4d7119655be174528ad44";
static NSString * const DNAPIClientSecret   = @"29f00d2f31eb18f622f55b30cdb1b745e45e940bc7a6192014a0131f40397f78";

@interface DNManager ()

@property (nonatomic, strong) NSMutableArray *allCommentsForStory;

@end

@implementation DNManager


#pragma mark - Singleton Method

+ (instancetype)sharedManager {

    static DNManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DNManager alloc] initWithBaseURL:[NSURL URLWithString:DNAPIBaseURLString]];
    });

    return _sharedClient;
}

#pragma mark - Authentication methods

- (void)authenticateUser:(NSString *)username
                password:(NSString *)password
                 success:(void (^) (NSString *accessToken))success
                 failure:(RequestFailureBlock)failure
{
    NSString *authURL = @"https://api-news.layervault.com/oauth/token";
    NSDictionary *parameters = @{@"grant_type" : @"password",
                                 @"username" : username,
                                 @"password" : password,
                                 @"client_id": DNAPIClientID,
                                 @"client_secret" : DNAPIClientSecret };

    [self POST:authURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *accessToken = responseObject[@"access_token"];

        // Store Access Token
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:DNAPIAccessTokenKey];
        [defaults synchronize];

        success(accessToken);

    } failure:failure];
}

- (BOOL)isUserAuthenticated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:DNAPIAccessTokenKey];

    if ( accessToken == Nil ) {
        return false;
    }
    return true;
}

- (void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:DNAPIAccessTokenKey];
    [defaults synchronize];
}

#pragma mark - DN User Methods

- (void)getUserInfo:(void (^) (DNUser *userInfo))success
            failure:(RequestFailureBlock)failure
{
    NSString *resourceURL = [NSString stringWithFormat:@"%@/me", DNAPIBaseURLString];

    NSString *accessToken = [self getAccessToken];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];

    [self GET:resourceURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        DNUser *userInfo = [[DNUser alloc] initWithDictionary:responseObject[@"me"]];
        success(userInfo);

    } failure:failure];
}

#pragma mark - DN Search Methods

- (void)search:(NSString *)searchQuery
         success:(void (^) (NSArray *dnStories))success
         failure:(RequestFailureBlock)failure
{
    NSMutableArray *stories = [NSMutableArray new];

    NSString *resourceURL = [NSString stringWithFormat:@"%@/stories/search", DNAPIBaseURLString];
    NSDictionary *parameters = @{@"query":searchQuery, @"client_id":DNAPIClientID};
    NSLog(@"%@", resourceURL);

    [self GET:resourceURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        for (NSDictionary *story in responseObject) {
            [stories addObject:[[DNStory alloc] initWithDictionary:story]];
        }

        success([NSArray arrayWithArray:stories]);
        
    } failure:failure];
}

#pragma mark - DN Story Methods

- (void)getStoriesOnPage:(NSString *)page
                feedType:(DNFeedType)feedType
                 success:(void (^) (NSArray *dnStories))success
                 failure:(RequestFailureBlock)failure

{
    NSString *resourceURL;

    switch (feedType) {

        case DNFeedTypeTop:
        default:
            resourceURL = [NSString stringWithFormat:@"%@/stories", DNAPIBaseURLString];
            break;

        case DNFeedTypeRecent:
            resourceURL = [NSString stringWithFormat:@"%@/stories/recent", DNAPIBaseURLString];
            break;
    }

    NSDictionary *parameters = @{@"page":page, @"client_id": DNAPIClientID};

    [self getStories:resourceURL parameters:parameters success:success failure:failure];
}

- (void)getStoryWithID:(NSString *)storyID
                success:(void (^) (DNStory *story))success
                failure:(RequestFailureBlock)failure
{
    NSString *resourceURL = [NSString stringWithFormat:@"%@/stories/%@", DNAPIBaseURLString, storyID];
    NSDictionary *parameters = @{@"client_id": DNAPIClientID};

    [self GET:resourceURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        DNStory *story = [[DNStory alloc] initWithDictionary:responseObject[@"story"]];
        success(story);

    } failure:failure];

}

- (void)upvoteStoryWithID:(NSString *)storyID
                  success:(ActionSuccessBlock)success
                  failure:(RequestFailureBlock)failure
{
    [self performActionOnObjectWithID:storyID
                               object:DNObjectTypeStory
                               action:DNActionTypeUpvote
                              comment:nil
                              success:success
                              failure:failure];
}

- (void)replyStoryWithID:(NSString *)storyID
                 comment:(NSString *)comment
                 success:(ActionSuccessBlock)success
                 failure:(RequestFailureBlock)failure
{
    [self performActionOnObjectWithID:storyID
                               object:DNObjectTypeStory
                               action:DNActionTypeReply
                              comment:comment
                              success:success
                              failure:failure];
}

#pragma mark - DN Comment Methods

- (void)getCommentsForStoryWithID:(NSString *)storyID
                          success:(void (^) (NSArray *comments))success
                          failure:(RequestFailureBlock)failure
{
    NSString *resourceURL = [NSString stringWithFormat:@"%@/stories/%@", DNAPIBaseURLString, storyID];
    NSDictionary *parameters = @{@"client_id": DNAPIClientID};

    self.allCommentsForStory = [[NSMutableArray alloc] init];

    [self GET:resourceURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        [self collapseNestedComments:[responseObject[@"story"] objectForKey:@"comments"]];
        success([NSArray arrayWithArray:self.allCommentsForStory]);
        self.allCommentsForStory = nil;

    } failure:failure];
}

- (void)upvoteCommentWithID:(NSString *)commentID
                  success:(ActionSuccessBlock)success
                  failure:(RequestFailureBlock)failure
{
    [self performActionOnObjectWithID:commentID
                               object:DNObjectTypeComment
                               action:DNActionTypeUpvote
                              comment:nil
                              success:success
                              failure:failure];
}



- (void)replyCommentWithID:(NSString *)commentID
                   comment:(NSString *)comment
                   success:(ActionSuccessBlock)success
                   failure:(RequestFailureBlock)failure
{
    [self performActionOnObjectWithID:commentID
                               object:DNObjectTypeComment
                               action:DNActionTypeReply
                              comment:comment
                              success:success
                              failure:failure];
}

#pragma mark - DN MOTD Methods

- (void)getMOTD:(void (^) (DNMOTD *motd))success
        failure:(RequestFailureBlock)failure
{
    NSString *resourceURL = [NSString stringWithFormat:@"%@/motd", DNAPIBaseURLString];
    NSDictionary *parameters = @{@"client_id": DNAPIClientID};

    [self GET:resourceURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        DNMOTD *motd = [[DNMOTD alloc] initWithDictionary:responseObject[@"motd"]];
        success(motd);

    } failure:failure];
}

- (void)upvoteMOTD:(void (^) (NSURLSessionDataTask *task, id responseObject))success
           failure:(RequestFailureBlock)failure
{
    [self performActionOnMOTD:@"upvote" success:success failure:failure];
}

- (void)downvoteMOTD:(void (^) (NSURLSessionDataTask *task, id responseObject))success
             failure:(RequestFailureBlock)failure
{
    [self performActionOnMOTD:@"downvote" success:success failure:failure];
}

#pragma mark - Auxillary Methods

- (void)cancelAllRequests
{
    [self.operationQueue cancelAllOperations];
}

#pragma mark - Private Methods

- (NSString *)getAccessToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [defaults objectForKey:DNAPIAccessTokenKey];

    return accessToken;
}

- (void)getStories:(NSString *)resourceURL
        parameters:(NSDictionary *)parameters
           success:(void (^) (NSArray *dnStories))success
           failure:(RequestFailureBlock)failure

{
    NSMutableArray *stories = [NSMutableArray new];

    [self GET:resourceURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {

        for (NSDictionary *story in responseObject[@"stories"]) {
            [stories addObject:[[DNStory alloc] initWithDictionary:story]];
        }

        success([NSArray arrayWithArray:stories]);

    } failure:failure];
}

- (void)performActionOnObjectWithID:(NSString *)objectID
                             object:(DNObjectType)objectType
                             action:(DNActionType)actionType
                            comment:(NSString *)comment
                            success:(ActionSuccessBlock)success
                            failure:(RequestFailureBlock)failure
{
    NSString *object, *action;

    switch (objectType) {
        case DNObjectTypeStory:
            object = @"stories";
            break;

        case DNObjectTypeComment:
            object = @"comments";

            break;
    }

    switch (actionType) {
        case DNActionTypeUpvote:
            action = @"upvote";
            break;

        case DNActionTypeReply:
            action = @"reply";
            break;
    }

    NSString *resourceURL = [NSString stringWithFormat:@"%@/%@/%@/%@", DNAPIBaseURLString, object, objectID, action];
    NSLog(@"%@", resourceURL);

    NSString *accessToken = [self getAccessToken];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];


    if (actionType == DNActionTypeReply) {

        [self POST:resourceURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFormData:[comment dataUsingEncoding:NSUTF8StringEncoding] name:@"comment[body]"];
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            success();
        } failure:failure];

    } else {

        [self POST:resourceURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            success();
        } failure:failure];
    }
}

- (void)performActionOnMOTD:(NSString *)actionType
                    success:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                    failure:(RequestFailureBlock)failure
{

    NSString *resourceURL = [NSString stringWithFormat:@"%@/motd/%@", DNAPIBaseURLString, actionType];

    NSString *accessToken = [self getAccessToken];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];

    [self POST:resourceURL parameters:nil success:success failure:failure];
}

- (void)collapseNestedComments:(NSDictionary*)dict {

    for (id comment in dict) {

        DNComment *x = [[DNComment alloc] initWithDictionary:comment];
        [self.allCommentsForStory addObject:x];

        if (comment[@"comments"] != Nil) {
            [self collapseNestedComments:comment[@"comments"]];
        }
    }
    
    return;
}

@end
