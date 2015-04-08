//
//  WebViewController.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kWebTypeCongressCalendar,
    kWebTypeWorkingWithCongress,
    kWebTypeFactSheet
} kWebType;

@interface WebViewController : UIViewController

@property(nonatomic, assign)kWebType webType;
@property(nonatomic, retain)NSDictionary *dict;
@property(nonatomic, retain)NSString *link;

@end
