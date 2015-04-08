//
//  AHAStaffTableViewCell.h
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 12/19/14.
//  Copyright (c) 2014 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHAStaffTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;

@end
