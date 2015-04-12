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
    NSData *pdfData;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    action = [ActionCenterManager sharedInstance];
    hud = [ProgressHUD sharedInstance];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
    _webView.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(shareButton:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (_shouldRefresh) {
        [hud showHUDWithMessage:@"Loading"];
        if (_webType == kWebTypeCongressCalendar) {
            self.title = @"Congressional Calendar";
            pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_link]];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
            }
        }
        if (_webType == kWebTypeWorkingWithCongress) {
            self.title = @"Working with Congress";
            pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_link]];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
            }
        }
        if (_webType == kWebTypeFactSheet) {
            self.title = _dict[@"Title"];
            pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_link]];
            //self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
        }
        if (_webType == kWebTypeWeb) {
            self.title = _dict[@"Title"];
            //self.navigationItem.leftBarButtonItem = [ActionCenterManager dragButton];
        }
        
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_link]]];
        _shouldRefresh = NO;
    }
}

- (void)shareButton:(UIBarButtonItem *)sender
{
    //NSString *textToShare = _dict[@"Title"];
    NSURL *pdf = [NSURL URLWithString:_link];
    
    NSArray *objectsToShare;
    
    if (pdfData) {
        objectsToShare = @[pdf, pdfData];
    }
    else {
        objectsToShare = @[pdf];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        //self.popover.delegate = self;
        [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else {
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
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
    [hud showHUDSucces:YES withMessage:@"Loaded"];
    NSLog(@"Finish");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"errrrrrrrr");
    [hud showHUDSucces:NO withMessage:@"No Internet"];
}


@end
