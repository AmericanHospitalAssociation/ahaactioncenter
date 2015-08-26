//
//  FeedbackViewController.h
//  applepayfinder
//
//  Created by Vince Davis on 11/20/14.
//  Copyright (c) 2014 Vince Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"
#import "UserForm.h"

@interface UpdateUserViewController : UITableViewController <FXFormControllerDelegate>

@property(nonatomic, strong)FXFormController *formController;
@property(nonatomic, retain)NSArray *excludeList;
@property(nonatomic, assign)BOOL showCancel, validateAddress;

@end
