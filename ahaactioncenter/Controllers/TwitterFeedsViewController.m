//
//  TwitterFeedsViewController.m
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 1/8/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "TwitterFeedsViewController.h"
#import "TwitterTableViewCell.h"
#import "SWRevealViewController.h"
#import "STTwitter.h"

#import "DataModels.h"

@interface TwitterFeedsViewController ()
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation TwitterFeedsViewController
@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tweets";
    items = [NSMutableArray new];

    // set up twitter
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"e142fgaT5I5ktjtEtY3bThbZF"
                                                            consumerSecret:@"DpucZemiwEQ4StqvGOo1NLhGuBRyqWm9ma0uEt7ohXDofl5pp9"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        
        [twitter getUserTimelineWithScreenName:self.twitterHandle
                                  successBlock:^(NSArray *statuses) {
                                      // ...
                                       //NSLog(@"%@", statuses);
                                      for (NSDictionary *d in statuses) {
                                          UserStatusTwitterItem *item = [UserStatusTwitterItem modelObjectWithDictionary:d];
                                           //NSLog(@"      ****************  ITEM ITEM ITEM ITEM ITEM ITEM **************** %@", item.createdAt);
                                          [items addObject:item];
                                      }
                                      [self.tableView reloadData];
                                      
                                      
                                  } errorBlock:^(NSError *error) {
                                      // ...
                                      // NSLog(@"INNER ERROR: %@", error);
                                  }];
        
    } errorBlock:^(NSError *error) {
        // ...
        // NSLog(@"OUTER ERROR: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twitter_feed_cell" forIndexPath:indexPath];
    
    UserStatusTwitterItem *item = [items objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = item.user.name;
    cell.accountNameLabel.text = [NSString stringWithFormat:@"@%@", item.user.screenName];
    
    cell.tweetLabel.text = [self cleanString:item.text];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //Wed Dec 01 17:08:03 +0000 2010
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [df dateFromString:item.createdAt];
    
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *dateStr = [df stringFromDate:date];
    cell.dateLabel.text = dateStr;
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm";
    
    
    NSString *dateString = [timeFormatter stringFromDate: date];
    
    cell.timeLabel.text = dateString;
    // NSLog(@"   TIME   : %@", dateString);
    
    return cell;
}

- (NSString *) cleanString:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    return str;
}

@end
