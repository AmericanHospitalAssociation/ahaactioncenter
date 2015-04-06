//
//  ActionCenterManager.h
//  ahaactioncenter
//
//  Created by Server on 4/4/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 `ActionCenterManager` is a class that pulls in data from Solstice rest to get contact info
 */
@interface ActionCenterManager : NSObject

typedef void (^CompletionContactsBlock)(NSArray *contacts, NSError *error);
//typedef void (^CompletionContactBlock)(Contact *contact, NSError *error);



///------------------------------------------------
/// @name Getting Contact info
///------------------------------------------------

/**
 Shared instance
 */
+ (id)sharedInstance;

/**
 This methods returns an array of Contacts Objects
 
 @returns NSArray of Contact Objects and NSError if any
 */
- (void)getSolisticeContacts:(CompletionContactsBlock)completion;

/**
 This methods returns details of one Contact
 
 @param url The url needed to pull in contact info
 @returns A Contact Object and NSError if any
 */
//- (void)getSolisticeContactDetail:(NSString *)url withCompletion:(CompletionContactBlock)completion;

+ (NSArray *)menuItems;


@end
