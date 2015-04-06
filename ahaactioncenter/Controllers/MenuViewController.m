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

@interface MenuViewController () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_data = [[ActionCenterManager sharedInstance] menuItems];
    [self loadData];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    treeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [treeView reloadData];
    [treeView setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    
    
    self.treeView = treeView;
    [self.view insertSubview:treeView atIndex:0];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"Things", nil);
    
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
    //[[ProgressHUD sharedInstance] showHUDWithMessage:@"tesin"];
}

- (void)loadData
{
    NSDictionary *alerts = @{@"title" : @"Action Alerts", @"storyboard" : @"contactLegislators", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *facts = @{@"title" : @"Fact Sheets", @"storyboard" : @"workingCongress", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *bulletins = @{@"title" : @"Special Bulletins", @"storyboard" : @"calendar", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *advisories = @{@"title" : @"AHA Advisories", @"storyboard" : @"directory", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *letters = @{@"title" : @"Letters", @"storyboard" : @"workingCongress", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *testimony = @{@"title" : @"Testimonyr", @"storyboard" : @"calendar", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *additional = @{@"title" : @"Additional Info", @"storyboard" : @"directory", @"level" : @"3", @"image" : @"", @"items" : @[]};
    
    NSDictionary *legislators = @{@"title" : @"Contact Your Legislators", @"storyboard" : @"contactLegislators", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *congress = @{@"title" : @"Working With Congress", @"storyboard" : @"workingCongress", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *calendar = @{@"title" : @"Congressional Calendar", @"storyboard" : @"calendar", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *directory = @{@"title" : @"Directory", @"storyboard" : @"directory", @"level" : @"3", @"image" : @"", @"items" : @[]};
    
    NSDictionary *latest = @{@"title" : @"Latest Infomation", @"storyboard" : @"", @"level" : @"2", @"image" : @"", @"items" : @[alerts, facts, bulletins, advisories, letters, testimony, additional]};
    NSDictionary *takeAction = @{@"title" : @"Take Action", @"storyboard" : @"", @"level" : @"2", @"image" : @"", @"items" : @[legislators, congress, calendar, directory]};
    NSDictionary *twAdvocacy = @{@"title" : @"@AHAadvocacy", @"storyboard" : @"twitter", @"level" : @"2", @"image" : @"", @"items" : @[]};
    NSDictionary *twHospitals = @{@"title" : @"@AHAhospitals", @"storyboard" : @"twitter", @"level" : @"2", @"image" : @"", @"items" : @[]};
    
    NSDictionary *home = @{@"title" : @"Home", @"storyboard" : @"home", @"level" : @"1", @"image" : @"\uf448", @"items" : @[]};
    NSDictionary *action = @{@"title" : @"Action Center", @"storyboard" : @"", @"level" : @"1", @"image" : @"\uf101", @"items" : @[latest, takeAction]};
    NSDictionary *events = @{@"title" : @"Events", @"storyboard" : @"home", @"level" : @"1", @"image" : @"\uf3f4", @"items" : @[]};
    NSDictionary *twitter = @{@"title" : @"Twitter Feeds", @"storyboard" : @"", @"level" : @"1", @"image" : @"\uf243", @"items" : @[twAdvocacy, twHospitals]};
    NSDictionary *news = @{@"title" : @"AHA News", @"storyboard" : @"home", @"level" : @"1", @"image" : @"\uf472", @"items" : @[]};
    NSDictionary *contact = @{@"title" : @"Contact AHA", @"storyboard" : @"home", @"level" : @"1", @"image" : @"\uf47c", @"items" : @[]};
    
    _data = @[home, action, events, twitter, news, contact];
}

#pragma mark TreeView Data Source
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    NSDictionary *row = (NSDictionary *)item;
    //NSLog(@"%@ - %@", row[@"title"], row[@"level"]);
    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:row[@"title"] level:row[@"level"]];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
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

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item
{
    //NSDictionary *row = (NSDictionary *)item;
    [treeView deselectRowForItem:item animated:YES];
    //NSLog(@"%@", row[@"title"]);
    
    LoginViewController *vc = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    UINavigationController *nav  = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.view.frame = CGRectMake(0, 0, 280, 400);
    vc.view.frame = CGRectMake(0, 0, 280, 400);
    //[[KGModal sharedInstance] showWithContentView:vc.view andAnimated:YES];
    //[self transitionToViewController:@"login"];
}

- (void)transitionToViewController:(NSString *)storyboard
{
    UINavigationController *nav;
    
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
    
    [self.dynamicsDrawerViewController setPaneViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
