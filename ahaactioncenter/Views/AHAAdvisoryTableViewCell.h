//
//  AHAAdvisoryTableViewCell.h
//  AHA Advocacy
//
//  Created by Tibble, Patrick on 1/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHAAdvisoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *advisoryTitleLabel;

@property (nonatomic) CGFloat cellHeight;

-(void)setupCellWithTitle:(NSString *)title date:(NSString *)date description:(NSString *)desc;

-(CGFloat) getCellHeight;
@end
