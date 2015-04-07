//
//  LoginViewController.m
//  ahaactioncenter
//
//  Created by Server on 4/5/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Log In";
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
