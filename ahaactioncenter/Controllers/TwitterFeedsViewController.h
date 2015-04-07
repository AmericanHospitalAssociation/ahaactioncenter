//
//  TwitterFeedsViewController.h
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 1/8/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@interface TwitterFeedsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSString *twitterHandle;

@end
