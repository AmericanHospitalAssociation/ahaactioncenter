//
//  RootForm.h
//  voicestock
//
//  Created by Vince Davis on 7/13/14.
//  Copyright (c) 2014 45 Bit Code Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "UserForm.h"


@interface RootForm : NSObject <FXForm>

@property (nonatomic, strong) UserForm *user;

@end
