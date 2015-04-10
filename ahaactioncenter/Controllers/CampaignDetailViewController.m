//
//  CampaignDetailViewController.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "CampaignDetailViewController.h"
#import "ProgressHUD.h"
#import "ActionCenterManager.h"
#import "FontAwesomeKit.h"
#import "Constants.h"
#import "CampaignDetailView.h"
#import "KGModal.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "MenuViewController.h"

@interface CampaignDetailViewController ()
{
    ProgressHUD *hud;
    ActionCenterManager *action;
    NSString *guidelines;
    VoterVoice *voterVoice;
    VoterVoice *matchVoter;
    BOOL campaignFlow;
}

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation CampaignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _message.layer.cornerRadius = 5;
    _message.layer.borderWidth = 1.5f;
    _message.layer.masksToBounds = YES;
    _message.scrollEnabled = YES;
    _subjectLabel.layer.cornerRadius = 5;
    _subjectLabel.layer.borderWidth = 1.5f;
    _subjectLabel.layer.masksToBounds = YES;
    
    [_sendButton setBackgroundColor:kAHARed];
    
    hud = [ProgressHUD sharedInstance];
    action = [ActionCenterManager sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (_campaignID == nil) {
        campaignFlow = NO;
        [self setupContactUsFlow];
        self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
    }
    else {
        campaignFlow = YES;
        [self setupCampaignFlow];
    }
    [self registerForKeyboardNotifications];
}

- (void)setupCampaignFlow {
    self.title = @"Personalize the Message";
    FAKIonIcons *icon = [FAKIonIcons iconWithCode:@"\uf44c" size:30];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[icon imageWithSize:CGSizeMake(30, 30)]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(showGuidelines:)];
    [hud showHUDWithMessage:@"Getting Message"];
    [action getTargetedMessages:_campaignID completion:^(VoterVoice *voter, NSError *error){
        if (!error) {
            [hud showHUDSucces:YES withMessage:@"Completed"];
            VoterVoiceBody *body = voter.response.body[0];
            VoterVoiceMessage *message = body.messages[0];
            _subjectLabel.text = message.subject;
            _message.text = message.message;
            _message.inputAccessoryView = [self dismissBar];
            guidelines = message.guidelines;
            voterVoice = voter;
            [self showGuidelines:nil];
        }
    }];
}

- (void)setupContactUsFlow {
    self.title = @"Contact AHA";
    _subjectLabel.text = @"Send a Message to AHA";
    _message.inputAccessoryView = [self dismissBar];
}

- (UIToolbar *)dismissBar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(dismissKeyboard:)];
    [toolbar setItems:@[done] animated:YES];
    
    return toolbar;
}

- (void)dismissKeyboard:(id)sender {
    [_message resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)showGuidelines:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [action getMatchesForCampaign:_campaignID
                        withToken:[prefs objectForKey:@"token"]
                       completion:^(VoterVoice *voter, NSError *err) {
                           if (!err && [voter.response.status intValue] == 200) {
                               
                               
                               CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
                               [detailView setHeader:@"Guidelines"];
                               [detailView setButtonTitle:@"Go to Message"];
                               NSMutableString *urlString = [NSMutableString new];
                               
                               matchVoter = voter;
                               if (voter.response.body != nil) {
                                   [urlString appendFormat:@"<b>Recipients:</b>"];
                                   [urlString appendString:@"<ul>"];
                                   for (VoterVoiceBody *body in voter.response.body) {
                                       for (VoterVoiceMatches *match in body.matches) {
                                           [urlString appendString:@"<li>"];
                                           [urlString appendString:match.name];
                                           [urlString appendString:@"</li>"];
                                       }
                                   }
                                   [urlString appendString:@"</ul><br/>"];
                               }
                               [urlString appendString:guidelines];
                               detailView.sendButtonTapped = ^(){
                                   [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                                   }];
                               };
                               
                               [detailView loadHTMLString:urlString];
                               [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
                           }
                       }];
}

