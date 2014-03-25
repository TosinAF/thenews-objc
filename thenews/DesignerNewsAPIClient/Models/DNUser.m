//
//  DNUser.m
//  DesignerNewsAPI
//
//  Created by Tosin Afolabi on 22/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "DNUser.h"

@implementation DNUser

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setJob:dict[@"job"]];
        [self setUserID:dict[@"id"]];
        [self setLastName:dict[@"last_name"]];
        [self setFirstName:dict[@"first_name"]];
        [self setDisplayName:dict[@"display_name"]];
        [self setPortraitURL:dict[@"portrait_url"]];
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
