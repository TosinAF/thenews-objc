//
//  TNContainerViewController.h
//  The News
//
//  Created by Tosin Afolabi on 11/03/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNContainerViewController : UIViewController

@property (nonatomic, strong) NSNumber *feedType;

- (id)initWithType:(TNType)type;

@end
