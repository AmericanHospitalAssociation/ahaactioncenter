//
//  LoginViewController.m
//  ahaactioncenter
//
//  Created by Server on 4/5/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "LoginViewController.h"
#import "ActionCenterManager.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    ActionCenterManager *action;
    ProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Log In";
    action = [ActionCenterManager sharedInstance];
    hud = [ProgressHUD sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) launchURLInBrowser:(NSURL *)url {
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (void)bypassVoterVoice {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:YES forKey:@"isLoggedIn"];
    [hud showHUDSucces:YES withMessage:@"Success"];
    [prefs setBool:NO forKey:@"inVoterVoice"];
    [prefs setBool:YES forKey:@"showTip"];
    [prefs setObject:_emailField.text forKey:@"email"];
    [prefs synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"bypass");
}

- (void)registeredInVoterVoice {
    
}

+ (void)resetViews {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *sb = [[ad.window rootViewController] storyboard];
    MainViewController *main = (MainViewController *)[sb instantiateViewControllerWithIdentifier:@"main"];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:main];
    mainNav.toolbarHidden = NO;
    MenuViewController *menu = (MenuViewController *)[sb instantiateViewControllerWithIdentifier:@"menu"];
    UINavigationController *menuNav = [[UINavigationController alloc] initWithRootViewController:menu];
    menuNav.toolbarHidden = NO;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UISplitViewController *split = (UISplitViewController *)ad.splitViewController;
        [split setViewControllers:@[menuNav, mainNav]];
        //NSLog(@"ipad");
    }
    else {
        //NSLog(@"iphone");
        
        MSDynamicsDrawerViewController *dynamic = (MSDynamicsDrawerViewController *)ad.dynamicsDrawerViewController;
        [dynamic setPaneState:MSDynamicsDrawerPaneStateClosed];
        [dynamic setPaneViewController:mainNav animated:YES completion:nil];
    }
}

