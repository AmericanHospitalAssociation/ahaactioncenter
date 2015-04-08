//
//  MatchedTargetTableViewCell.h
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 2/12/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchedTargetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@end
