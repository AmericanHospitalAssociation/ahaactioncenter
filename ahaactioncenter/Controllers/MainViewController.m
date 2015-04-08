//
//  MainViewController.m
//  ahaactioncenter
//
//  Created by Server on 4/5/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "FontAwesomeKit.h"
#import "ActionCenterManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"WELCOME";
    
    self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs boolForKey:@"isLoggedIn"])
    {
        LoginViewController *vc = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
