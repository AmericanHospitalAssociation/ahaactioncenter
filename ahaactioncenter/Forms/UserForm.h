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

@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *phone;

@end
