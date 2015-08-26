//
//  GeneralTableViewController.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "GeneralTableViewController.h"
#import "TwitterTableViewCell.h"
#import "SpecialBulletinTableViewCell.h"
#import "ActionAlertTableViewCell.h"
#import "EventCalendarTableViewCell.h"
#import "ActivityFeedTableViewCell.h"
#import "AHAAdvisoryTableViewCell.h"
#import "CampaignTableViewCell.h"
#import "MedicareTableViewCell.h"
#import "STTwitter.h"
#import "DataModels.h"
#import "ProgressHUD.h"
#import "ActionCenterManager.h"
#import "Constants.h"
#import "CampaignDetailView.h"
#import "CampaignDetailViewController.h"
#import "KGModal.h"
#import "WebViewController.h"
#import "UpdateUserViewController.h"
#import <AMPPreviewController/AMPPreviewController.h>
#import "AppDelegate.h"

@interface GeneralTableViewController ()
{
    NSArray *list;
    ProgressHUD *hud;
    ActionCenterManager *action;
    VoterVoice *voter;
}

@end

@implementation GeneralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hud = [ProgressHUD sharedInstance];
    action = [ActionCenterManager sharedInstance];
    voter = [[VoterVoice alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
    }
    else {
        self.navigationItem.leftBarButtonItem = [ActionCenterManager splitButton];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self loadCustomView];
    /*
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![[prefs objectForKey:@"lastCampaign"] isEqualToString:@""]) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[[prefs objectForKey:@"lastCampaign"] integerValue]
                                               inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:path];
        [prefs setObject:nil forKey:@"lastCampaign"];
        [prefs synchronize];
    }
     */
}