- (NSString *)getTargetString:(VoterVoiceMatches *)m atIndex:(int)i {
    NSMutableString *targetString = [NSMutableString new];
    [targetString appendString:[NSString stringWithFormat:@"&targets[%d][type]=%@", i, m.type]];
    [targetString appendString:[NSString stringWithFormat:@"&targets[%d][id]=%@", i, [m.id stringValue]]];
    [targetString appendString:[NSString stringWithFormat:@"&targets[%d][deliveryMethod]=webform", i]];
    
    BOOL prefixIncluded = NO;
    VoterVoiceBody *body = (VoterVoiceBody *)voterVoice.response.body[0];
    for (int j = 0; j < body.preSelectedAnswers.count; j++) {
        VoterVoiceSelectedAnswers *answers = (VoterVoiceSelectedAnswers *)body.preSelectedAnswers[j];
        if ([answers.question isEqualToString:@"Prefix"]) {
            prefixIncluded = YES;
        }
        [targetString appendString:[NSString stringWithFormat:@"&targets[%d][questionnaire][%d][question]=%@",
                                    i,
                                    j,
                                    answers.question]];
        [targetString appendString:[NSString stringWithFormat:@"&targets[%d][questionnaire][%d][answer]=%@",
                                    i,
                                    j,
                                    answers.answer]];
    }
    
    if (!prefixIncluded) {
        // add Mr
        [targetString appendString:[NSString stringWithFormat:@"&targets[%d][questionnaire][%d][question]=%@",
                                    i,
                                    (int)body.preSelectedAnswers.count,
                                    @"Prefix"]];
        [targetString appendString:[NSString stringWithFormat:@"&targets[%d][questionnaire][%d][answer]=%@",
                                    i,
                                    (int)body.preSelectedAnswers.count,
                                    @"Mr."]];
    }
    
    return targetString;
}

- (void)sendContactUsMessage {
    NSString *messageText, *from;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    messageText = [[NSString stringWithFormat:@"%@\n\nSent from %@ %@\n%@", _message.text, oam.first_name, oam.last_name, oam.org_name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    from = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://54.245.255.190/p/action_center/api/v1/sendEmail?message=%@&from=%@", messageText, from]];
    
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            
            if (error) {
                // NSLog(@"Error %@", error);
            } else {
                [self showThankYou];
            }
        }];
}

- (void)showThankYou {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                   message:@"Your message has been sent. Thank you for contacting the American Hospital Association"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Done"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action)
                      {
                          //[self.navigationController popToRootViewControllerAnimated:YES];
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
                              [dynamic setPaneViewController:mainNav animated:YES completion:nil];
                          }

                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)sendMessage:(id)sender {
    if (campaignFlow) {
        [self sendCampaignMessage];
    }
    else {
        [self sendContactUsMessage];
    }
}

- (void)sendCampaignMessage {
    // Create the array of matched targets to be sent in the GET request
    NSMutableString *targetString = [NSMutableString new];
    //VoterVoiceBody *body = (VoterVoiceBody *)voterVoice.response.body[0];
    for (int i = 0; i < matchVoter.response.body.count; i++) {
        VoterVoiceBody *b = (VoterVoiceBody *)matchVoter.response.body[i];
        for (VoterVoiceMatches *m in b.matches) {
            // NSLog(@"Match: %@", m);
            [targetString appendString:[self getTargetString:m atIndex:i]];
        }
        
    }
    
    //[self viewFadeOut:background];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    VoterVoiceBody *body = (VoterVoiceBody *)voterVoice.response.body[0];
    //VoterVoiceMessage *message = (VoterVoiceMessage *)body.messages[0];
    
    NSMutableString *urlString = [NSMutableString new];
    [urlString appendString:@"http://54.245.255.190/p/action_center/api/v1/postResponse?"];
    [urlString appendString:[NSString stringWithFormat:
                             @"token=%@"
                             "&subject=%@"
                             "&body=%@"
                             "&userId=%@"
                             "&signature=%@"
                             "&messageId=%@"
                             "%@"
                             /*"&phone=%@"*/
                             "&email=%@"
                             "&address=%@"
                             "&zipcode=%@"
                             "&country=US"
                             "&campaignId=%@",
                             [prefs stringForKey:@"token"],
                             _subjectLabel.text,
                             _message.text,
                             [prefs stringForKey:@"userId"],
                             [NSString stringWithFormat:@"%@ %@", oam.first_name, oam.last_name],
                             [body.id stringValue],
                             targetString,
                             /* @"3124223000",*/
                             [prefs stringForKey:@"email"],
                             oam.address_line,
                             [oam.zip substringToIndex:5],
                             self.campaignID
                             ]
     ];
    
    NSLog(@"\n\nURL STRING:\n\n%@", [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    //NSURL *url =[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [hud showHUDWithMessage:@"Sending"];
    //NSLog(@"\n\nURL STRING:\n\n%@", urlString);
    [action postVoterUrl:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
              completion:^(VoterVoice *voter, NSError *err) {
                  if (!err) {
                      NSLog(@"Status %@", [voter.response.status stringValue]);
                      
                      [hud showHUDSucces:YES withMessage:@"Sent"];
                      [self showCompleted];
                  }
              }];
}

- (void)showCompleted {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email Sent"
                                                                   message:@"You will receive a confirmation email shortly. Thank you"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Done"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action)
                      {
                          [self.navigationController popToRootViewControllerAnimated:YES];
                          
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Keyboard Notifications
- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    _message.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    _message.scrollIndicatorInsets = _message.contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    _message.contentInset = UIEdgeInsetsZero;
    _message.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end
