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
    
    self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self loadCustomView];
}

- (void)loadCustomView
{
    if (_viewType == kViewTypeTwitter && _viewShouldRefresh) {
        self.title = @"Twitter";
        [hud showHUDWithMessage:@"Getting Tweets"];
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
                                          [hud showHUDSucces:YES withMessage:@"Loaded"];
                                      } errorBlock:^(NSError *error) {
                                          
                                      }];
        } errorBlock:^(NSError *error) {
        }];
    }
    if (_viewType == kViewTypeCalendar && _viewShouldRefresh) {
        self.title = @"Calendar";
        [hud showHUDWithMessage:@"Loading Calendar"];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSMutableSet *set = [[NSMutableSet alloc] init];
        [action getAHACalendar:^(AHACalendar *calendar, NSError *error){
            for (AHACalendarItem *item in calendar.items) {
                [set addObject:item.pretty_date];
            }
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES];
            [set sortedArrayUsingDescriptors:@[sort]];
            for (NSString *date in set) {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (AHACalendarItem *item in calendar.items) {
                    if ([date isEqualToString:item.pretty_date]) {
                        [arr addObject:item];
                    }
                }
                [items addObject:arr];
            }
            list = (NSArray *)items;
            [self.tableView reloadData];
            [hud showHUDSucces:YES withMessage:@"Loaded"];
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
                [hud showHUDSucces:YES withMessage:@"Loaded"];
                [self.tableView reloadData];
                _viewShouldRefresh = NO;
            }
        }];
    }
    if (_viewType == kViewTypeActionAlert && _viewShouldRefresh) {
        self.title = @"Action Alerts";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@", @"action-alert"];
        list = [action.feeds filteredArrayUsingPredicate:predicate];
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeLetter && _viewShouldRefresh) {
        self.title = @"Letters";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@", @"letter"];
        list = [action.feeds filteredArrayUsingPredicate:predicate];
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeBulletin && _viewShouldRefresh) {
        self.title = @"Special Bulletins";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@", @"bulletin"];
        list = [action.feeds filteredArrayUsingPredicate:predicate];
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeFactSheet && _viewShouldRefresh) {
        self.title = @"Fact Sheets";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@", @"issue-papers"];
        list = [action.feeds filteredArrayUsingPredicate:predicate];
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeAdvisory && _viewShouldRefresh) {
        self.title = @"Advisory";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@", @"advisory"];
        list = [action.feeds filteredArrayUsingPredicate:predicate];
        [self.tableView reloadData];
    }
    if (_viewType == kViewTypeTestimony && _viewShouldRefresh) {
        self.title = @"Testimonies";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@", @"testimony"];
        list = [action.feeds filteredArrayUsingPredicate:predicate];
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
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)sender;
        UIView *parent = [btn superview];
        NSString *groupID;
        for (UIView *child in [parent subviews]) {
            if ([child isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)child;
                // NSLog(@"LABEL TEXT: %@", label.text);
                groupID = label.text;
            }
            
        }
        if (groupID != nil && groupID.length > 0) {
            [self performSegueWithIdentifier:@"take_action" sender:groupID];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        VoterVoiceBody *body = (VoterVoiceBody *)voter.response.body[section];
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
        titleLabel.text = sectionName;
        [v addSubview:titleLabel];
        return v;
    }
    if (_viewType == kViewTypeDirectory) {
        VoterVoiceBody *body = (VoterVoiceBody *)voter.response.body[section];
        
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        UIView *headerView = [[UIView alloc] initWithFrame:frame];
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 55, 30)];
        NSString *str = body.groupId;
        [headerView setBackgroundColor:[UIColor colorWithRed:185.0/255.0f green:217.0f/255.0f blue:235.0f/255.0f alpha:1.0f]];
        header.text = [NSString stringWithFormat:@"%@", str];
        [header setFont:[UIFont fontWithName:@"Helvetica-Bold"  size:15.0f]];
        [headerView addSubview:header];
        // need a button
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
        return headerView;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_viewType == kViewTypeTwitter) {
        return 238.0f;
    }
    else if (_viewType == kViewTypeCalendar) {
        return 92.0f;
    }
    else if (_viewType == kViewTypeCampaign || _viewType == kViewTypeAHANews || _viewType == kViewTypeFactSheet) {
        return 110.0f;
    }
    else if (_viewType == kViewTypeActionAlert) {
        return 300.0f;
    }
    else if (_viewType == kViewTypeLetter || _viewType == kViewTypeAdvisory || _viewType == kViewTypeTestimony) {
        return 235.0f;
    }
    else if (_viewType == kViewTypeBulletin) {
        return 215.0f;
    }
    else {
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_viewType == kViewTypeActionAlert) {
        ActionAlertTableViewCell *cell = (ActionAlertTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"action_alert_cell"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        cell.titleLabel.text = row[@"Title"];
        cell.actionFromLabel.text = row[@"ActionFrom"];
        cell.actionNeededLabel.text = row[@"ActionNeeded"];
        cell.whenLabel.text = row[@"When_c"];
        cell.whyLabel.text = row[@"Why"];
        return cell;
    }
    if (_viewType == kViewTypeFactSheet) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fact_sheets"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        cell.advisoryTitleLabel.text = row[@"Title"];
        return cell;
    }
    if (_viewType == kViewTypeBulletin) {
        SpecialBulletinTableViewCell *cell = (SpecialBulletinTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"special_bulletin_cell"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        cell.titleLabel.text = row[@"Title"];
        cell.dateLabel.text = row[@"Date"];
        [cell setDescriptionLabelText:row[@"Description"]];
        return cell;
    }
    if (_viewType == kViewTypeLetter || _viewType == kViewTypeTestimony || _viewType == kViewTypeAdvisory) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"advisories"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        [cell setupCellWithTitle:row[@"Title"]
                            date:row[@"Date"]
                     description:row[@"Description"]];
        return cell;
    }
    if (_viewType == kViewTypeTwitter) {
        TwitterTableViewCell *cell = (TwitterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"twitter_feed_cell"];
        UserStatusTwitterItem *item = [list objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = item.user.name;
        cell.accountNameLabel.text = [NSString stringWithFormat:@"@%@", item.user.screenName];
        
        cell.tweetLabel.text = [self cleanString:item.text];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        NSDate *date = [df dateFromString:item.createdAt];
        
        [df setDateFormat:@"MM/dd/yyyy"];
        NSString *dateStr = [df stringFromDate:date];
        cell.dateLabel.text = dateStr;
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm";
        
        NSString *dateString = [timeFormatter stringFromDate: date];
        cell.timeLabel.text = dateString;
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
        
        cell.descLabel.text = item.desc;
        
        return cell;
    }
    if (_viewType == kViewTypeCampaign) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fact_sheets"];
        VoterVoiceBody *body = (VoterVoiceBody *)voter.response.body[indexPath.row];
        cell.advisoryTitleLabel.text = body.headline;
        return cell;
    }
    if (_viewType == kViewTypeAHANews) {
        AHAAdvisoryTableViewCell *cell = (AHAAdvisoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"aha_news"];
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        [cell setupCellWithTitle:row[@"name"]
                            date:row[@"published"]
                     description:nil];
        return cell;
    }
    if (_viewType == kViewTypeDirectory) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17.5f]];
        VoterVoiceBody *body = (VoterVoiceBody *)voter.response.body[indexPath.section];
        VoterVoiceMatches *match = (VoterVoiceMatches *)body.matches[indexPath.row];
        cell.textLabel.text = match.name;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_viewType == kViewTypeTwitter) {
        
    }
    else if (_viewType == kViewTypeCampaign) {
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
    else if (_viewType == kViewTypeActionAlert) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        [detailView setHeader:row[@"Title"]];
        [detailView loadHTMLString:row[@"Long_Description"]];
        [detailView setButtonTitle:@"Close"];
        detailView.sendButtonTapped = ^(){
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
            }];
        };
        [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
    }
    else if (_viewType == kViewTypeLetter || _viewType == kViewTypeAdvisory || _viewType == kViewTypeTestimony) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        [detailView setHeader:row[@"Title"]];
        [detailView loadHTMLString:row[@"Description"]];
        [detailView setButtonTitle:@"Close"];
        detailView.sendButtonTapped = ^(){
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
            }];
        };
        [[KGModal sharedInstance] showWithContentView:detailView andAnimated:YES];
    }
    else if (_viewType == kViewTypeBulletin) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        [detailView setHeader:row[@"Title"]];
        [detailView loadHTMLString:([row[@"Long_Description"] isEqualToString:@""]) ? row[@"Description"] : row[@"Long_Description"]];
        [detailView setButtonTitle:@"Close"];
        detailView.sendButtonTapped = ^(){
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
            }];
        };
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
    else if (_viewType == kViewTypeFactSheet) {
        NSDictionary *row = (NSDictionary *)list[indexPath.row];
        WebViewController *vc = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
        vc.link = row[@"box_link_dir"];
        vc.webType = kWebTypeFactSheet;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_viewType == kViewTypeDirectory) {
        //NSDictionary *row = (NSDictionary *)list[indexPath.row];
        CampaignDetailView *detailView = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
        
        [detailView setButtonTitle:@"Close"];
        detailView.sendButtonTapped = ^(){
            [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^(){
            }];
        };
        VoterVoiceBody *body = (VoterVoiceBody *)voter.response.body[indexPath.section];
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