- (void)loadCustomView
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (_viewType == kViewTypeTwitter && _viewShouldRefresh) {
        self.title = @"Twitter";
        [hud showHUDWithMessage:@"Getting Tweets"];
        _viewShouldRefresh = NO;
        
        if (![action isReachable]) {
            return;
        }
        NSMutableArray *items = [NSMutableArray new];
        STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:kTwitterKey
                                                                consumerSecret:kTwitterSecret];
        
        [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
            
            [twitter getUserTimelineWithScreenName:_dict[@"title"]
                                      successBlock:^(NSArray *statuses) {
                                          for (NSDictionary *d in statuses) {
                                              UserStatusTwitterItem *item = [UserStatusTwitterItem modelObjectWithDictionary:d];
                                              
                                              [items addObject:item];
                                          }
                                          list = items;
                                          [self.tableView reloadData];
                                          sleep(1);
                                          [hud showHUDSucces:YES withMessage:@"Loaded"];
                                      } errorBlock:^(NSError *error) {
                                          
                                      }];
        } errorBlock:^(NSError *error) {
        }];
    }
    if (_viewType == kViewTypeCalendar && _viewShouldRefresh) {
        self.title = @"Events";
        [hud showHUDWithMessage:@"Loading Events"];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSMutableArray *set = [[NSMutableArray alloc] init];
        [action getAHACalendar:^(AHACalendar *calendar, NSError *error){
            if (!error) {
                [hud showHUDSucces:YES withMessage:@"Loaded"];
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"unix_date" ascending:YES];
                NSArray *calendarItems = [calendar.items sortedArrayUsingDescriptors:@[sort]];
                for (int i = 0; i < calendarItems.count; i++) {
                    AHACalendarItem *item = (AHACalendarItem *)calendarItems[i];
                    if (![set containsObject:item.pretty_date]) {
                        [set addObject:item.pretty_date];
                    }
                }
                for (int i = 0; i < set.count; i++) {
                    NSString *date = set[i];
                    //NSLog(@"set %@", date);
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (int i = 0; i < calendarItems.count; i++) {
                        AHACalendarItem *item = (AHACalendarItem *)calendarItems[i];
                        if ([date isEqualToString:item.pretty_date]) {
                            [arr addObject:item];
                        }
                    }
                    [items addObject:arr];
                }
                
                list = (NSArray *)items;
                [self.tableView reloadData];
            }
        }];
    }
    if (_viewType == kViewTypeDirectory && _viewShouldRefresh) {
        self.title = @"Directory";
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [hud showHUDWithMessage:@"Getting Representatives"];
        [action getMatchesForCampaign:nil
                            withToken:[prefs objectForKey:@"token"]
                           completion:^(VoterVoice *votervoice, NSError *error){
            if (!error) {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (VoterVoiceBody *body in votervoice.response.body) {
                    if ([body.groupId isEqualToString:@"US Representative"] || [body.groupId isEqualToString:@"US Senators"]) {
                        [arr addObject:body];
                    }
                }
                list = (NSArray *)arr;
                NSLog(@"%@", list);
                voter = votervoice;
                [hud showHUDSucces:YES withMessage:@"Loaded"];
                [self.tableView reloadData];
                _viewShouldRefresh = NO;
            }
        }];
    }
    if (_viewType == kViewTypeCampaign && _viewShouldRefresh) {
        self.title = @"Campaigns";
        [hud showHUDWithMessage:@"Getting Campaigns"];
        [action getCampaignSummaries:^(VoterVoice *votervoice, NSError *error){
            if (!error) {
                list = votervoice.response.body;
                voter = votervoice;
                [hud showHUDSucces:YES withMessage:@"Loaded"];
                [self.tableView reloadData];
                _viewShouldRefresh = NO;
            }
        }];
    }
    if (_viewType == kViewTypeAHANews && _viewShouldRefresh) {
        self.title = @"AHA News";
        [hud showHUDWithMessage:@"Getting News"];
        [action getAHANews:^(NSArray *news, NSError *error) {
            if (!error) {
                list = news;
                [self.tableView reloadData];
                sleep(0.5);
                [hud showHUDSucces:YES withMessage:@"Loaded"];
                _viewShouldRefresh = NO;
            }
        }];
    }
    if (_viewType == kViewTypeActionAlert && _viewShouldRefresh) {
        self.title = @"Action Alerts";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@ and isHidden == %@", @"action-alert", @"0"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"unix_date" ascending:NO];
        list = [[action.feeds filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sort]];
        NSData *data = [prefs objectForKey:@"feeds"];
        NSArray *feeds = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (list.count == 0) {
            list = feeds;
        }
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeLetter && _viewShouldRefresh) {
        self.title = @"Letters";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@ and isHidden == %@", @"letter", @"0"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"unix_date" ascending:NO];
        list = [[action.feeds filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sort]];
        NSData *data = [prefs objectForKey:@"feeds"];
        NSArray *feeds = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (list.count == 0) {
            list = feeds;
        }
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeContactUs && _viewShouldRefresh) {
        self.title = @"Contact AHA";
        NSDictionary *general = @{@"title" : @"General Inquiry", @"text" : @"Send an email inquiry to the American Hospital Association"};
        NSDictionary *actionCenter = @{@"title" : @"Action Center Feedback", @"text" : @"It's important for us to know the results of your Congressional contacts.  Who did you weigh in with?  What issues were raised?  How did they respond?"};
        list = @[general, actionCenter];
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeBulletin && _viewShouldRefresh) {
        self.title = @"Special Bulletins";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@ and isHidden == %@", @"bulletin", @"0"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"unix_date" ascending:NO];
        list = [[action.feeds filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sort]];
        NSData *data = [prefs objectForKey:@"feeds"];
        NSArray *feeds = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (list.count == 0) {
            list = feeds;
        }
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeFactSheet && _viewShouldRefresh) {
        self.title = @"Fact Sheets";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@ and isHidden == %@", @"issue-papers", @"0"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"unix_date" ascending:NO];
        list = [[action.feeds filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sort]];
        NSData *data = [prefs objectForKey:@"feeds"];
        NSArray *feeds = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (list.count == 0) {
            list = feeds;
        }
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeAdvisory && _viewShouldRefresh) {
        self.title = @"Advisories";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@ and isHidden == %@", @"advisory", @"0"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"unix_date" ascending:NO];
        list = [[action.feeds filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sort]];
        NSData *data = [prefs objectForKey:@"feeds"];
        NSArray *feeds = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (list.count == 0) {
            list = feeds;
        }
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeTestimony && _viewShouldRefresh) {
        self.title = @"Testimony";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@ and isHidden == %@", @"testimony", @"0"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"unix_date" ascending:NO];
        list = [[action.feeds filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sort]];
        NSData *data = [prefs objectForKey:@"feeds"];
        NSArray *feeds = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (list.count == 0) {
            list = feeds;
        }
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeAdditional && _viewShouldRefresh) {
        self.title = @"Additional Info";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@ and isHidden == %@", @"additional-info", @"0"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"unix_date" ascending:NO];
        list = [[action.feeds filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:@[sort]];
        NSData *data = [prefs objectForKey:@"feeds"];
        NSArray *feeds = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (list.count == 0) {
            list = feeds;
        }
        [self.tableView reloadData];
    }
}

