//
//  WebViewController.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "WebViewController.h"
#import "ProgressHUD.h"
#import "ActionCenterManager.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    ActionCenterManager *action;
    ProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    action = [ActionCenterManager sharedInstance];
    hud = [ProgressHUD sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //[hud showHUDWithMessage:@"Loading"];
    if (_webType == kWebTypeCongressCalendar) {
        self.title = @"Congressional Calendar";
        self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
    }
    if (_webType == kWebTypeWorkingWithCongress) {
        self.title = @"Working with Congress";
        self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
    }
    if (_webType == kWebTypeFactSheet) {
        self.title = @"Fact Sheets";
        //self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
    }
    
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_link]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[hud showHUDSucces:YES withMessage:@"Loaded"];
}


@end
