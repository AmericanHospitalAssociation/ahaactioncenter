//
//  ActionCenterManager.m
//  ahaactioncenter
//
//  Created by Server on 4/4/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "ActionCenterManager.h"

static NSString *SolsticeContacts = @"https://solstice.applauncher.com/external/contacts.json";

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

- (void)getSolisticeContacts:(CompletionContactsBlock)completion
{
    NSURL *url = [NSURL URLWithString:SolsticeContacts];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:20.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSArray *contacts = [NSObject arrayOfType:[Contact class] FromJSONData:responseObject];
        
        //completion(contacts, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
    [operation start];
}

@end
