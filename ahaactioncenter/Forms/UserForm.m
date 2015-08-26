//
//  SpeechForm.m
//  voicestock
//
//  Created by Vince Davis on 7/13/14.
//  Copyright (c) 2014 45 Bit Code Inc. All rights reserved.
//

#import "UserForm.h"
#import "ActionCenterManager.h"

@implementation UserForm

- (NSDictionary *)prefixField {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    return @{FXFormFieldKey: @"prefix",
             /* FXFormFieldHeader: @"Contact Info", */
             FXFormFieldTitle: NSLocalizedString(@"Prefix", nil),
             FXFormFieldOptions: @[NSLocalizedString(@"Mr.", nil),
                                   NSLocalizedString(@"Dr.", nil),
                                    NSLocalizedString(@"Ms.", nil),
                                    NSLocalizedString(@"Mrs.", nil)],
             //@"value" : value,
             //FXFormFieldInline: @YES,
             //FXFormFieldPlaceholder : NSLocalizedString(@"Select Category", nil),
             FXFormFieldDefaultValue : ([prefs objectForKey:@"prefix"] == nil) ? /* oam.prefix*/ @"" : [prefs objectForKey:@"prefix"],
             FXFormFieldDefaultValue : NSLocalizedString(@"Mr.", nil), };
}

- (NSDictionary *)firstNameField {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    return @{FXFormFieldKey: @"firstName",
             FXFormFieldTitle: NSLocalizedString(@"First Name", nil),
             FXFormFieldType : FXFormFieldTypeText,
             FXFormFieldDefaultValue : ([prefs objectForKey:@"firstName"] == nil) ? /*oam.first_name*/ @"" : [prefs objectForKey:@"firstName"],
             FXFormFieldCell: [FXFormTextFieldCell class],};
}

- (NSDictionary *)lastNameField {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    return @{FXFormFieldKey: @"lastName",
             FXFormFieldTitle: NSLocalizedString(@"Last Name", nil),
             FXFormFieldType : FXFormFieldTypeText,
             FXFormFieldDefaultValue : ([prefs objectForKey:@"lastName"] == nil) ? /*oam.last_name*/ @"" : [prefs objectForKey:@"lastName"],
             FXFormFieldCell: [FXFormTextFieldCell class],};
}

- (NSDictionary *)phoneField {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    return @{FXFormFieldKey: @"phone",
             FXFormFieldTitle: NSLocalizedString(@"Phone", nil),
             FXFormFieldType : FXFormFieldTypePhone,
             FXFormFieldDefaultValue : ([prefs objectForKey:@"phone"] == nil) ? /*oam.phone*/ @"" : [prefs objectForKey:@"phone"],
             FXFormFieldCell: [FXFormTextFieldCell class],
             };
}

- (NSDictionary *)addressField {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    return @{FXFormFieldKey: @"address",
             FXFormFieldHeader: @"Address",
             FXFormFieldTitle: NSLocalizedString(@"Address", nil),
             FXFormFieldType : FXFormFieldTypeText,
             FXFormFieldDefaultValue : ([prefs objectForKey:@"address"] == nil) ? /*oam.address_line*/ @"" : [prefs objectForKey:@"address"],
             FXFormFieldCell: [FXFormTextFieldCell class],};
}

- (NSDictionary *)cityField {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    return @{FXFormFieldKey: @"city",
             FXFormFieldTitle: NSLocalizedString(@"City", nil),
             FXFormFieldType : FXFormFieldTypeText,
             FXFormFieldDefaultValue : ([prefs objectForKey:@"city"] == nil) ? /*oam.city*/ @"" : [prefs objectForKey:@"city"],
             FXFormFieldCell: [FXFormTextFieldCell class],};
}

- (NSDictionary *)stateField {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    return @{FXFormFieldKey: @"state",
             FXFormFieldTitle: NSLocalizedString(@"State", nil),
             FXFormFieldType : FXFormFieldTypeText,
             FXFormFieldDefaultValue : ([prefs objectForKey:@"state"] == nil) ? /*oam.state*/ @"" : [prefs objectForKey:@"state"],
             FXFormFieldCell: [FXFormTextFieldCell class],};
}

- (NSDictionary *)zipField {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    OAM *oam = [[OAM alloc] initWithJSONData:[prefs dataForKey:@"user"]];
    return @{FXFormFieldKey: @"zip",
             FXFormFieldTitle: NSLocalizedString(@"Postal", nil),
             FXFormFieldType : FXFormFieldTypeNumber,
             FXFormFieldDefaultValue : ([prefs objectForKey:@"zip"] == nil) ? /*oam.zip*/ @"" : [prefs objectForKey:@"zip"],
             FXFormFieldCell: [FXFormTextFieldCell class],
             FXFormFieldFooter: @"This form is used to gather info that is required to get your legislators and to take action on a campaign.",};
}
/*
- (NSArray *)extraFields
{
    return @[
             @{
                 }
             ];
}
*/
- (NSArray *)excludedFields
{
    return _excludedList;
}

@end
