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

- (IBAction)login:(id)sender {
    [hud showHUDWithMessage:@"Checking User"];
    [action getOAMUser:_emailField.text
          withPassword:_passwordField.text
            completion:^(OAM *oam, NSError *err) {
                if (!err) {
                    if ([oam.status isEqualToString:@"found user"]) {
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        [action verifyUser:_emailField.text
                                   withZip:oam.zip
                                completion:^(VoterVoice *voter, NSError *err) {
                                    if (!err) {
                                        
                                        if (voter.response.body.count > 0) {
                                            VoterVoiceBody *body = voter.response.body[0];
                                            
                                            [hud showHUDSucces:YES withMessage:@"Success"];
                                            NSLog(@"Already there %@", [body.id stringValue]);
                                            [prefs setBool:YES forKey:@"isLoggedIn"];
                                            [prefs setObject:_emailField.text forKey:@"email"];
                                            [prefs setObject:body.token forKey:@"token"];
                                            [prefs setObject:[body.id stringValue] forKey:@"userId"];
                                            [prefs synchronize];
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }
                                        else {
                                            [action createUser:oam
                                                     withEmail:_emailField.text
                                                    completion:^(VoterVoice *voter, NSError *err) {
                                                        NSLog(@"error %@", voter);
                                                if (!err) {
                                                    if ([voter.response.status intValue] == 200) {
                                                        VoterVoiceBody *body = voter.response.body[0];
                                                        [hud showHUDSucces:YES withMessage:@"Success"];
                                                        NSLog(@"created %@", [body.userId stringValue]);
                                                        [prefs setBool:YES forKey:@"isLoggedIn"];
                                                        [prefs setObject:_emailField.text forKey:@"email"];
                                                        [prefs setObject:body.token forKey:@"token"];
                                                        [prefs setObject:[body.id stringValue] forKey:@"userId"];
                                                        [prefs synchronize];
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    }
                                                }
                                            }];
                                        }
                                        
                                    }
                                }];
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

- (void)showAlert
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Login Credentials" message:@"The Email Address or Password you entered is incorrect. Please verify your credentials and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
}

- (IBAction)forgotPassword:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.aha.org/oam/forgot-password.dhtml?ahasite=AHA&goto=http://www.aha.org/oam-aha/oam/welcome.html"];
    
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
