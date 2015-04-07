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

static NSString *AMSOAM = @"http://ahaconnect.org/apis/sso.php?email=%@&password=%@&db=prod";
static NSString *VoterVoiceGetUser = @"http://54.245.255.190/p/action_center/api/v1/getUserIdentity?zipcode=%@&email=%@";
static NSString *VoterVoiceVerifyAddress = @"http://54.245.255.190/p/action_center/api/v1/verifyAddress?address=%@&zipcode=%@&country=%@";
static NSString *VoterVoiceSendEmailVerify = @"http://54.245.255.190/p/action_center/api/v1/emailVerification?email=%@";
static NSString *VoterVoiceVerifyEmailID = @"http://54.245.255.190/p/action_center/api/v1/emailVerification?phone=%@&prefix=%@&verificationID=%@&code=%@&org=%@&email=%@&firstName=%@&address=%@&zipcode=%@&country=US&lastName=%@";
static NSString *VoterVoiceCreateUser = @"http://54.245.255.190/p/action_center/api/v1/createUser?org=%@&email=%@&firstName=%@&address=%@&zipcode=%@&country=US&lastName=%@&phone=%@&prefix=%@";

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
    
    return @[home, action, events, twitter, news, contact];
}

#pragma mark - OAM
- (void)getOAMUser:(NSString *)email withPassword:(NSString *)password completion:(CompletionOAM)completion
{
    NSString *strUrl = [NSString stringWithFormat:AMSOAM, email, password];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        OAM *oam = [[OAM alloc] initWithJSONData:responseObject];
        
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
    NSURL *url = [NSURL URLWithString:strUrl];
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
    NSURL *url = [NSURL URLWithString:strUrl];
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

@end
