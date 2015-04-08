//
//  ActionAlertTableViewCell.h
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 1/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionAlertTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionNeededLabel;
@property (weak, nonatomic) IBOutlet UILabel *whenLabel;
@property (weak, nonatomic) IBOutlet UILabel *whyLabel;
@property (weak, nonatomic) IBOutlet UILabel *howLabel;

@end
