//
//  MedicareTableViewCell.h
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 1/8/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicareTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
