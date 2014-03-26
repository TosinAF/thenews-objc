//
//  TNCommentCell.m
//  The News
//
//  Created by App Requests on 3/25/14.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "TNCommentCell.h"

@implementation TNCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, 300, 100)];
        self.commentTextView.textColor = [UIColor blackColor];
        self.commentTextView.editable = NO;
        self.commentTextView.text = @"Comment String";
        [self addSubview:self.commentTextView];
        
        self.commentAuthorLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 110, 250, 15)];
        self.commentAuthorLabel.textColor = [UIColor blackColor];
        self.commentAuthorLabel.text = @"Comment Author";
        [self addSubview:self.commentAuthorLabel];
        
        #warning Why won't this button appear?
        UIButton *upvoteButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 110, 50, 15)];
        upvoteButton.titleLabel.text = @"Upvote";
        [self addSubview:upvoteButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
