//
//  SpeechForm.m
//  voicestock
//
//  Created by Vince Davis on 7/13/14.
//  Copyright (c) 2014 45 Bit Code Inc. All rights reserved.
//

#import "UserForm.h"

@implementation UserForm

- (NSDictionary *)prefixField {
    return @{FXFormFieldKey: @"prefix",
             FXFormFieldTitle: NSLocalizedString(@"Prefix", nil),
             FXFormFieldOptions: @[NSLocalizedString(@"Mr.", nil),
                                   NSLocalizedString(@"Dr.", nil),
                                    NSLocalizedString(@"Ms.", nil),
                                    NSLocalizedString(@"Mrs.", nil)],
             //@"value" : value,
             //FXFormFieldInline: @YES,
             //FXFormFieldPlaceholder : NSLocalizedString(@"Select Category", nil),
             FXFormFieldDefaultValue : NSLocalizedString(@"Mr.", nil), };
}

- (NSDictionary *)phoneField {
    return @{FXFormFieldKey: @"phone",
             FXFormFieldTitle: NSLocalizedString(@"Phone", nil),
             FXFormFieldType : FXFormFieldTypePhone,
             FXFormFieldCell: [FXFormTextFieldCell class],
             FXFormFieldFooter: @"This form is used to gather info that is required to get your legislators and to take action on a campaign."};
}

@end
