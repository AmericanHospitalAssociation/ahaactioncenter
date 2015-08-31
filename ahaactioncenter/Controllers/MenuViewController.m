//
//  MenuViewController.m
//  ahaactioncenter
//
//  Created by Server on 4/4/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "MenuViewController.h"
#import "RATreeView.h"
#import "RATableViewCell.h"
#import "FontAwesomeKit.h"
#import "ActionCenterManager.h"
#import "ProgressHUD.h"
#import "KGModal.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "CampaignViewController.h"
#import "CampaignDetailView.h"
#import "CampaignDetailViewController.h"
#import "GeneralTableViewController.h"
#import "WebViewController.h"
#import "FontAwesomeKit.h"
#import "AppDelegate.h"
#import "UpdateUserViewController.h"
#import "ProgressHUD.h"
#import "TweetViewController.h"

@interface MenuViewController () <RATreeViewDelegate, RATreeViewDataSource>
{
    ActionCenterManager *action;
    ProgressHUD *hud;
}

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Menu";
    
    action = [ActionCenterManager sharedInstance];
    hud = [ProgressHUD sharedInstance];
    
    _data = [ActionCenterManager menuItems];
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    
    FAKIonIcons *icon = [FAKIonIcons iconWithCode:@"\uf2a9" size:30];
    
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showContact:)
                                                 name:@"showContact"
                                               object:nil];
    
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithImage:[icon imageWithSize:CGSizeMake(30, 30)]
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(logout)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Logout %@",@""]
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:@selector(logout)];
    /*
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:nil
                                                                          action:nil];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"v%@(%@)",version, build]
                                                              style:UIBarButtonItemStyleDone
                                                             target:self
                                                             action:nil];
    */
    NSArray *buttons = @[item1, item2/*, flex, item3*/];
    [self setToolbarItems:buttons];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    treeView.backgroundColor = [UIColor clearColor];
    treeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [treeView reloadData];
    //[treeView setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    
    self.treeView = treeView;
    [self.view insertSubview:treeView atIndex:0];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 144, 100, 100)];
    iv.image = [UIImage imageNamed:@"aha_a30"];
    [self.view addSubview:iv];
    //[self.view addSubview:_treeView];
    
    
    //[self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([UITableViewCell class]) bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];
    
    //[KGModal sharedInstance].closeButtonType = KGModalCloseButtonTypeRight;
    [KGModal sharedInstance].modalBackgroundColor = [UIColor blackColor];
    [KGModal sharedInstance].backgroundDisplayStyle = KGModalBackgroundDisplayStyleSolid;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    int systemVersion = [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue];
    if (systemVersion >= 7 && systemVersion < 8) {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
    }
    
    self.treeView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:YES];
    if (action.contacAHA) {
        NSLog(@"appear");
        NSDictionary *dict = @{@"storyboard" : @"general", @"title" : @"Contact AHA"};
        //[self transitionToViewController:<#(NSDictionary *)#>]
        [self performSelector:@selector(transitionToViewController:) withObject:dict afterDelay:1.0];
        action.contacAHA = NO;
    }
    //[[ProgressHUD sharedInstance] showHUDWithMessage:@"tesin"];
}

- (void)showContact:(NSNotification *)note {
    NSDictionary *dict = @{@"storyboard" : @"general", @"title" : @"Contact AHA"};
    [self performSelector:@selector(transitionToViewController:) withObject:dict afterDelay:1.0];
}

