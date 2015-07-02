//
//  GeneralTableViewController.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kViewTypeTwitter,
    kViewTypeCalendar,
    kViewTypeCampaign,
    kViewTypeActionAlert,
    kViewTypeBulletin,
    kViewTypeLetter,
    kViewTypeDirectory,
    kViewTypeFactSheet,
    kViewTypeAdvisory,
    kViewTypeTestimony,
    kViewTypeAHANews,
    kViewTypeAdditional,
    kViewTypeContactUs,
    kViewTypeDefault
} kViewType;

@interface GeneralTableViewController : UITableViewController

@property(nonatomic, assign)kViewType viewType;
@property(nonatomic, assign)BOOL viewShouldRefresh;
@property(nonatomic, retain)NSDictionary *dict;

@end
