//
//  ActionCenterManager.m
//  ahaactioncenter
//
//  Created by Server on 4/4/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "ActionCenterManager.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "FontAwesomeKit.h"
#import "MainViewController.h"
#import "MenuViewController.h"

static NSString *AHANews = @"http://news.aha.org/feed/json?type=aha-news-now&show=25";
//static NSString *AHAFeedLink = @"https://ahaconnect.org/feed.php?id=app_feed_1&lastUpdate=0";
static NSString *AHAFeedLink = @"http://ahaconnect.org/feed.php?id=app_feed_1";
static NSString *AHANewsLink = @"http://54.245.255.190/p/action_center/api/v1/getAHANewsDescription?url=%@";
static NSString *AHACalendarLink = @"http://ahaconnect.org/feed.php?id=app_cal_public";
static NSString *AMSOAM = @"http://ahaconnect.org/apis/sso.php?email=%@&password=%@&db=prod";
static NSString *VoterVoiceGetUser = @"http://54.245.255.190/p/action_center/api/v1/getUserIdentity?zipcode=%@&email=%@";
static NSString *VoterVoiceGetUserProfile = @"http://54.245.255.190/p/action_center/api/v1/getUser?token=%@";
static NSString *VoterVoiceVerifyAddress = @"http://54.245.255.190/p/action_center/api/v1/verifyAddress?address=%@&zipcode=%@&country=%@";
static NSString *VoterVoiceSendEmailVerify = @"http://54.245.255.190/p/action_center/api/v1/emailVerification?email=%@";
static NSString *VoterVoiceVerifyEmailID = @"http://54.245.255.190/p/action_center/api/v1/emailVerification?phone=%@&prefix=%@&verificationID=%@&code=%@&org=%@&email=%@&firstName=%@&address=%@&zipcode=%@&country=US&lastName=%@";
static NSString *VoterVoiceCreateUser = @"http://54.245.255.190/p/action_center/api/v1/createUser?org=%@&email=%@&firstName=%@&address=%@&zipcode=%@&country=%@&lastName=%@&phone=%@&prefix=%@";
static NSString *VoterVoiceMatchesForCampaign = @"http://54.245.255.190/p/action_center/api/v1/getMatchedTargetsForCampaign?campaignId=%@&token=%@";
static NSString *VoterVoiceMatchesNoCampaign = @"http://54.245.255.190/p/action_center/api/v1/getMatchedTargetsNoCampaign?token=%@";
static NSString *VoterVoiceCampaignSummaries = @"http://54.245.255.190/p/action_center/api/v1/getCampaignSummaries";
static NSString *VoterVoiceTargertedMessage = @"http://54.245.255.190/p/action_center/api/v1/getTargetedMessages?campaignId=%@";
static NSString *VoterVoiceGetProfile = @"http://54.245.255.190/p/action_center/api/v1/getProfile?id=%@&type=%@";
static NSString *VoterVoiceGetRequiredFields = @"http://54.245.255.190/p/action_center/api/v1/messagedeliveryoptions?targettype=%@&targetid=%@";


@implementation ActionCenterManager

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static ActionCenterManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[ActionCenterManager alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}


#pragma mark - Share Methods
+ (UIBarButtonItem *)dragButton {
    FAKIonIcons *drag = [FAKIonIcons iconWithCode:@"\uf130" size:30];
    [drag addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[drag imageWithSize:CGSizeMake(30, 30)]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openPane)];
    return btn;
}

+ (UIBarButtonItem *)splitButton {
    FAKIonIcons *drag = [FAKIonIcons iconWithCode:@"\uf264" size:30];
    [drag addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[drag imageWithSize:CGSizeMake(30, 30)]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(closeMenu)];
    return btn;
}

+ (UIBarButtonItem *)refreshButton {
    FAKIonIcons *refresh = [FAKIonIcons iconWithCode:@"\uf49a" size:30];
    [refresh addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[refresh imageWithSize:CGSizeMake(30, 30)]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:nil
                                                                             action:nil];
    return btn;
}

+ (void)openPane
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [ad openSideMenu];
}

+ (void)closeMenu
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //UISplitViewController *split = (UISplitViewController *)ad.splitViewController;
    [ad toggleMenu];
}

