//
//  TNAppDelegate.m
//  thenews
//
//  Created by Tosin Afolabi on 30/01/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "PocketAPI.h"
#import "TNAppDelegate.h"
#import "OSKADNLoginManager.h"
#import "GTScrollNavigationBar.h"
#import "TNLaunchViewController.h"
#import <GooglePlus/GooglePlus.h>

@implementation TNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor tnLightGreyColor];

    [[PocketAPI sharedAPI] setConsumerKey:@"25320-2c296baa9f562cd41e0259f9"];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:16.0f], NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];

    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];
    TNLaunchViewController *launchViewController = [[TNLaunchViewController alloc] init];

    [navController setViewControllers:@[launchViewController] animated:NO];

    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL success = NO;
    if ([[OSKADNLoginManager sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
        success = YES;
    }
    else if ([[PocketAPI sharedAPI] handleOpenURL:url]){
        success = YES;
    }
    else if ([GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation]) {
        success = YES;
    }
    else {
        // if you handle your own custom url-schemes, do it here
        // success = whatever;
    }
    return success;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
