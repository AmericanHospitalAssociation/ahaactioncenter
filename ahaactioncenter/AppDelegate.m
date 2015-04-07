//
//  AppDelegate.m
//  ahaactioncenter
//
//  Created by Server on 4/4/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <Crashlytics/Crashlytics.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "MSDynamicsDrawerViewController.h"
#import "MSDynamicsDrawerStyler.h"
#import "MenuViewController.h"
#import "MainViewController.h"

#import "ActionCenterManager.h"

@interface AppDelegate ()<MSDynamicsDrawerViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[CrashlyticsKit, TwitterKit]];
    
    // Set up Parse for Push Notifications
    [Parse setApplicationId:kParseAppId
                  clientKey:kParseClientKey];
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    //Setup Global Colors
    [[UINavigationBar appearance] setBarTintColor:kAHABlue];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]]; // this will change the back button tint
    [[UIToolbar appearance] setBarTintColor:kAHARed];
    //[[UIToolbar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // Setup Side Menu
    _dynamicsDrawerViewController = [MSDynamicsDrawerViewController new];

    MSDynamicsDrawerResizeStyler *resize = [MSDynamicsDrawerResizeStyler styler];
    resize.minimumResizeRevealWidth = 40.0;
    [_dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler], [MSDynamicsDrawerParallaxStyler styler], resize] forDirection:MSDynamicsDrawerDirectionLeft];
    
    MenuViewController *menuViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"menu"];
    menuViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    UINavigationController *menuNav = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    [_dynamicsDrawerViewController setDrawerViewController:menuNav forDirection:MSDynamicsDrawerDirectionLeft];
    
    MainViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.toolbarHidden = NO;
    _dynamicsDrawerViewController.paneViewController = nav;
    // End Side Menu Setup
    [self testVoterVoice];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = _dynamicsDrawerViewController;
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)testVoterVoice
{
    ActionCenterManager *action = [ActionCenterManager sharedInstance];
    [action getOAMUser:@"vince.davis@icloud.com"
          withPassword:@"Welcome1"
            completion:^(OAM *oam, NSError *error){
                NSLog(@"error %@", error.description);
                if (error == nil) {
                    NSLog(@"OAM %@", oam.first_name);
                    
                    [action verifyUser:@"vince.davis@icloud.com"
                               withZip:oam.zip
                            completion:^(VoterVoice *voter, NSError *error){
                                if (error == nil) {
                                    VoterVoiceBody *v = voter.response.body[0];
                                    NSLog(@"Voter - %@", v.givenNames);
                                }
                            }];
                }
            }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

#pragma mark - Side Menu Methods
- (void)openSideMenu
{
    [_dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen
                                       animated:YES
                          allowUserInterruption:YES
                                     completion:nil];
}

@end
