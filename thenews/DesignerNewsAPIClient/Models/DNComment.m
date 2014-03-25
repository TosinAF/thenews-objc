//
//  DNComment.m
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 21/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNComment.h"

@implementation DNComment

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    if (self) {
        [self setBody:dict[@"body"]];
        [self setAuthor:dict[@"user_display_name"]];
        [self setAuthorID:dict[@"user_id"]];
        [self setDepth:dict[@"depth"]];
        [self setVoteCount:dict[@"vote_count"]];
        [self setCommentID:dict[@"id"]];
        [self setCreatedAt:[self formatDate:dict[@"created_at"]]];
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
