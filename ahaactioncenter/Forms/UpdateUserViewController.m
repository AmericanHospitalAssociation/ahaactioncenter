//
//  FeedbackViewController.m
//  applepayfinder
//
//  Created by Vince Davis on 11/20/14.
//  Copyright (c) 2014 Vince Davis. All rights reserved.
//

#import "UpdateUserViewController.h"
#import "RootForm.h"
#import "UserForm.h"
#import "ActionCenterManager.h"
#import "ProgressHUD.h"

@interface UpdateUserViewController ()

@end

@implementation UpdateUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Update Info", nil);

    //set up form and form controller
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    
    self.formController.delegate = self;
    self.formController.form = [[UserForm alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissModalViewControllerAnimated:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)phoneError {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Bad Phone Length"
                                                                   message:@"Phone number has to be 10 digits"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Try again"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action)
                      {
                          
                      }]];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateInfo:(id)sender
{
    NSLog(@"update");
    
    UserForm *form = (UserForm *)self.formController.form;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    
    oam.phone = form.phone;
    oam.prefix = form.prefix;
    
    if (form.phone.length != 10)
    {
        [self phoneError];
        return;
    }
    
    if (oam.phone != nil) {
        [prefs setObject:oam.phone forKey:@"phone"];
    }
    if (oam.prefix != nil) {
        [prefs setObject:oam.prefix forKey:@"prefix"];
    }
    
    ProgressHUD *hud = [ProgressHUD sharedInstance];
    ActionCenterManager *action = [ActionCenterManager sharedInstance];
    [hud showHUDWithMessage:@"Updating User"];
    [action createUser:oam
             withEmail:[prefs objectForKey:@"email"]
            completion:^(NSString *userId, NSString *token, NSError *err) {
                //NSLog(@"error %@", voter);
                if (!err) {
                    if (YES) {
                        //VoterVoiceBody *body = voter.response.body[0];
                        [hud showHUDSucces:YES withMessage:@"Success"];
                        NSLog(@"created %@", userId);
                        [prefs setBool:YES forKey:@"isLoggedIn"];
                        [prefs setBool:YES forKey:@"inVoterVoice"];
                        //[prefs setObject:_emailField.text forKey:@"email"];
                        [prefs setObject:token forKey:@"token"];
                        [prefs setObject:userId forKey:@"userId"];
                        [prefs synchronize];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
                else {
                    [hud showHUDSucces:NO withMessage:@"Failed"];
                    [action showAlert:@"Can't create Account" withMessage:@"There is something wrong with your AHA account. Please contact AHA for details"];
                }
            }];
}

@end
