//
//  AHACalendarItem.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AHACalendarItem.h"

@interface AHACalendarItem : NSObject

@property (nonatomic, retain) NSString *clean_title;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *hash_id;
@property (nonatomic, retain) NSString *meeting_end_time;
@property (nonatomic, retain) NSString *meeting_location;
@property (nonatomic, retain) NSString *meeting_start_time;
@property (nonatomic, retain) NSString *orig_title;
@property (nonatomic, retain) NSString *pretty_date;
@property (nonatomic, retain) NSNumber *unix_date;

@end
