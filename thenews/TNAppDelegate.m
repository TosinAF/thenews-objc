//
//  TNAppDelegate.m
//  thenews
//
//  Created by Tosin Afolabi on 30/01/2014.
//  Copyright (c) 2014 Tosin Afolabi. All rights reserved.
//

#import "libHN.h"
#import "DNManager.h"
#import "PocketAPI.h"
#import "OSKADNLoginManager.h"
#import "GTScrollNavigationBar.h"
#import "TNLaunchViewController.h"
#import "TNHomeViewController.h"
#import <GooglePlus/GooglePlus.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "TNAppDelegate.h"

@implementation TNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor tnLightGreyColor];

    // Set up defaults

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:16.0f], NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];

    // Network Stuff & API's

    [[PocketAPI sharedAPI] setConsumerKey:@"25320-2c296baa9f562cd41e0259f9"];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    [[HNManager sharedManager] startSession];

    // Check for App First Start

    UIViewController *rootViewController;

    // change to or

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"appFirstStart"] && ![[DNManager sharedManager] isUserAuthenticated]) {

        rootViewController = [TNLaunchViewController new];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"appFirstStart"];

    } else {

        rootViewController = [TNHomeViewController new];
    }

    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class] toolbarClass:nil];

    [navController setViewControllers:@[rootViewController] animated:NO];
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    return YES;
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

# pragma mark - Managing the Network Activity Indicator

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {

    static NSInteger NumberOfCallsToSetVisible = 0;

    if (setVisible)
        NumberOfCallsToSetVisible++;
    else
        NumberOfCallsToSetVisible--;

    // The assertion helps to find programmer errors in activity indicator management.
    // Since a negative NumberOfCallsToSetVisible is not a fatal error,
    // it should probably be removed from production code.
    NSAssert(NumberOfCallsToSetVisible >= 0, @"Network Activity Indicator was asked to hide more often than shown");

    // Display the indicator as long as our static counter is > 0.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}

# pragma mark - Share Kit Methods

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

@end
