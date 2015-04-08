//
//  CampaignDetailView.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SendButtonTapped)();

@interface CampaignDetailView : UIView

- (void)setHeader:(NSString *)header;
- (void)loadHTMLString:(NSString *)string;
- (void)setButtonTitle:(NSString *)string;

@property(nonatomic, copy)SendButtonTapped sendButtonTapped;

@end
