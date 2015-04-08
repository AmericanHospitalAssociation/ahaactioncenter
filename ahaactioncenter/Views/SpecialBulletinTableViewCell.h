//
//  SpecialBulletinTableViewCell.h
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 1/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialBulletinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
-(void)setDescriptionLabelText:(NSString *)desc;
@end