+ (NSString *)formatDate:(NSString *)date {
    NSDateFormatter *oldFormatter = [[NSDateFormatter alloc] init];
    //NSLog(@"IN %@", date);
    if ([date containsString:@"-"]) {
        [oldFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else {
        [oldFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    
    NSDate *dateFromStr = [oldFormatter dateFromString:date];
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
    newFormatter.dateStyle = NSDateIntervalFormatterMediumStyle;;
    //[newFormatter setDateFormat:@"MMM dd, yyyy"];
    //NSLog(@"IN %@- OUT %@", date, [newFormatter stringFromDate:dateFromStr]);
    return [newFormatter stringFromDate:dateFromStr];
}


+ (NSArray *)menuItems
{
    NSDictionary *alerts = @{@"title" : @"Action Alerts", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *facts = @{@"title" : @"Fact Sheets", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *bulletins = @{@"title" : @"Special Bulletins", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *advisories = @{@"title" : @"Advisories", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *letters = @{@"title" : @"Letters", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *testimony = @{@"title" : @"Testimony", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *additional = @{@"title" : @"Additional Info", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    
    NSDictionary *legislators = @{@"title" : @"Contact Your Legislators", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *congress = @{@"title" : @"Working with Congress", @"storyboard" : @"webView", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *calendar = @{@"title" : @"Congressional Calendar", @"storyboard" : @"webView", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *directory = @{@"title" : @"Directory", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    
    NSDictionary *latest = @{@"title" : @"Latest Information", @"storyboard" : @"", @"level" : @"2", @"image" : @"", @"items" : @[alerts, facts, bulletins, advisories, letters, testimony, additional]};
    NSDictionary *takeAction = @{@"title" : @"Take Action", @"storyboard" : @"", @"level" : @"2", @"image" : @"", @"items" : @[legislators, congress, calendar, directory]};
    NSDictionary *twAdvocacy = @{@"title" : @"@AHAadvocacy", @"storyboard" : @"general", @"level" : @"2", @"image" : @"", @"items" : @[]};
    NSDictionary *twHospitals = @{@"title" : @"@AHAhospitals", @"storyboard" : @"general", @"level" : @"2", @"image" : @"", @"items" : @[]};
    
    NSDictionary *home = @{@"title" : @"Home", @"storyboard" : @"main", @"level" : @"1", @"image" : @"\uf448", @"items" : @[]};
    NSDictionary *action = @{@"title" : @"Action Center", @"storyboard" : @"", @"level" : @"1", @"image" : @"\uf101", @"items" : @[takeAction, latest,]};
    NSDictionary *events = @{@"title" : @"Events", @"storyboard" : @"general", @"level" : @"1", @"image" : @"\uf3f4", @"items" : @[]};
    NSDictionary *twitter = @{@"title" : @"Twitter Feeds", @"storyboard" : @"", @"level" : @"1", @"image" : @"\uf243", @"items" : @[twAdvocacy, twHospitals]};
    NSDictionary *news = @{@"title" : @"AHA News", @"storyboard" : @"general", @"level" : @"1", @"image" : @"\uf472", @"items" : @[]};
    NSDictionary *contact = @{@"title" : @"Contact AHA", @"storyboard" : @"general", @"level" : @"1", @"image" : @"\uf47c", @"items" : @[]};
    NSDictionary *profile = @{@"title" : @"User Profile", @"storyboard" : @"profile", @"level" : @"1", @"image" : @"\uf47e", @"items" : @[]};
    
    return @[home, action, events, twitter, news, contact, profile];
}

- (NSString *)encodeURL:(NSString *)url {
    /*
    NSString * encoded = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL,
                                                                                      (__bridge CFStringRef)url,
                                                                                      NULL,
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8);
     */
    NSString *encoded = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    return encoded;
}

- (NSString *)isNull:(NSString *)str {
    NSString *tmpStr = (str) ? str : @"";
    //NSLog(@"nillly %@", tmpStr);
    return tmpStr;
}

- (NSString *)cleanPhone:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"*" withString:@""];
    
    return str;
}

- (NSError *)noInternetError {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"No Internet" forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"aha.org" code:500 userInfo:details];
    return error;
}

- (NSError *)accountError {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"Account Error" forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"aha.org" code:500 userInfo:details];
    return error;
}

- (NSError *)accountError:(NSString *)descr {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:descr forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"aha.org" code:500 userInfo:details];
    return error;
}

- (void)showAlert:(NSString *)alert withMessage:(NSString *)msg {
    NSString *str;
    if ([alert containsString:@"address"]) {
        str = @"Your address on file does not match U.S. Postal Service records. Before sending a message to your legislator, please contact AHA to update your address.";
    }
    else {
        str = @"There is something wrong with your AHA account. Please contact AHA for details";
    }
    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"Account Error"
                                                                   message:str
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:^void (UIAlertAction *action)
                      {
                          
                      }]];
    [alert2 addAction:[UIAlertAction actionWithTitle:@"Contact AHA"
                                              style:UIAlertActionStyleDefault
                                            handler:^void (UIAlertAction *action)
                      {
                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.aha.org/updateprofile"]];
                      }]];
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        UISplitViewController *split = (UISplitViewController *)ad.splitViewController;
        [split presentViewController:alert2 animated:YES completion:nil];
    }
    else {
        UIWindow *window = ad.window;
        [window.rootViewController presentViewController:alert2 animated:YES completion:nil];
    }
}

- (BOOL)isReachable {
    AFNetworkReachabilityManager *reach = [AFNetworkReachabilityManager sharedManager];
    [reach startMonitoring];
    BOOL reachable = [reach isReachable];
    NSLog(@"%i reach", reachable);
    if (!reachable) {
        [[ProgressHUD sharedInstance] showHUDSucces:NO withMessage:@"No Internet"];
        /*
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"NO Internet Connection" message:@"Please Try agin once you have an internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
         */
    }
    return reachable;
}

#pragma mark - AHA News Methods
- (void)getAHANews:(CompletionAHANews)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = AHANews;
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *jsonDataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        completion(jsonDataArray, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getAHAFeed:(CompletionAHAFeed)completion
{
    NSString *strUrl = AHAFeedLink;
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        //NSLog(@"dict %@", dict);
        /*
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        AHAFeed *feed = [[AHAFeed alloc] initWithJSONData:jsonData];
         */
        _feeds = (NSArray *)dict[@"FEED_PAYLOAD"];
        _alerts = (NSArray *)dict[@"FEED_NOTIFICATIONS"];
        
        completion(_feeds, _alerts, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, nil, error);
    }];
    
    [operation start];
}

- (void)getAHACalendar:(CompletionAHACalendar)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = AHACalendarLink;
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        AHACalendar *calendar = [[AHACalendar alloc] initWithJSONData:responseObject];
        
        completion(calendar, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getAHAArticle:(NSString *)link completion:(CompletionAHALink)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:AHANewsLink, link];
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        
        completion(dict[@"response"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

#pragma mark - OAM
- (void)getOAMUser:(NSString *)email withPassword:(NSString *)password completion:(CompletionOAM)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:AMSOAM, email, password];
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        OAM *oam = [[OAM alloc] initWithJSONData:responseObject];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:(NSData *)responseObject forKey:@"user"];
        [prefs setObject:(oam.first_name == nil) ? @"" : oam.first_name forKey:@"firstName"];
        [prefs setObject:(oam.last_name == nil) ? @"" : oam.last_name forKey:@"lastName"];
        [prefs setObject:(oam.address_line == nil) ? @"" : oam.address_line forKey:@"address"];
        [prefs setObject:(oam.city == nil) ? @"" : oam.city forKey:@"city"];
        [prefs setObject:(oam.state == nil) ? @"" : oam.state forKey:@"state"];
        [prefs setObject:(oam.zip == nil) ? @"" : oam.zip forKey:@"zip"];
        [prefs setObject:(oam.prefix == nil) ? @"" : oam.prefix forKey:@"prefix"];
        [prefs setObject:(oam.phone == nil) ? @"" : oam.phone forKey:@"phone"];
        if (oam.phone != nil) {
            [prefs setObject:oam.phone forKey:@"phone"];
        }
        if (oam.prefix != nil) {
            [prefs setObject:oam.prefix forKey:@"prefix"];
        }
        [prefs synchronize];
        completion(oam, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

#pragma mark - Voter Voice Methods
- (void)verifyUser:(NSString *)email withZip:(NSString *)zip completion:(CompletionVoterVoice)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceGetUser, zip, email];
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        NSLog(@"dict %@", dict);
        completion(voter, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getUser:(NSString *)token completion:(CompletionVoterVoice)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceGetUserProfile, token];
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        NSLog(@"dict %@", dict);
        completion(voter, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)verifyAddress:(NSString *)address withZip:(NSString *)zip  andCountry:(NSString *)country completion:(CompletionVoterVoiceBody)completion
{
    /*
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
     */
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceVerifyAddress, address, zip, country];
    NSLog(@"url %@", [self encodeURL:strUrl]);
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        NSLog(@"-------%@",dict);
        completion(dict, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"error address");
        completion(nil, error);
    }];
    
    [operation start];
}
//@"https://54.245.255.190/p/action_center/api/v1/createUser?org=NEW&email=vince.davis@me.com&firstName=vince&address=24a%20Blake%20St&zipcode=29403&country=US&lastName=davis&phone=8472128597&prefix=dr"
- (void)createUser:(OAM *)oam withEmail:(NSString *)email completion:(CompletionVoterVoiceNew)completion
{
    if (![self isReachable]) {
        completion(nil, nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceCreateUser,
                        [self isNull:oam.org_name],
                        email,
                        [self isNull:oam.first_name],
                        [self isNull:oam.address_line],
                        //[[self isNull:oam.zip] substringToIndex:5],
                        [self isNull:oam.zip],
                        @"US",
                        [self isNull:oam.last_name],
                        [self cleanPhone:[self isNull:oam.phone]],
                        [self isNull:oam.prefix]];
    
    if ([[self isNull:oam.prefix] isEqualToString:@""]) {
        strUrl = [strUrl stringByReplacingOccurrencesOfString:@"&prefix=" withString:@""];
    }
    if ([[self isNull:oam.phone] isEqualToString:@""]) {
        strUrl = [strUrl stringByReplacingOccurrencesOfString:@"&phone=" withString:@""];
    }
    NSLog(@" URL %@", [self encodeURL:strUrl]);
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        NSLog(@"body1 %@", [dict valueForKeyPath:@"response.body"]);
        long status = (long)[dict valueForKeyPath:@"response.status"];
        //NSLog(@"dict %@  %ld", dict, status);
        if ([[dict valueForKeyPath:@"response.body"] isKindOfClass:[NSString class]]) {
            NSLog(@"body1 %@", [dict valueForKeyPath:@"response.body"]);
            completion(nil, nil, [self accountError:[dict valueForKeyPath:@"response.body"]]);
        }
        else {
            if ([dict valueForKeyPath:@"response.body.userId"] != nil && [dict valueForKeyPath:@"response.body.userToken"] != nil) {
                //NSLog(@"-----------------asdsadsadasdasdsa------");
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setBool:YES forKey:@"isLoggedIn"];
                [prefs setBool:YES forKey:@"inVoterVoice"];
                //[prefs setObject:_emailField.text forKey:@"email"];
                [prefs setObject:[dict valueForKeyPath:@"response.body.userToken"] forKey:@"token"];
                [prefs setObject:(NSString *)[dict valueForKeyPath:@"response.body.userId"] forKey:@"userId"];
                [prefs synchronize];
                completion([NSString stringWithFormat:@"%ld", (long)[dict valueForKeyPath:@"response.body.userId"]], [dict valueForKeyPath:@"response.body.userToken"], nil);
            }
            else {
                NSLog(@"body2 %@", [dict valueForKeyPath:@"response.body"]);
                completion(nil, nil, [self accountError:[dict valueForKeyPath:@"response.body"]]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, nil, [self noInternetError]);
    }];
    
    [operation start];
}

- (void)sendEmailVerification:(NSString *)email completion:(CompletionVoterVoice)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceSendEmailVerify,email];
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        
        completion(voter, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getMatchesForCampaign:(NSString*)campaignId withToken:(NSString *)token completion:(CompletionVoterVoice)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl;
    if (campaignId == nil) {
        strUrl = [NSString stringWithFormat:VoterVoiceMatchesNoCampaign, token];
    }
    else {
        strUrl = [NSString stringWithFormat:VoterVoiceMatchesForCampaign, campaignId, token];
    }
    
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        
        completion(voter, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

//@"https://54.245.255.190/p/action_center/api/v1/emailVerification?phone=%@&prefix=%@&verificationID=%@&code=%@&org=%@&email=%@&firstName=%@&address=%@&zipcode=%@&country=US&lastName=%@"
- (void)verifyEmailID:(OAM *)oam withID:(NSString *)verificationID andCode:(NSString *)code completion:(CompletionVoterVoice)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceVerifyEmailID,
                        oam.phone,
                        oam.prefix,
                        verificationID,
                        code,
                        oam.org_name,
                        oam.email,
                        oam.first_name,
                        oam.address_line,
                        oam.zip,
                        @"US",
                        oam.last_name];
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        
        completion(voter, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getCampaignSummaries:(CompletionVoterVoice)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = VoterVoiceCampaignSummaries;
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        
        completion(voter, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)postVoterUrl:(NSString *)strUrl completion:(CompletionVoterVoice)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    //NSString *strUrl = VoterVoiceCampaignSummaries;
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        
        completion(voter, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getTargetedMessages:(NSString *)campaignID completion:(CompletionVoterVoice)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceTargertedMessage, campaignID];
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    //NSLog(@"%@", [self encodeURL:strUrl]);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        NSLog(@"-------%@",dict);
        completion(voter, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getRequiredFields:(NSString *)targetType withTargetId:(NSString *)targetId completion:(CompletionVoterVoiceBody)completion {
    /*
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
     */
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceGetRequiredFields, targetType, targetId];
    //NSLog(@"%@",[self encodeURL:strUrl]);
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //VoterVoice *voter = [[VoterVoice alloc] initWithJSONData:responseObject];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        //NSLog(@"-------%@",dict);
        completion(dict, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getProfile:(NSString *)profileID withType:(NSString *)type completion:(CompletionVoterVoiceBody)completion
{
    if (![self isReachable]) {
        completion(nil, [self noInternetError]);
        return;
    }
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceGetProfile, profileID, type];
    NSURL *url = [NSURL URLWithString:[self encodeURL:strUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        /*
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:0
                                                             error:&error];
        VoterVoiceBody *body = [[VoterVoiceBody alloc] initWithJSONData:jsonData];
        */
        completion(dict, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

@end
