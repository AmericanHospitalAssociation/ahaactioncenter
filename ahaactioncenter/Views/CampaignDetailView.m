//
//  CampaignDetailView.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "CampaignDetailView.h"
#import "Constants.h"

@interface CampaignDetailView()<UIWebViewDelegate>
{
    UILabel *titleLabel;
    UIWebView *webView;
    UIButton *sendButton;
}

@end

@implementation CampaignDetailView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView:frame];
    }
    return self;
}

- (void)setupView:(CGRect)frame
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50)];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setBackgroundColor:kAHABlue];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height, frame.size.width, frame.size.height - 100)];
    webView.delegate = self;
    
    sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, webView.frame.size.height + titleLabel.frame.size.height, frame.size.width, 50)];
    [sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:kAHARed];
    [sendButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
    [sendButton setTitle:@"Take Action" forState:UIControlStateNormal];
    
    [self addSubview:titleLabel];
    [self addSubview:webView];
    [self addSubview:sendButton];
}

- (void)setHeader:(NSString *)header
{
    titleLabel.text = header;
}

- (void)loadHTMLString:(NSString *)string {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><link href=\"default.css\" rel=\"stylesheet\" type=\"text/css\" /></head><body>%@</body></html>", string];
    [webView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)sendButtonPressed:(id)sender
{
    if (_sendButtonTapped) {
        _sendButtonTapped();
    }
}

#pragma mark - WebView Delegate
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
