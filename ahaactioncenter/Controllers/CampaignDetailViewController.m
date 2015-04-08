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

@interface CampaignDetailViewController ()
{
    ProgressHUD *hud;
    ActionCenterManager *action;
}

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation CampaignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Personalize the Message";
    
    _message.layer.cornerRadius = 5;
    _message.layer.borderWidth = 1.5f;
    _message.layer.masksToBounds = YES;
    
    _subjectLabel.layer.cornerRadius = 5;
    _subjectLabel.layer.borderWidth = 1.5f;
    _subjectLabel.layer.masksToBounds = YES;
    
    [_sendButton setBackgroundColor:kAHARed];
    
    hud = [ProgressHUD sharedInstance];
    action = [ActionCenterManager sharedInstance];
    FAKIonIcons *icon = [FAKIonIcons iconWithCode:@"\uf44c" size:30];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[icon imageWithSize:CGSizeMake(30, 30)]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(showGuidelines:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [hud showHUDWithMessage:@"Getting Message"];
    [action getTargetedMessages:_campaignID completion:^(VoterVoice *voter, NSError *error){
        if (!error) {
            [hud showHUDSucces:YES withMessage:@"Completed"];
            VoterVoiceBody *body = voter.response.body[0];
            VoterVoiceMessage *message = body.messages[0];
            _subjectLabel.text = message.subject;
            _message.text = message.message;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGuidelines:(id)sender
{
    
}

- (IBAction)sendMessage:(id)sender {
}


@end
