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
#import "KGModal.h"
#import "CampaignDetailView.h"
#import "ActionCenterManager.h"

@interface AppDelegate ()<MSDynamicsDrawerViewControllerDelegate>
{
    BOOL hideMenu;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[CrashlyticsKit, TwitterKit]];
    
    // Set up Parse for Push Notifications
    [Parse setApplicationId:kParseAppId
                  clientKey:kParseClientKey];
    // Register for Push Notitications
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:settings];
    } else {
        //[application registerForRemoteNotificationTypes:<#(UIRemoteNotificationType)#>
    }
    [application registerForRemoteNotifications];
    
    

    //Setup Global Colors
    [[UINavigationBar appearance] setBarTintColor:kAHABlue];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UIToolbar appearance] setTintColor:kAHARed]; // this will change the back button tint
    //[[UIToolbar appearance] setBarTintColor:[UIColor lightGrayColor]];
    //[[UIToolbar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kAHARed}];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    MenuViewController *menuViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"menu"];
    menuViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    UINavigationController *menuNav = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    menuNav.toolbarHidden = NO;
    
    MainViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"main"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.toolbarHidden = NO;
    
    hideMenu = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _splitViewController = [[UISplitViewController alloc] init];
        _splitViewController.viewControllers = @[menuNav, nav];
        _splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.rootViewController = _splitViewController;
    }
    else {
        // Setup Side Menu
        _dynamicsDrawerViewController = [MSDynamicsDrawerViewController new];
        
        MSDynamicsDrawerResizeStyler *resize = [MSDynamicsDrawerResizeStyler styler];
        resize.minimumResizeRevealWidth = 40.0;
        [_dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerScaleStyler styler], [MSDynamicsDrawerFadeStyler styler], [MSDynamicsDrawerParallaxStyler styler], resize] forDirection:MSDynamicsDrawerDirectionLeft];
        
        [_dynamicsDrawerViewController setDrawerViewController:menuNav forDirection:MSDynamicsDrawerDirectionLeft];
        
        _dynamicsDrawerViewController.paneViewController = nav;
        // End Side Menu Setup

        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.rootViewController = _dynamicsDrawerViewController;
    }
    [self getFeed];
    [self checkRequired];
    
    [_window makeKeyAndVisible];
    
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    NSUInteger orientations = UIInterfaceOrientationMaskAll;
    
    return orientations;
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

- (void)checkVoterVoice {
    ActionCenterManager *action = [ActionCenterManager sharedInstance];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:@"user"] && [prefs objectForKey:@"email"] && ![prefs boolForKey:@"inVoterVoice"]) {
        OAM *oam = [[OAM alloc] initWithJSONData:[prefs objectForKey:@"user"]];
        if (oam.prefix != nil) {
            [action createUser:oam
                     withEmail:[prefs objectForKey:@"email"]
                    completion:^(NSString *userId, NSString *token, NSError *err) {
                        //NSLog(@"error %@ ----%@", userId, token);
                        if (!err && userId != nil) {
                            //VoterVoiceBody *body = voter.response.body[0];
                            //[hud showHUDSucces:YES withMessage:@"Success"];
                            NSLog(@"created %@", userId);
                            [prefs setBool:YES forKey:@"isLoggedIn"];
                            [prefs setBool:YES forKey:@"inVoterVoice"];
                            [prefs setBool:YES forKey:@"showTip"];
                            //[prefs setObject:_emailField.text forKey:@"email"];
                            [prefs setObject:token forKey:@"token"];
                            [prefs setObject:userId forKey:@"userId"];
                            [prefs synchronize];
                            //[self dismissViewControllerAnimated:YES completion:nil];
                        }
                        else {
                            //[self bypassVoterVoice];
                            [prefs setBool:NO forKey:@"inVoterVoice"];
                        }
                    }];
        }
        else {
            [prefs setBool:YES forKey:@"inVoterVoice"];
        }
            }
    else {
        [prefs setBool:NO forKey:@"inVoterVoice"];
    }
    [prefs synchronize];
}

- (void)checkAddress {
     ActionCenterManager *action = [ActionCenterManager sharedInstance];
    [action verifyAddress:@"155 N Wacker Dr" withZip:@"60606" andCountry:@"US" completion:^(NSDictionary *dict, NSError *err) {
        //NSLog(@"-----------------------%@----------------------", voter.response);
    }];
}

- (void)checkRequired {
    ActionCenterManager *action = [ActionCenterManager sharedInstance];
    [action getRequiredFields:@"E" withTargetId:@"40410" completion:^(NSDictionary *dict, NSError *err) {
        NSArray *arr = (NSArray *)[dict valueForKeyPath:@"response.body"];
        for (NSDictionary *d in arr) {
            if ([d[@"deliveryMethod"] isEqualToString:@"webform"]) {
                NSLog(@"%@", d[@"requiredUserFields"]);
            }
        }
    }];
}

- (void)getFeed
{
    ActionCenterManager *action = [ActionCenterManager sharedInstance];
    [action getAHAFeed:^(NSArray *feeds, NSArray *alerts, NSError *error){
        //NSLog(@"Feed %@", feeds);
        if (!error && feeds.count > 0) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:feeds];
            [prefs setObject:dataSave forKey:@"feeds"];
            [prefs synchronize];
            
        }
        //NSLog(@"feeds %@", action.alerts);
        [self checkForNotifications];
    }];
}

- (void)checkForNotifications {
    ActionCenterManager *action = [ActionCenterManager sharedInstance];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //[prefs setObject:nil forKey:@"lastNotification"];
    NSLog(@"last id %@", [prefs objectForKey:@"lastNotification"]);
    if (action.alerts.count > 0 && [prefs boolForKey:@"isLoggedIn"]) {
       double timeNow = (double)[[NSDate date] timeIntervalSince1970];
        //NSPredicate *pred = [NSPredicate predicateWithFormat:@"(%f <= end_date_unix)", timeNow];
        NSDictionary *alert = (NSDictionary *)action.alerts[0];
         NSLog(@"alert %@", alert[@"id"]);
        NSString *lastNotification = [prefs objectForKey:@"lastNotification"];
        //NSArray *filtered = [action.alerts filteredArrayUsingPredicate:pred];
        if ([alert[@"end_date_unix"] doubleValue] >=  timeNow && ![lastNotification isEqualToString:alert[@"id"]]) {
            //NSDictionary *alert = (NSDictionary *)filtered[0];
            
            if (lastNotification ==  nil || ![lastNotification isEqualToString:alert[@"id"]]) {
                CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
                [detailView setHeader:@""];
                [detailView loadHTMLString:alert[@"message"]];
                [detailView setButtonTitle:@"Close"];
                detailView.sendButtonTapped = ^(){
                    [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                    }];
                };
                [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
                [prefs setObject:alert[@"id"] forKey:@"lastNotification"];
                [prefs synchronize];
            }
        }
    }
}

- (void)testCalendar
{
    ActionCenterManager *action = [ActionCenterManager sharedInstance];
    [action getAHACalendar:^(AHACalendar *calendar, NSError *error){
        //NSLog(@"calendar %@", calendar);
    }];
}

- (void)toggleMenu {
    if (!hideMenu) {
        [_splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
    }
    else {
        [_splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModePrimaryHidden];
    }
    hideMenu = !hideMenu;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
    //barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    //[self.navigationItem setLeftBarButtonItem:barButtonItem
                                     //animated:YES];
    //self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    //[self.navigationItem setLeftBarButtonItem:nil animated:YES];
    //self.masterPopoverController = nil;
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
    [self getFeed];
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
    currentInstallation.channels = @[ @"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
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
