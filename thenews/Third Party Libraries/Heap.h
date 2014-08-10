//
//  Heap.h
//  Version 1.2.0
//  Copyright (c) 2014 Heap Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Heap : NSObject

// Return the version number of the Heap library.
+ (NSString * const)libVersion;

// Return the Heap-generated user ID of the current user.
+ (NSString * const)userId;

// Set the app ID for your project, and begin tracking events automatically.
+ (void)setAppId:(NSString *)newAppId;

// Start debug mode. Displays Heap activity via NSLog.
+ (void)startDebug;

// Stop debug mode.
+ (void)stopDebug;

// Attach meta-level properties to the user (e.g. email, handle).
+ (void)identify:(NSDictionary *)properties;

// Track a custom event with optional key-value properties.
+ (void)track:(NSString *)event;
+ (void)track:(NSString *)event withProperties:(NSDictionary *)properties;

// Change the frequency at which data is sent to Heap. Default is 15 seconds.
+ (void)changeInterval:(double)interval;

@end
