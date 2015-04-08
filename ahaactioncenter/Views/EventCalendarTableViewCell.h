//
//  EventCalendarTableViewCell.h
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 1/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCalendarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthSpanLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end
