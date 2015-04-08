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

@interface CampaignDetailViewController ()
{
    ProgressHUD *hud;
    ActionCenterManager *action;
    NSString *guidelines;
    VoterVoice *voterVoice;
    VoterVoice *matchVoter;
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
            guidelines = message.guidelines;
            voterVoice = voter;
            [self showGuidelines:nil];
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                               [detailView setButtonTitle:@"Close"];
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

- (IBAction)sendMessage:(id)sender {
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
    VoterVoiceMessage *message = (VoterVoiceMessage *)body.messages[0];
    
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
                             "&phone=%@"
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
                             [message.sampleMessageId stringValue],
                             targetString,
                             @"3124223000",
                             [prefs stringForKey:@"email"],
                             oam.address_line,
                             oam.zip,
                             self.campaignID
                             ]
     ];
    
    // NSLog(@"\n\nURL STRING:\n\n%@", urlString);
    //NSURL *url =[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [hud showHUDWithMessage:@"Sending"];
    NSLog(@"\n\nURL STRING:\n\n%@", urlString);
    [action postVoterUrl:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
              completion:^(VoterVoice *voter, NSError *err) {
                  if (!err) {
                      NSLog(@"Status %@", [voter.response.status stringValue]);
                      
                      [hud showHUDSucces:YES withMessage:@"Sent"];
                      [self.navigationController popToRootViewControllerAnimated:YES];
                  }
              }];
}


@end
