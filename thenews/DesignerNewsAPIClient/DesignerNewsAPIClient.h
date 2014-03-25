//
//  DesignerNewsAPIClient.h
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 21/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNMOTD.h"
#import "DNUser.h"
#import "DNStory.h"
#import "DNComment.h"
#import "AFHTTPSessionManager.h"

typedef NS_ENUM (NSInteger, DNFeedType) {
	DNFeedTypeTop,
	DNFeedTypeRecent
};

typedef NS_ENUM (NSInteger, DNActionType) {
	DNActionTypeUpvote,
	DNActionTypeReply,
};

typedef NS_ENUM (NSInteger, DNObjectType) {
	DNObjectTypeStory,
	DNObjectTypeComment,
};

typedef void (^ActionSuccessBlock) ();
typedef void (^RequestFailureBlock) (NSURLSessionDataTask *task, NSError *error);

@interface DesignerNewsAPIClient : AFHTTPSessionManager

#pragma mark - Singleton Method

+ (instancetype)sharedClient;

#pragma mark - Authentication methods

- (void)authenticateUser:(NSString *)username
                password:(NSString *)password
                 success:(void (^) (NSString *accessToken))success
                 failure:(RequestFailureBlock)failure;

- (BOOL)isUserAuthenticated;

- (void)signOut;

#pragma mark - DN User Methods

- (void)getUserInfo:(void (^) (DNUser *userInfo))success
            failure:(RequestFailureBlock)failure;

#pragma mark - DN Search Methods

- (void)search:(NSString *)searchQuery
         success:(void (^) (NSArray *dnStories))success
         failure:(RequestFailureBlock)failure;

#pragma mark - DN Story Methods

- (void)getStoriesOnPage:(NSString *)page
                feedType:(DNFeedType)feedType
                 success:(void (^) (NSArray *dnStories))success
                 failure:(RequestFailureBlock)failure;

- (void)getStoryWithID:(NSString *)storyID
               success:(void (^) (DNStory *story))success
               failure:(RequestFailureBlock)failure;

- (void)upvoteStoryWithID:(NSString *)storyID
                  success:(ActionSuccessBlock)success
                  failure:(RequestFailureBlock)failure;


- (void)replyStoryWithID:(NSString *)storyID
                 comment:(NSString *)comment
                 success:(ActionSuccessBlock)success
                 failure:(RequestFailureBlock)failure;

#pragma mark - DN Comment Methods

- (void)getCommentsForStoryWithID:(NSString *)storyID
                          success:(void (^) (NSArray *comments))success
                          failure:(RequestFailureBlock)failure;

- (void)upvoteCommentWithID:(NSString *)storyID
                    success:(ActionSuccessBlock)success
                    failure:(RequestFailureBlock)failure;

- (void)replyCommentWithID:(NSString *)storyID
                   comment:(NSString *)comment
                   success:(ActionSuccessBlock)success
                   failure:(RequestFailureBlock)failure;

#pragma mark - DN MOTD Methods

- (void)upvoteMOTD:(void (^) (NSURLSessionDataTask *task, id responseObject))success
           failure:(RequestFailureBlock)failure;

- (void)downvoteMOTD:(void (^) (NSURLSessionDataTask *task, id responseObject))success
             failure:(RequestFailureBlock)failure;

@end