- (void)logout {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Logout"
                                                                   message:@"Are you sure?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action)
                      {
                          
                      }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action)
                      {
                          NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                          [prefs setBool:NO forKey:@"isLoggedIn"];
                          [prefs setBool:NO forKey:@"inVoterVoice"];
                          [prefs setObject:nil forKey:@"email"];
                          [prefs setObject:nil forKey:@"phone"];
                          [prefs setObject:nil forKey:@"prefix"];
                          [prefs setObject:nil forKey:@"token"];
                          [prefs setObject:nil forKey:@"firstName"];
                          [prefs setObject:nil forKey:@"lastName"];
                          [prefs setObject:nil forKey:@"address"];
                          [prefs setObject:nil forKey:@"city"];
                          [prefs setObject:nil forKey:@"state"];
                          [prefs setObject:nil forKey:@"zip"];
                          [prefs synchronize];
                          LoginViewController *vc = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                          UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                          nav.modalPresentationStyle = UIModalPresentationFormSheet;
                          [self presentViewController:nav animated:YES completion:nil];
                          
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
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
                           //ActionCenterManager *acm = [ActionCenterManager sharedInstance];
                           NSDictionary *dict = @{@"storyboard" : @"general", @"title" : @"Contact AHA"};
                           //[self transitionToViewController:<#(NSDictionary *)#>]
                           [self performSelector:@selector(transitionToViewController:) withObject:dict afterDelay:0.5];
                           //action.contacAHA = NO;
                           
                       }]];

    [self presentViewController:alert2 animated:YES completion:nil];
}

#pragma mark TreeView Data Source
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    NSDictionary *row = (NSDictionary *)item;
    //NSLog(@"%@ - %@", row[@"title"], row[@"level"]);
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:row[@"title"] level:row[@"level"]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    BOOL expanded = [_treeView isCellExpanded:cell];
    UIColor *labelColor = [UIColor colorWithRed:0.188 green:0.498 blue:0.886 alpha:1];
    NSString *chevronCode = (expanded) ? @"\uf123" : @"\uf126" ;
    FAKIonIcons *chevron = [FAKIonIcons iconWithCode:chevronCode size:15];
    [chevron addAttribute:NSForegroundColorAttributeName value:labelColor];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[chevron imageWithSize:CGSizeMake(15, 15)]];
    NSArray *items = (NSArray *)row[@"items"];
    if (items.count > 0) {
        cell.accessoryView = iv;
    }
    else {
        cell.accessoryView = nil;
    }
    
    if ([row[@"level"] intValue] == 1)
    {
        FAKIonIcons *icon = [FAKIonIcons iconWithCode:row[@"image"] size:30];
        [icon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
        cell.imageView.image = [icon imageWithSize:CGSizeMake(30, 30)];
    }
    else
    {
        cell.imageView.image = nil;
    }
    
    return cell;
}

- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    NSDictionary *row = (NSDictionary *)item;
    UITableViewCell *cell = [_treeView cellForItem:item];
    BOOL expanded = [_treeView isCellExpanded:cell];
    UIColor *labelColor = [UIColor colorWithRed:0.188 green:0.498 blue:0.886 alpha:1];
    NSString *chevronCode = (expanded) ? @"\uf123" : @"\uf126" ;
    FAKIonIcons *chevron = [FAKIonIcons iconWithCode:chevronCode size:15];
    [chevron addAttribute:NSForegroundColorAttributeName value:labelColor];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[chevron imageWithSize:CGSizeMake(15, 15)]];
    NSArray *items = (NSArray *)row[@"items"];
    if (items.count > 0) {
        cell.accessoryView = iv;
    }
    else {
        cell.accessoryView = nil;
    }
}

- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    NSDictionary *row = (NSDictionary *)item;
    UITableViewCell *cell = [_treeView cellForItem:item];
    BOOL expanded = [_treeView isCellExpanded:cell];
    UIColor *labelColor = [UIColor colorWithRed:0.188 green:0.498 blue:0.886 alpha:1];
    NSString *chevronCode = (expanded) ? @"\uf123" : @"\uf126" ;
    FAKIonIcons *chevron = [FAKIonIcons iconWithCode:chevronCode size:15];
    [chevron addAttribute:NSForegroundColorAttributeName value:labelColor];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[chevron imageWithSize:CGSizeMake(15, 15)]];
    NSArray *items = (NSArray *)row[@"items"];
    if (items.count > 0) {
        cell.accessoryView = iv;
    }
    else {
        cell.accessoryView = nil;
    }
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [_data count];
    }
    
    NSDictionary *row = (NSDictionary *)item;
    NSArray *children = (NSArray *)row[@"items"];
    return children.count;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    NSDictionary *row = (NSDictionary *)item;
    if (item == nil) {
        return [_data objectAtIndex:index];
    }
    NSArray *children = (NSArray *)row[@"items"];
    return children[index];
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    NSDictionary *row = (NSDictionary *)item;
    [treeView deselectRowForItem:item animated:YES];
    //NSLog(@"%@", row[@"title"]);
    
    CampaignDetailView *v = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    [v setHeader:@"teser"];
    
    v.sendButtonTapped =^(){
        NSLog(@"Button Tapped");
        [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:nil];
    };
    
    //[[KGModal sharedInstance] showWithContentView:v andAnimated:YES];
    if (![row[@"storyboard"] isEqualToString:@""])
    {
        //NSLog(@"Storyboard %@", row[@"storyboard"]);
        [self transitionToViewController:row];
    }
}

