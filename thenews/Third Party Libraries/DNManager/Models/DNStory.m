//
//  DNStory.m
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 21/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNStory.h"

@implementation DNStory

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    if (self) {
        [self setStoryID:dict[@"id"]];
        [self setTitle:dict[@"title"]];
        [self setURL:dict[@"url"]];
        [self setSiteURL:dict[@"site_url"]];
        [self setVoteCount:dict[@"vote_count"]];
        [self setCommentCount:dict[@"comment_count"]];
        [self setCreatedAt:[self formatDate:dict[@"created_at"]]];
        [self setUserID:dict[@"user_id"]];
        [self setDisplayName:dict[@"user_display_name"]];
    }

    return self;
}

- (NSDate *)formatDate:(NSString *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY'-'MM'-'dd'T'HH':'mm':'ss'Z'"];

    NSDate *formattedDate = [format dateFromString:date];
    return formattedDate;
}


@end
