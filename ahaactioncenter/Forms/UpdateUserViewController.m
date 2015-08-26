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
#import "WebViewController.h"
#import "AppDelegate.h"

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
    UserForm *form = [[UserForm alloc] init];
    form.excludedList = _excludeList;
    self.formController.form = form;
    
    if (_showCancel) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
    }
    else {
        self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(updateInfo:)];
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

- (void)showAlert:(NSString *)alert withMessage:(NSString *)msg {
    NSString *str;
    if ([alert containsString:@"address"]) {
        str = @"Your address on file does not match U.S. Postal Service records. Please update your address";
    }
    else {
        str = @"There is something wrong with your AHA account. Please contact AHA for details";
    }
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"Account Error"
                                                                    message:str
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"OK"
                                               style:UIAlertActionStyleCancel
                                             handler:^void (UIAlertAction *action)
                       {
                           
                       }]];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Contact AHA"
                                               style:UIAlertActionStyleDefault
                                             handler:^void (UIAlertAction *action)
                       {
                           //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.aha.org/updateprofile"]];
                           ActionCenterManager *acm = [ActionCenterManager sharedInstance];
                           acm.contacAHA = YES;
                           NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                           [prefs setObject:@"" forKey:@"lastCampaign"];
                           [prefs synchronize];
                           [self dismissViewControllerAnimated:YES completion:^(){
                               if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                   [[NSNotificationCenter defaultCenter] postNotificationName: @"showContact" object:nil userInfo:nil];
                               }
                               AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                               [ad openSideMenu];
                           }];
                       }]];
    [self presentViewController:alert2 animated:YES completion:nil];
}

- (void)updateInfo:(id)sender
{
    NSLog(@"update");
    
    UserForm *form = (UserForm *)self.formController.form;
    ProgressHUD *hud = [ProgressHUD sharedInstance];
    ActionCenterManager *action = [ActionCenterManager sharedInstance];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    
    if (_validateAddress) {
        
        [action verifyAddress:form.address withZip:form.zip andCountry:@"US" completion:^(NSDictionary *dict, NSError *err) {
            //NSString *suggestedZipCode = (NSString *)[dict valueForKeyPath:@"response.body.suggestedZipCode"];
            //NSString *message = (NSString *)[dict valueForKeyPath:@"response.body.message"];
            NSArray *arr = (NSArray *)[dict valueForKeyPath:@"response.body.addresses"];
            
            if ([dict valueForKeyPath:@"response.body.suggestedZipCode"] == [NSNull null] &&
                [dict valueForKeyPath:@"response.body.message"] == [NSNull null] &&
                arr.count > 0) {
                NSDictionary *d = arr[0];
                [prefs setObject:d[@"streetAddress"] forKey:@"address"];
                //NSLog(@"********************%@********************", d[@"streetAddress"]);
                [prefs setObject:d[@"city"] forKey:@"city"];
                [prefs setObject:d[@"state"] forKey:@"state"];
                [prefs setObject:d[@"zipCode"] forKey:@"zip"];
                [prefs synchronize];
                
                form.city = d[@"city"];
                [self.formController.tableView reloadData];
                
                NSString *phone = [form.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"." withString:@""];
                oam.phone = phone;
                oam.prefix = form.prefix;
                //NSLog(@"p %@", phone);
                [prefs setObject:form.firstName forKey:@"firstName"];
                [prefs setObject:form.lastName forKey:@"lastName"];
                /*
                 [prefs setObject:form.address forKey:@"address"];
                 [prefs setObject:form.city forKey:@"city"];
                 [prefs setObject:form.state forKey:@"state"];
                 [prefs setObject:form.zip forKey:@"zip"];
                 */
                oam.first_name = form.firstName;
                oam.last_name = form.lastName;
                oam.address_line = form.address;
                oam.city = form.city;
                oam.state = form.state;
                oam.zip = form.zip;
                //NSLog(@"phone %@", phone);
                if (phone.length > 0) {
                    if (phone.length != 10)
                    {
                        [self phoneError];
                        return;
                    }
                }
                
                if (oam.phone != nil) {
                    [prefs setObject:oam.phone forKey:@"phone"];
                }
                if (oam.prefix != nil) {
                    [prefs setObject:oam.prefix forKey:@"prefix"];
                }
                
                [prefs synchronize];
                
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
                                NSLog(@"error ----------%@", err.description);
                                [self showAlert:err.description withMessage:@""];
                            }
                        }];
            }
            else {
                [self showAlert:@"address" withMessage:@""];
                return;
            }
        }];
    }
}

@end
