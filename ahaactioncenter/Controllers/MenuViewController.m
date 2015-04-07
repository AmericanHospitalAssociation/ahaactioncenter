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
#import "TwitterFeedsViewController.h"
#import "CampaignDetailView.h"

@interface MenuViewController () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Menu";
    
    _data = [ActionCenterManager menuItems];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    treeView.backgroundColor = [UIColor clearColor];
    treeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [treeView reloadData];
    //[treeView setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];    
    
    self.treeView = treeView;
    [self.view insertSubview:treeView atIndex:0];
    
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
    NSDictionary *row = (NSDictionary *)item;
    [treeView deselectRowForItem:item animated:YES];
    //NSLog(@"%@", row[@"title"]);
    
    CampaignDetailView *v = [[CampaignDetailView alloc] initWithFrame:CGRectMake(0, 0, 280, 400)];
    [v setHeader:@"teser"];
    
    v.sendButtonTapped =^(){
        NSLog(@"Button Tapped");
        [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:nil];
    };
    
    [[KGModal sharedInstance] showWithContentView:v andAnimated:YES];
    if (![row[@"storyboard"] isEqualToString:@""])
    {
        [self transitionToViewController:row[@"storyboard"]];
    }
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
    
    if ([storyboard isEqualToString:@"twitter"])
    {
        TwitterFeedsViewController *vc = (TwitterFeedsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:storyboard];
        vc.twitterHandle = @"@AHAhospitals";
        nav = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    
    [self.dynamicsDrawerViewController setPaneViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