- (NSString *) cleanString:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    return str;
}

- (void)sectionButtonClicked:(id)sender {
    GeneralTableViewController *vc = (GeneralTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"general"];
    vc.viewType = kViewTypeCampaign;
    vc.viewShouldRefresh = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)campaignFeedbackPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.votervoice.net/AHA/Surveys/2526/Respond"]];
}

- (void)showPDF:(NSString *)link {
    AMPPreviewController *pc = [[AMPPreviewController alloc]
                                initWithRemoteFile:[NSURL URLWithString:link]];
    
    [pc setStartDownloadBlock:^(){
        NSLog(@"Start download");
        
    }];
    [pc setFinishDownloadBlock:^(NSError *error){
        NSLog(@"Download finished %@", error);
        
        //[[ProgressHUD sharedInstance] showHUDSucces:YES withMessage:@"Completed"];
    }];
    //[[ProgressHUD sharedInstance] showHUDWithMessage:@"Loading"];
    [self.navigationController pushViewController:pc animated:YES];
}

- (void)showTwitter:(NSString *)string {
    //https://twitter.com/search?q=%23partners4quality&src=typd
    NSString *link;
    NSDictionary *d;
    WebViewController *vc = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    vc.shouldRefresh = YES;
    vc.webType = kWebTypeWeb;
    if ([string hasPrefix:@"#"]) {
        d = @{@"Title" : string };
        string = [string stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
        link = [NSString stringWithFormat:@"https://twitter.com/search?q=%@&src=typd", string];
    }
    if ([string hasPrefix:@"@"]) {
        d = @{@"Title" : string };
        string = [string stringByReplacingOccurrencesOfString:@"@" withString:@""];
        link = [NSString stringWithFormat:@"https://twitter.com/%@", string];
    }
    if ([string hasPrefix:@"http://"] || [string hasPrefix:@"https://"] ) {
        d = @{@"Title" : @"Link"};
        link = string;
    }
    vc.link = link;
    vc.dict = d;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requiredInfo
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Additional Info Needed"
                                                                   message:@"To enable matching you to your legislators, additional info is needed. Would you like to enter the needed info?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action)
                      {
                          
                      }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"YES"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action)
                      {
                          UpdateUserViewController *update = [[UpdateUserViewController alloc] initWithStyle:UITableViewStyleGrouped];
                          update.excludeList = @[@"excludedList", @"showPhone"/*, @"firstName", @"lastName", @"prefix", @"phone"*/];
                          UserForm *form = (UserForm *)update.formController.form;
                          form.firstName = @"test";
                          update.validateAddress = YES;
                          update.showCancel = YES;
                          UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:update];
                          nav.modalPresentationStyle = UIModalPresentationFormSheet;
                          [self.navigationController presentViewController:nav animated:YES completion:nil];
                          
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert:(NSString *)alert withMessage:(NSString *)msg {
    NSString *str;
    if ([alert containsString:@"address"]) {
        str = @"Your address on file does not match U.S. Postal Service records. Please update your address.";
    }
    else {
        str = @"There is something wrong with your AHA account. Please contact AHA for details";
    }
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"Account Error"
                                                                    message:str
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Update Info"
                                               style:UIAlertActionStyleCancel
                                             handler:^void (UIAlertAction *action)
                       {
                           UpdateUserViewController *update = [[UpdateUserViewController alloc] initWithStyle:UITableViewStyleGrouped];
                           update.excludeList = @[@"excludedList", @"showPhone"/*, @"firstName", @"lastName", @"prefix", @"phone"*/];
                           UserForm *form = (UserForm *)update.formController.form;
                           form.firstName = @"test";
                           update.validateAddress = YES;
                           update.showCancel = YES;
                           UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:update];
                           nav.modalPresentationStyle = UIModalPresentationFormSheet;
                           [self.navigationController presentViewController:nav animated:YES completion:nil];
                       }]];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Contact AHA"
                                               style:UIAlertActionStyleDefault
                                             handler:^void (UIAlertAction *action)
                       {
                           //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.aha.org/updateprofile"]];
                           ActionCenterManager *acm = [ActionCenterManager sharedInstance];
                           acm.contacAHA = YES;
                           AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                           [ad openSideMenu];
                           if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                               [[NSNotificationCenter defaultCenter] postNotificationName: @"showContact" object:nil userInfo:nil];
                           }
                       }]];
    [self presentViewController:alert2 animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_viewType == kViewTypeCalendar || _viewType == kViewTypeDirectory) {
        return list.count;
    }
    else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_viewType == kViewTypeCalendar) {
        NSArray *arr = list[section];
        return arr.count;
    }
    if (_viewType == kViewTypeDirectory) {
        VoterVoiceBody *body = (VoterVoiceBody *)list[section];
        return body.matches.count;
    }
    else {
        return list.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_viewType == kViewTypeCalendar) {
        NSArray *arr = list[section];
        AHACalendarItem *item = (AHACalendarItem *)arr[0];
        NSString *sectionName = item.pretty_date;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [tableView headerViewForSection:section].frame.size.width, [tableView headerViewForSection:section].frame.size.height)];
        [v setBackgroundColor:[UIColor colorWithRed:185.0/255.0f green:217.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width - 5, 22.0f)];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        NSString *str;
        str = [sectionName stringByReplacingOccurrencesOfString:@"st" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"th" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"rd" withString:@""];
        titleLabel.text = str;
        [v addSubview:titleLabel];
        return v;
    }
    if (_viewType == kViewTypeDirectory) {
        VoterVoiceBody *body = (VoterVoiceBody *)list[section];
        
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        UIView *headerView = [[UIView alloc] initWithFrame:frame];
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(5, -5, frame.size.width - 55, 30)];
        NSString *str = body.groupId;
        [headerView setBackgroundColor:[UIColor colorWithRed:185.0/255.0f green:217.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
        header.text = [NSString stringWithFormat:@"%@", str];
        [header setFont:[UIFont fontWithName:@"Helvetica-Bold"  size:15.0f]];
        [headerView addSubview:header];
        // need a button
        /*
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 55, 0, 50, 30)];
        [button addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        [button setTitle:@"Take Action" forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0f]];
        button.layer.borderWidth = 0.8f;
        button.layer.cornerRadius = 2.0f;
        [button setBackgroundColor:[UIColor colorWithRed:157.0f/255.0f green:34.0f/255.0f blue:53.0f/255.0f alpha:1.0f]];
        [button.titleLabel setTextColor:[UIColor blackColor]];
         */
        return headerView;
    }
    else {
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor clearColor];
        return v;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_viewType == kViewTypeTwitter) {
        return 238.0f;
    }
    else if (_viewType == kViewTypeCalendar) {
        return 92.0f;
    }
    else if (_viewType == kViewTypeCampaign || _viewType == kViewTypeAHANews || _viewType == kViewTypeFactSheet ||  _viewType == kViewTypeAdditional) {
        return 110.0f;
    }
    else if (_viewType == kViewTypeActionAlert) {
        //return 300.0f;
        return 235.0f;
    }
    else if (_viewType == kViewTypeLetter || _viewType == kViewTypeAdvisory || _viewType == kViewTypeTestimony) {
        return 235.0f;
    }
    else if (_viewType == kViewTypeBulletin) {
        //return 215.0f;
        return 235.0f;
    }
    else if (_viewType == kViewTypeContactUs) {
        return 235.0f;
    }
    else {
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_viewType == kViewTypeActionAlert) {
        //ActionAlertTableViewCell *cell = (ActionAlertTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"action_alert_cell"];
        
        
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"advisories"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"We need action from %@. We %@. This needs to be done %@ because %@.",
                         row[@"ActionFrom"],
                         row[@"ActionNeeded"],
                         row[@"When_c"],
                         row[@"Why"]];
        
        [cell setupCellWithTitle:row[@"Title"]
         //date:row[@"Date"]
                            date:[ActionCenterManager formatDate:row[@"Date"]]
                     description:str];
        //cell.titleLabel.text = row[@"Title"];
        //cell.actionFromLabel.text = row[@"ActionFrom"];
        //cell.actionNeededLabel.text = row[@"ActionNeeded"];
        //cell.whenLabel.text = row[@"When_c"];
        //cell.whyLabel.text = row[@"Why"];
        
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    if (_viewType == kViewTypeFactSheet || _viewType == kViewTypeAdditional) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fact_sheets"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        cell.advisoryTitleLabel.text = row[@"Title"];
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    if (_viewType == kViewTypeBulletin) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"advisories"];
        //SpecialBulletinTableViewCell *cell = (SpecialBulletinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"special_bulletin_cell"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        /*
        cell.titleLabel.text = row[@"Title"];
        cell.dateLabel.text = [ActionCenterManager formatDate:row[@"Date"]];
        [cell setDescriptionLabelText:row[@"Description"]];
         */
        [cell setupCellWithTitle:row[@"Title"]
         //date:row[@"Date"]
                            date:[ActionCenterManager formatDate:row[@"Date"]]
                     description:row[@"Description"]];
        
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    if (_viewType == kViewTypeLetter || _viewType == kViewTypeTestimony || _viewType == kViewTypeAdvisory) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"advisories"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        [cell setupCellWithTitle:row[@"Title"]
                            //date:row[@"Date"]
                            date:[ActionCenterManager formatDate:row[@"Date"]]
                     description:row[@"Description"]];
        
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    if (_viewType == kViewTypeContactUs) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"advisories"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        [cell setupCellWithTitle:row[@"title"]
                            date:nil
                     description:row[@"text"]];
        cell.advisoryTitleLabel.textAlignment = NSTextAlignmentCenter;
        cell.advisoryDescriptionLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    if (_viewType == kViewTypeTwitter) {
        TwitterTableViewCell *cell = (TwitterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"twitter_feed_cell"];
        UserStatusTwitterItem *item = [list objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = item.user.name;
        cell.accountNameLabel.text = [NSString stringWithFormat:@"@%@", item.user.screenName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.tweetLabel.text = [self cleanString:item.text];
        [cell.tweetLabel setText:[self cleanString:item.text]];
        [cell.tweetLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
            [self showTwitter:string];
        }];
        CGSize size = [cell.tweetLabel suggestedFrameSizeToFitEntireStringConstraintedToWidth:cell.tweetLabel.frame.size.width];
        CGRect frame = cell.tweetLabel.frame;
        frame.size.height = size.height;
        cell.tweetLabel.frame = frame;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        NSDate *date = [df dateFromString:item.createdAt];
        
        [df setDateFormat:@"MM/dd/yyyy"];
        NSString *dateStr = [df stringFromDate:date];
        cell.dateLabel.text = [ActionCenterManager formatDate:dateStr];;
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm";
        
        NSString *dateString = [timeFormatter stringFromDate: date];
        cell.timeLabel.text = dateString;
        
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    if (_viewType == kViewTypeCalendar) {
        EventCalendarTableViewCell *cell = (EventCalendarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"calendar_cell"];
        
        NSArray *arr = list[indexPath.section];
        AHACalendarItem *item = (AHACalendarItem *)arr[indexPath.row];
        cell.titleLabel.text = item.clean_title;
        //cell.monthSpanLabel.text = [NSString stringWithFormat:@"%@ - %@", [months objectAtIndex:item.startMonth - 2], [months objectAtIndex:item.endMonth - 2]];
        // Get the date of the event using the unix timestamp
        NSTimeInterval interval = [item.unix_date doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"MMMM dd, yyyy"];
        NSString *_date=[formatter stringFromDate:date];
        cell.monthSpanLabel.text = _date;
        NSString *time = [NSString stringWithFormat:@"%@ - %@", item.meeting_start_time, item.meeting_end_time];
        
        if (time.length > 3) {
            cell.timeLabel.text = time;
        } else {
            cell.timeLabel.text = @"all day/non-timed";
        }
        
        cell.descLabel.text = @"";
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    if (_viewType == kViewTypeCampaign) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fact_sheets"];
        VoterVoiceBody *body = (VoterVoiceBody *)voter.response.body[indexPath.row];
        cell.advisoryTitleLabel.text = body.headline;
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    if (_viewType == kViewTypeAHANews) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"aha_news"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        [cell setupCellWithTitle:row[@"name"]
                            date:[ActionCenterManager formatDate:row[@"published"]]
                     description:nil];
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    if (_viewType == kViewTypeDirectory) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17.5f]];
        VoterVoiceBody *body = (VoterVoiceBody *)list[indexPath.section];
        VoterVoiceMatches *match = (VoterVoiceMatches *)body.matches[indexPath.row];
        cell.textLabel.text = match.name;
        //cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_viewType == kViewTypeTwitter) {
        
    }
    else if (_viewType == kViewTypeCampaign) {
        OAM *oam;
        //if ([prefs boolForKey:@"inVoterVoice"]) {
            VoterVoiceBody *body = (VoterVoiceBody *)voter.response.body[indexPath.row];
            CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
            [detailView setHeader:body.headline];
            [detailView loadHTMLString:body.alert];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if (/*[prefs boolForKey:@"inVoterVoice"] == NO*/YES) {
            NSString *prefix = [prefs stringForKey:@"prefix"];
            NSString *phone = [prefs stringForKey:@"phone"];
            NSString *token = [prefs stringForKey:@"token"];
            NSString *address = [prefs stringForKey:@"address"];
            NSString *city = [prefs stringForKey:@"city"];
            NSString *state = [prefs stringForKey:@"state"];
            NSString *zip = [prefs stringForKey:@"zip"];
            zip = [zip substringToIndex:5];
            oam = [[OAM alloc] initWithJSONData:[prefs objectForKey:@"user"]];
            if (address == nil) {
                [self requiredInfo];
                return;
            }
            else {
                detailView.sendButtonTapped = ^(){
                    CampaignDetailViewController *vc = (CampaignDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"campaignDetail"];
                    vc.campaignID = [body.id stringValue];
                    [action verifyAddress:address withZip:zip andCountry:@"US" completion:^(NSDictionary *dict, NSError *err) {
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
                            
                            oam.address_line = address;
                            oam.city = city;
                            oam.state = state;
                            oam.zip = zip;
                            oam.phone = phone;
                            oam.prefix = prefix;
                            
                            [action createUser:oam
                                     withEmail:[prefs stringForKey:@"email"]
                                    completion:^(NSString *userId, NSString *token, NSError *err) {
                                        if (!err) {
                                            [hud showHUDSucces:YES withMessage:@"Success"];
                                            [self.navigationController pushViewController:vc animated:YES];
                                        }
                                        else {
                                            [hud showHUDSucces:NO withMessage:@"Failed"];
                                            [self showAlert:err.description withMessage:@""];
                                        }
                                    }];
                        }
                        else {
                            [self showAlert:@"address" withMessage:@""];
                        }
                    }];
                    
                    [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                        
                        //[self.navigationController presentViewController:vc animated:YES completion:nil];
                        
                    }];
                };
                [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
            }
        }
        
        
        //}
        //else {
        //    [self requiredInfo];
        //}
        
    }
    else if (_viewType == kViewTypeActionAlert) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        [detailView setHeader:row[@"Title"]];
        [detailView loadHTMLString:row[@"Long_Description"]];
        if ([(NSString *)row[@"box_link_dir"] isEqualToString:@""]) {
            [detailView setButtonTitle:@"Close"];
            detailView.sendButtonTapped = ^(){
                [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                }];
            };
        }
        else {
            [detailView setButtonTitle:@"Read More"];
            detailView.sendButtonTapped = ^(){
                WebViewController *vc = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
                vc.link = row[@"box_link_dir"];
                vc.dict = row;
                vc.webType = kWebTypeFactSheet;
                vc.shouldRefresh = YES;
                [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                    //[self showPDF:row[@"box_link_dir"]];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            };
        }
        [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
    }
    else if (_viewType == kViewTypeAdditional) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        [detailView setHeader:row[@"Title"]];
        [detailView loadHTMLString:row[@"Long_Description"]];
        if ([(NSString *)row[@"box_link_dir"] isEqualToString:@""]) {
            [detailView setButtonTitle:@"Close"];
            detailView.sendButtonTapped = ^(){
                [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                }];
            };
        }
        else {
            [detailView setButtonTitle:@"Read More"];
            detailView.sendButtonTapped = ^(){
                WebViewController *vc = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
                vc.link = row[@"box_link_dir"];
                vc.dict = row;
                vc.webType = kWebTypeFactSheet;
                vc.shouldRefresh = YES;
                [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                    //[self showPDF:row[@"box_link_dir"]];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            };
        }
        [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
    }
    else if (_viewType == kViewTypeContactUs) {
        if (indexPath.row == 1) {
            [self campaignFeedbackPressed:nil];
        }
        if (indexPath.row == 0) {
            CampaignDetailViewController *vc = (CampaignDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"campaignDetail"];
            vc.campaignID = nil;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (_viewType == kViewTypeLetter || _viewType == kViewTypeAdvisory || _viewType == kViewTypeTestimony) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        [detailView setHeader:row[@"Title"]];
        [detailView loadHTMLString:row[@"Description"]];
        [detailView setButtonTitle:@"Read More"];
        detailView.sendButtonTapped = ^(){
            NSDictionary *row = (NSDictionary *)list[indexPath.row];
            WebViewController *vc = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
            vc.link = row[@"box_link_dir"];
            vc.dict = row;
            vc.shouldRefresh = YES;
            vc.webType = kWebTypeFactSheet;
            
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                //[self showPDF:row[@"box_link_dir"]];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        };
        [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
    }
    else if (_viewType == kViewTypeBulletin) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        [detailView setHeader:row[@"Title"]];
        [detailView loadHTMLString:([row[@"Long_Description"] isEqualToString:@""]) ? row[@"Description"] : row[@"Long_Description"]];
        if ([(NSString *)row[@"box_link_dir"] isEqualToString:@""]) {
            [detailView setButtonTitle:@"Close"];
            detailView.sendButtonTapped = ^(){
                [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                }];
            };
        }
        else {
            [detailView setButtonTitle:@"Read More"];
            detailView.sendButtonTapped = ^(){
                WebViewController *vc = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
                vc.link = row[@"box_link_dir"];
                vc.dict = row;
                vc.shouldRefresh = YES;
                vc.webType = kWebTypeFactSheet;
                [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
                    //[self showPDF:row[@"box_link_dir"]];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            };
        }
        [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
    }
    else if (_viewType == kViewTypeAHANews) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        [detailView setHeader:row[@"name"]];
        [action getAHAArticle:row[@"link"] completion:^(NSString *response, NSError *err) {
            [detailView loadHTMLString:response];
        }];
        [detailView setButtonTitle:@"Close"];
        detailView.sendButtonTapped = ^(){
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
            }];
        };
        [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
    }
    else if (_viewType == kViewTypeCalendar) {
        NSArray *arr = list[indexPath.section];
        AHACalendarItem *item = (AHACalendarItem *)arr[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        [detailView setHeader:item.orig_title];
        NSString *html = [NSString stringWithFormat:@"<center><h3>Location</h3>%@</br>%@ %@, %@</br><h3>Description</h3>%@</br></center>", item.location_street, item.location_city, item.location_stateprovince, item.location_zippostal, item.desc];
        [detailView loadHTMLString:html];
        [detailView setButtonTitle:@"Close"];
        detailView.sendButtonTapped = ^(){
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
            }];
        };
        [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
    }
    else if (_viewType == kViewTypeFactSheet) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        WebViewController *vc = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
        vc.link = row[@"box_link_dir"];
        vc.dict = row;
        vc.shouldRefresh = YES;
        vc.webType = kWebTypeFactSheet;
        [self.navigationController pushViewController:vc animated:YES];
        //[self showPDF:row[@"box_link_dir"]];
    }
    else if (_viewType == kViewTypeDirectory) {
        //NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        
        [detailView setButtonTitle:@"Close"];
        detailView.sendButtonTapped = ^(){
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
            }];
        };
        VoterVoiceBody *body = (VoterVoiceBody *)list[indexPath.section];
        VoterVoiceMatches *match = (VoterVoiceMatches *)body.matches[indexPath.row];
        [hud showHUDWithMessage:@"Getting Profile"];
        NSMutableString *htmlString = [NSMutableString new];
        [action getProfile:[match.id stringValue] withType:match.type completion:^(NSDictionary *d, NSError *error){
            //VoterVoiceBody *body2 = (VoterVoiceBody *)voter2.response.body[0];
            //NSLog(@"Profile %@", d);
            
            [hud showHUDSucces:YES withMessage:@"Loaded"];
            [htmlString appendString:[NSString stringWithFormat:@"<center><img src=\"%@\" alt=\"%@\" height=\"100\" width=\"100\"></center></br>",
                                      [d valueForKeyPath:@"response.body.photoUrl"],
                                      [d valueForKeyPath:@"response.body.displayName"]]];
            [htmlString appendString:[NSString stringWithFormat:@"<center>%@</center>", [d valueForKeyPath:@"response.body.displayName"]]];

            for (NSDictionary *section in (NSArray *)[d valueForKeyPath:@"response.body.sections"]) {
                [htmlString appendString:[NSString stringWithFormat:@"<center><h3>%@</h3></center>", section[@"name"]]];
                for (NSDictionary *prop in (NSArray *)section[@"properties"]) {
                    NSString *value;
                    if ([prop[@"value"] containsString:@"\r\n"] && ![prop[@"name"] containsString:@"Address"]) {
                        value = [NSString stringWithFormat:@"<ul><li>%@</li></ul>",[prop[@"value"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"</li><li>"]];
                    } else {
                        value = prop[@"value"];
                    }
                    [htmlString appendString:[NSString stringWithFormat:@"<p><b>%@</b><br/>%@</p>", prop[@"name"], value]];
                    [detailView setHeader:[d valueForKeyPath:@"response.body.displayName"]];
                    [detailView loadHTMLString:htmlString];
                    [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
                }
            }
             
        }];
    }
    else {
        
    }
}

@end