- (void)transitionToViewController:(NSDictionary *)dict
{
    UINavigationController *nav;
    NSString *storyboard = dict[@"storyboard"];
    
    if ([storyboard isEqualToString:@"profile"])
    {
        UpdateUserViewController *update = [[UpdateUserViewController alloc] initWithStyle:UITableViewStyleGrouped];
        update.excludeList = @[@"excludedList", @"showPhone"];
        UserForm *form = (UserForm *)update.formController.form;
        form.firstName = @"test";
        update.validateAddress = YES;
        update.showCancel =YES;
        nav = [[UINavigationController alloc] initWithRootViewController:update];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return;
    }
    if ([storyboard isEqualToString:@"main"])
    {
        MainViewController *vc = (MainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:storyboard];
        nav = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    if ([storyboard isEqualToString:@"login"])
    {
        LoginViewController *vc = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:storyboard];
        nav = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    
    if ([storyboard isEqualToString:@"campaign"])
    {
        CampaignViewController *vc = (CampaignViewController *)[self.storyboard instantiateViewControllerWithIdentifier:storyboard];
        nav = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    
    if ([storyboard isEqualToString:@"webView"]) {
        WebViewController *vc = (WebViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
        vc.shouldRefresh = YES;
        if ([dict[@"title"] isEqualToString:@"Congressional Calendar"])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@", @"congressional-calendar"];
            NSArray *list = [action.feeds filteredArrayUsingPredicate:predicate];
            NSDictionary *d = (NSDictionary *)list[0];
            vc.link = d[@"ResourceURI"];
            vc.webType = kWebTypeCongressCalendar;
            nav = [[UINavigationController alloc] initWithRootViewController:vc];
        }
        if ([dict[@"title"] isEqualToString:@"Working with Congress"])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ContentType == %@", @"working-with-congress"];
            NSArray *list = [action.feeds filteredArrayUsingPredicate:predicate];
            NSDictionary *d = (NSDictionary *)list[0];
            vc.link = d[@"ResourceURI"];
            vc.webType = kWebTypeWorkingWithCongress;
            nav = [[UINavigationController alloc] initWithRootViewController:vc];
        }
        
    }
    if ([storyboard isEqualToString:@"general"])
    {
        GeneralTableViewController *vc = (GeneralTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:storyboard];
        nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.dict = dict;
        if ([dict[@"title"] isEqualToString:@"@AHAadvocacy"] || [dict[@"title"] isEqualToString:@"@AHAhospitals"])
        {
            vc.viewType = kViewTypeTwitter;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Events"])
        {
            vc.viewType = kViewTypeCalendar;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Contact Your Legislators"]) {
            vc.viewType = kViewTypeCampaign;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Action Alerts"]) {
            vc.viewType = kViewTypeActionAlert;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Letters"]) {
            vc.viewType = kViewTypeLetter;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Special Bulletins"]) {
            vc.viewType = kViewTypeBulletin;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Directory"]) {
            vc.viewType = kViewTypeDirectory;
            vc.viewShouldRefresh = YES;
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            if (/*[prefs boolForKey:@"inVoterVoice"] == NO*/YES) {
                NSString *prefix = [prefs stringForKey:@"prefix"];
                NSString *phone = [prefs stringForKey:@"phone"];
                NSString *address = [prefs stringForKey:@"address"];
                NSString *city = [prefs stringForKey:@"city"];
                NSString *state = [prefs stringForKey:@"state"];
                NSString *zip = [prefs stringForKey:@"zip"];
                NSLog(@"zip - %@",zip);
                zip = [zip substringToIndex:5];
                NSLog(@"zip - %@",zip);
                OAM *oam = [[OAM alloc] initWithJSONData:[prefs objectForKey:@"user"]];
                if (address == nil) {
                    [self requiredInfo];
                    return;
                }
                else {
                    NSLog(@"------------");
                    [hud showHUDWithMessage:@"Checking User Info"];
                    oam.phone = phone;
                    oam.prefix = prefix;
                   
                    [action verifyAddress:address withZip:zip andCountry:@"US" completion:^(NSDictionary *dict, NSError *err) {
                        //NSString *suggestedZipCode = (NSString *)[dict valueForKeyPath:@"response.body.suggestedZipCode"];
                        //NSString *message = (NSString *)[dict valueForKeyPath:@"response.body.message"];
                        NSArray *arr = (NSArray *)[dict valueForKeyPath:@"response.body.addresses"];
                        if ([dict valueForKeyPath:@"response.body.suggestedZipCode"] == [NSNull null] && [dict valueForKeyPath:@"response.body.message"] == [NSNull null] &&
                            arr.count > 0) {
                            //NSArray *arr = (NSArray *)[dict valueForKeyPath:@"response.body.addresses"];
                            NSDictionary *d = arr[0];
                            [prefs setObject:d[@"streetAddress"] forKey:@"address"];
                            //NSLog(@"********************%@********************", d[@"streetAddress"]);
                            [prefs setObject:d[@"city"] forKey:@"city"];
                            [prefs setObject:d[@"state"] forKey:@"state"];
                            [prefs setObject:d[@"zipCode"] forKey:@"zip"];
                            [prefs synchronize];
                            oam.address_line = d[@"streetAddress"];
                            oam.city = d[@"city"];
                            oam.state = d[@"state"];
                            oam.zip = d[@"zipCode"];
                            
                            [action createUser:oam
                                     withEmail:[prefs stringForKey:@"email"]
                                    completion:^(NSString *userId, NSString *token, NSError *err) {
                                        if (!err) {
                                            [hud showHUDSucces:YES withMessage:@"Success"];
                                            
                                            AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
                                                UISplitViewController *split = (UISplitViewController *)ad.splitViewController;
                                                [split setViewControllers:@[(UINavigationController *)self.navigationController,nav]];
                                            }
                                            else {
                                                MSDynamicsDrawerViewController *dynamic = (MSDynamicsDrawerViewController *)ad.dynamicsDrawerViewController;
                                                [dynamic setPaneViewController:nav animated:YES completion:nil];
                                            }
                                        }
                                        else {
                                            [hud showHUDSucces:NO withMessage:@"Failed"];
                                            [self showAlert:err.description withMessage:@""];
                                        }
                                    }];

                        }
                        else {
                            [hud showHUDSucces:NO withMessage:@"Failed"];
                            [self showAlert:@"address" withMessage:@""];
                            return;
                        }
                    }];
                                        return;
                }
            }
        }
        if ([dict[@"title"] isEqualToString:@"Fact Sheets"]) {
            vc.viewType = kViewTypeFactSheet;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Testimony"]) {
            vc.viewType = kViewTypeTestimony;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Advisories"]) {
            vc.viewType = kViewTypeAdvisory;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"AHA News"]) {
            vc.viewType = kViewTypeAHANews;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Additional Info"]) {
            vc.viewType = kViewTypeAdditional;
            vc.viewShouldRefresh = YES;
        }
        if ([dict[@"title"] isEqualToString:@"Contact AHA"]) {
            vc.viewType = kViewTypeContactUs;
            vc.viewShouldRefresh = YES;
            
            CampaignDetailViewController *cd = (CampaignDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"campaignDetail"];
            cd.campaignID = nil;
            nav = [[UINavigationController alloc] initWithRootViewController:cd];
        }
    }
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        UISplitViewController *split = (UISplitViewController *)ad.splitViewController;
        [split setViewControllers:@[(UINavigationController *)self.navigationController,nav]];
    }
    else {
        MSDynamicsDrawerViewController *dynamic = (MSDynamicsDrawerViewController *)ad.dynamicsDrawerViewController;
        [dynamic setPaneViewController:nav animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