- (IBAction)login:(id)sender {
    [hud showHUDWithMessage:@"Checking User"];
    if ([action isReachable]) {
        [action getOAMUser:_emailField.text
              withPassword:_passwordField.text
                completion:^(OAM *oam, NSError *err) {
                    if (!err) {
                        /*if ([oam.status isEqualToString:@"found user"]) {
                         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                         [action verifyUser:_emailField.text
                         withZip:oam.zip
                         completion:^(VoterVoice *voter, NSError *err) {
                         //NSLog(@"%@", voter);
                         if (!err) {
                         if (voter.response.body.count > 0) {
                         VoterVoiceBody *body = voter.response.body[0];
                         
                         [hud showHUDSucces:YES withMessage:@"Success"];
                         NSLog(@"Already there %@", [body.id stringValue]);
                         [prefs setBool:YES forKey:@"isLoggedIn"];
                         [prefs setBool:YES forKey:@"showTip"];
                         [prefs setBool:YES forKey:@"inVoterVoice"];
                         [prefs setObject:_emailField.text forKey:@"email"];
                         [prefs setObject:body.token forKey:@"token"];
                         [prefs setObject:[body.id stringValue] forKey:@"userId"];
                         [prefs synchronize];
                         [self dismissViewControllerAnimated:YES completion:nil];
                         }
                         else {
                         if (oam.phone != nil && oam.prefix != nil) {
                         [action createUser:oam
                         withEmail:[prefs objectForKey:@"email"]
                         completion:^(NSString *userId, NSString *token, NSError *err) {
                         //NSLog(@"error %@ ----%@", userId, token);
                         if (!err && userId != nil) {
                         //VoterVoiceBody *body = voter.response.body[0];
                         [hud showHUDSucces:YES withMessage:@"Success"];
                         NSLog(@"created %@", userId);
                         [prefs setBool:YES forKey:@"isLoggedIn"];
                         [prefs setBool:YES forKey:@"inVoterVoice"];
                         [prefs setBool:YES forKey:@"showTip"];
                         [prefs setObject:_emailField.text forKey:@"email"];
                         [prefs setObject:token forKey:@"token"];
                         [prefs setObject:userId forKey:@"userId"];
                         [prefs synchronize];
                         [self dismissViewControllerAnimated:YES completion:nil];
                         }
                         else {
                         [self bypassVoterVoice];
                         }
                         }];
                         }
                         else {
                         [self bypassVoterVoice];
                         }
                         }
                         }
                         else {
                         [self bypassVoterVoice];
                         }
                         }];
                         } */
                        if ([oam.status isEqualToString:@"found user"]) {
                            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                            [prefs setBool:YES forKey:@"isLoggedIn"];
                            [prefs setBool:YES forKey:@"showTip"];
                            [prefs setBool:NO forKey:@"inVoterVoice"];
                            [prefs setObject:_emailField.text forKey:@"email"];
                            [prefs setObject:(oam.first_name == nil) ? @"" : oam.first_name forKey:@"firstName"];
                            [prefs setObject:(oam.last_name == nil) ? @"" : oam.last_name forKey:@"lastName"];
                            [prefs setObject:(oam.address_line == nil) ? @"" : oam.address_line forKey:@"address"];
                            [prefs setObject:(oam.city == nil) ? @"" : oam.city forKey:@"city"];
                            [prefs setObject:(oam.state == nil) ? @"" : oam.state forKey:@"state"];
                            [prefs setObject:(oam.zip == nil) ? @"" : oam.zip forKey:@"zip"];
                            [prefs setObject:(oam.prefix == nil) ? @"" : oam.prefix forKey:@"prefix"];
                            [prefs setObject:(oam.phone == nil) ? @"" : oam.phone forKey:@"phone"];
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [hud showHUDSucces:YES withMessage:@"Success"];
                            [prefs synchronize];
                            
                            AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            //UIStoryboard *sb = [[ad.window rootViewController] storyboard];
                            MainViewController *main = (MainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"main"];
                            UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:main];
                            mainNav.toolbarHidden = NO;
                            MenuViewController *menu = (MenuViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
                            UINavigationController *menuNav = [[UINavigationController alloc] initWithRootViewController:menu];
                            menuNav.toolbarHidden = NO;
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                                AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                UISplitViewController *split = (UISplitViewController *)ad.splitViewController;
                                [split setViewControllers:@[menuNav, mainNav]];
                                //NSLog(@"ipad");
                            }
                            else {
                                //NSLog(@"iphone");
                                
                                MSDynamicsDrawerViewController *dynamic = (MSDynamicsDrawerViewController *)ad.dynamicsDrawerViewController;
                                [dynamic setPaneState:MSDynamicsDrawerPaneStateClosed];
                                [dynamic setPaneViewController:mainNav animated:NO completion:nil];
                            }
                            
                        }
                        else {
                            [hud showHUDSucces:NO withMessage:@"Failed"];
                            [self showAlert];
                        }
                    }
                    else {
                        [hud showHUDSucces:NO withMessage:@"Failed"];
                        [self showAlert];
                    }
                }];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Internet"
                                                                       message:@"Please check your internet connection and try again."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleCancel
                                                 handler:^void (UIAlertAction *action)
                           {
                               
                           }]];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)showAlert
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Login Credentials" message:@"The Email Address or Password you entered is incorrect. Please verify your credentials and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

- (IBAction)forgotPassword:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.aha.org/oam/forgot-password.dhtml?ahasite=AHA&goto=http://www.aha.org/oam-aha/oam/welcome.html"];
    
    [self launchURLInBrowser:url];
}

- (IBAction)needHelp:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.aha.org/oam-aha/oam/contact_us.html"];
    
    [self launchURLInBrowser:url];
}

- (IBAction)createAccount:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://ams.aha.org/EWEB/DynamicPage.aspx?Site=AHA&webcode=Register&action=add&nostore=1&AHABU=AHA&RedirectURL=http%3A%2F%2Fwww.aha.org%3A80%2Fhospital-members%2Fadvocacy-issues%2Faction%2Findex.shtml"];
    
    [self launchURLInBrowser:url];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
