//
//  AHAAdvisoryTableViewCell.m
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 1/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "AHAAdvisoryTableViewCell.h"

@interface AHAAdvisoryTableViewCell() {
    
}

@property (weak, nonatomic) IBOutlet UILabel *advisoryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *advisoryDescriptionLabel;

@end


@implementation AHAAdvisoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDescriptionLabel:(NSString *)desc {
    self.advisoryDescriptionLabel.text = desc;
    self.advisoryDescriptionLabel.numberOfLines = 0;
    [self.advisoryDescriptionLabel sizeToFit];
}

-(void)setTitleText:(NSString *)title
{
    self.advisoryTitleLabel.text = title;
    self.advisoryTitleLabel.numberOfLines = 0;
    [self.advisoryTitleLabel sizeToFit];
}
-(void)setDateText:(NSString *)date
{
    self.advisoryDateLabel.text = date;
    self.advisoryDateLabel.numberOfLines = 0;
    [self.advisoryDateLabel sizeToFit];
}

-(void)setupCellWithTitle:(NSString *)title date:(NSString *)date description:(NSString *)desc
{
    [self setTitleText:title];
    [self setDateText:date];
    [self setDescriptionLabel:desc];
    [self getCellHeight];
}

-(CGFloat) getCellHeight {
    self.cellHeight = self.advisoryTitleLabel.frame.size.height + self.advisoryTitleLabel.frame.origin.y;
    self.cellHeight += self.advisoryDateLabel.frame.size.height + self.advisoryDateLabel.frame.origin.y;
    self.cellHeight += self.advisoryDescriptionLabel.frame.size.height + self.advisoryDescriptionLabel.frame.origin.y;
    
    return self.cellHeight;
}

@end
