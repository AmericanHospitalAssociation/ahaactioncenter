//
//  SpeechForm.h
//  voicestock
//
//  Created by Vince Davis on 7/13/14.
//  Copyright (c) 2014 45 Bit Code Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface UserForm : NSObject <FXForm>

@property (nonatomic, retain) NSArray *excludedList;
@property (nonatomic, assign) BOOL showPhone;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;

@end
