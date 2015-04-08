//
//  ActionCenterManager.m
//  ahaactioncenter
//
//  Created by Server on 4/4/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "ActionCenterManager.h"
#import "AppDelegate.h"
#import "FontAwesomeKit.h"

static NSString *AHANews = @"http://news.aha.org/feed/json?type=aha-news-now&show=25";
static NSString *AHAFeedLink = @"http://ahaconnect.org/feed.php?id=app_feed_1&lastUpdate=0";
static NSString *AHANewsLink = @"http://54.245.255.190/p/action_center/api/v1/getAHANewsDescription?url=%@";
static NSString *AHACalendarLink = @"http://ahaconnect.org/feed.php?id=app_cal_public";
static NSString *AMSOAM = @"http://ahaconnect.org/apis/sso.php?email=%@&password=%@&db=prod";
static NSString *VoterVoiceGetUser = @"http://54.245.255.190/p/action_center/api/v1/getUserIdentity?zipcode=%@&email=%@";
static NSString *VoterVoiceVerifyAddress = @"http://54.245.255.190/p/action_center/api/v1/verifyAddress?address=%@&zipcode=%@&country=%@";
static NSString *VoterVoiceSendEmailVerify = @"http://54.245.255.190/p/action_center/api/v1/emailVerification?email=%@";
static NSString *VoterVoiceVerifyEmailID = @"http://54.245.255.190/p/action_center/api/v1/emailVerification?phone=%@&prefix=%@&verificationID=%@&code=%@&org=%@&email=%@&firstName=%@&address=%@&zipcode=%@&country=US&lastName=%@";
static NSString *VoterVoiceCreateUser = @"http://54.245.255.190/p/action_center/api/v1/createUser?org=%@&email=%@&firstName=%@&address=%@&zipcode=%@&country=US&lastName=%@&phone=%@&prefix=%@";
static NSString *VoterVoiceMatchesForCampaign = @"http://54.245.255.190/p/action_center/api/v1/getMatchedTargetsForCampaign?campaignId=%@&token=%@";
static NSString *VoterVoiceCampaignSummaries = @"http://54.245.255.190/p/action_center/api/v1/getCampaignSummaries";
static NSString *VoterVoiceTargertedMessage = @"http://54.245.255.190/p/action_center/api/v1/getTargetedMessages?campaignId=%@";
static NSString *VoterVoiceGetProfile = @"http://54.245.255.190/p/action_center/api/v1/getProfile?id=%@&type=%@";

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

+ (NSArray *)menuItems
{
    NSDictionary *alerts = @{@"title" : @"Action Alerts", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *facts = @{@"title" : @"Fact Sheets", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *bulletins = @{@"title" : @"Special Bulletins", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *advisories = @{@"title" : @"AHA Advisories", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *letters = @{@"title" : @"Letters", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *testimony = @{@"title" : @"Testimony", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *additional = @{@"title" : @"Additional Info", @"storyboard" : @"", @"level" : @"3", @"image" : @"", @"items" : @[]};
    
    NSDictionary *legislators = @{@"title" : @"Contact Your Legislators", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *congress = @{@"title" : @"Working with Congress", @"storyboard" : @"webView", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *calendar = @{@"title" : @"Congressional Calendar", @"storyboard" : @"webView", @"level" : @"3", @"image" : @"", @"items" : @[]};
    NSDictionary *directory = @{@"title" : @"Directory", @"storyboard" : @"general", @"level" : @"3", @"image" : @"", @"items" : @[]};
    
    NSDictionary *latest = @{@"title" : @"Latest Infomation", @"storyboard" : @"", @"level" : @"2", @"image" : @"", @"items" : @[alerts, facts, bulletins, advisories, letters, testimony, additional]};
    NSDictionary *takeAction = @{@"title" : @"Take Action", @"storyboard" : @"", @"level" : @"2", @"image" : @"", @"items" : @[legislators, congress, calendar, directory]};
    NSDictionary *twAdvocacy = @{@"title" : @"@AHAadvocacy", @"storyboard" : @"general", @"level" : @"2", @"image" : @"", @"items" : @[]};
    NSDictionary *twHospitals = @{@"title" : @"@AHAhospitals", @"storyboard" : @"general", @"level" : @"2", @"image" : @"", @"items" : @[]};
    
    NSDictionary *home = @{@"title" : @"Home", @"storyboard" : @"main", @"level" : @"1", @"image" : @"\uf448", @"items" : @[]};
    NSDictionary *action = @{@"title" : @"Action Center", @"storyboard" : @"", @"level" : @"1", @"image" : @"\uf101", @"items" : @[latest, takeAction]};
    NSDictionary *events = @{@"title" : @"Events", @"storyboard" : @"general", @"level" : @"1", @"image" : @"\uf3f4", @"items" : @[]};
    NSDictionary *twitter = @{@"title" : @"Twitter Feeds", @"storyboard" : @"", @"level" : @"1", @"image" : @"\uf243", @"items" : @[twAdvocacy, twHospitals]};
    NSDictionary *news = @{@"title" : @"AHA News", @"storyboard" : @"general", @"level" : @"1", @"image" : @"\uf472", @"items" : @[]};
    NSDictionary *contact = @{@"title" : @"Contact AHA", @"storyboard" : @"general", @"level" : @"1", @"image" : @"\uf47c", @"items" : @[]};
    
    return @[home, action, events, twitter, news, contact];
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
    return tmpStr;
}

#pragma mark - AHA News Methods
- (void)getAHANews:(CompletionAHANews)completion
{
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
        completion((NSArray *)dict[@"FEED_PAYLOAD"], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getAHACalendar:(CompletionAHACalendar)completion
{
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
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceGetUser, zip, email];
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

- (void)verifyAddress:(NSString *)address withZip:(NSString *)zip  andCountry:(NSString *)country completion:(CompletionVoterVoice)completion
{
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceVerifyAddress, address, zip, country];
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
//@"http://54.245.255.190/p/action_center/api/v1/createUser?org=NEW&email=vince.davis@me.com&firstName=vince&address=24a%20Blake%20St&zipcode=29403&country=US&lastName=davis&phone=8472128597&prefix=dr"
- (void)createUser:(OAM *)oam withEmail:(NSString *)email completion:(CompletionVoterVoice)completion
{
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceCreateUser,
                        [self isNull:oam.org_name],
                        email,
                        [self isNull:oam.first_name],
                        [self isNull:oam.address_line],
                        [self isNull:oam.zip],
                        @"US",
                        [self isNull:oam.last_name],
                        [self isNull:oam.phone],
                        [self isNull:oam.prefix]];
 
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

- (void)sendEmailVerification:(NSString *)email completion:(CompletionVoterVoice)completion
{
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
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceMatchesForCampaign, campaignId, token];
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

//@"http://54.245.255.190/p/action_center/api/v1/emailVerification?phone=%@&prefix=%@&verificationID=%@&code=%@&org=%@&email=%@&firstName=%@&address=%@&zipcode=%@&country=US&lastName=%@"
- (void)verifyEmailID:(OAM *)oam withID:(NSString *)verificationID andCode:(NSString *)code completion:(CompletionVoterVoice)completion
{
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
    NSString *strUrl = [NSString stringWithFormat:VoterVoiceTargertedMessage, campaignID];
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

- (void)getProfile:(NSString *)profileID withType:(NSString *)type completion:(CompletionVoterVoiceBody)completion
{
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
