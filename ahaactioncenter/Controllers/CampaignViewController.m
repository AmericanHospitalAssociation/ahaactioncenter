//
//  CampaignViewController.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "CampaignViewController.h"
#import "ActionCenterManager.h"
#import "ProgressHUD.h"
#import "CampaignDetailView.h"
#import "KGModal.h"
#import "CampaignDetailViewController.h"

@interface CampaignViewController ()
{
    ActionCenterManager *action;
    ProgressHUD *hud;
    VoterVoice *voter;
    NSArray *list;
}

@end

@implementation CampaignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Campiagns";
    self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
    action = [ActionCenterManager sharedInstance];
    hud = [ProgressHUD sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (list.count < 1) {
        [hud showHUDWithMessage:@"Getting Campaigns"];
        [action getCampaignSummaries:^(VoterVoice *votervoice, NSError *error){
            if (!error) {
                list = votervoice.response.body;
                voter = votervoice;
                [hud showHUDSucces:YES withMessage:@"Loaded"];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return list.count;
    return voter.response.body.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //VoterVoiceBody *voter = (VoterVoiceBody *)list[indexPath.row];
    //cell.textLabel.text = voter.headline;
    VoterVoiceBody *body = (VoterVoiceBody *)voter.response.body[indexPath.row];
    cell.textLabel.text = body.headline;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VoterVoiceBody *body = (VoterVoiceBody *)voter.response.body[indexPath.row];
    CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    [detailView setHeader:body.headline];
    [detailView loadHTMLString:body.alert];
    detailView.sendButtonTapped = ^(){
        CampaignDetailViewController *vc = (CampaignDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"campaignDetail"];
        vc.campaignID = [body.id stringValue];
        
        [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
            [self.navigationController pushViewController:vc animated:YES];
        }];
    };
    [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
    
}

@end
