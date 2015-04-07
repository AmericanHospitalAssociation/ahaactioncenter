//
//  ActionCenterManager.h
//  ahaactioncenter
//
//  Created by Server on 4/4/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "OAM.h"
#import "VoterVoice.h"
/**
 `ActionCenterManager` is a class that pulls in data from Solstice rest to get contact info
 */
@interface ActionCenterManager : NSObject

typedef void (^CompletionOAM)(OAM *oam, NSError *error);
typedef void (^CompletionVoterVoice)(VoterVoice *voterVoice, NSError *error);
//typedef void (^CompletionContactBlock)(Contact *contact, NSError *error);



///------------------------------------------------
/// @name Getting Contact info
///------------------------------------------------

/**
 Shared instance
 */
+ (id)sharedInstance;


- (void)getOAMUser:(NSString *)email withPassword:(NSString *)password completion:(CompletionOAM)completion;
- (void)verifyUser:(NSString *)email withZip:(NSString *)zip completion:(CompletionVoterVoice)completion;

+ (NSArray *)menuItems;

+ (UIBarButtonItem *)dragButton;

+ (UIBarButtonItem *)refreshButton;

+ (void)openPane;


@end
