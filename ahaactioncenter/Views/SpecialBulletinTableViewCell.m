//
//  SpecialBulletinTableViewCell.m
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 1/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "SpecialBulletinTableViewCell.h"

@implementation SpecialBulletinTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.descriptionLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDescriptionLabelText:(NSString *)desc {
    self.descriptionLabel.text = desc;
    [self.descriptionLabel sizeToFit];
}

@end
