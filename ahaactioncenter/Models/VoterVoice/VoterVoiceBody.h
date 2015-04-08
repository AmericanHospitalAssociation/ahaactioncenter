//
//  VoterVoiceBody.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"
#import "VoterVoiceAddress.h"
#import "VoterVoiceMatches.h"
#import "VoterVoiceMessage.h"
#import "VoterVoiceSelectedAnswers.h"
#import "VoterVoiceTargets.h"
#import "VoterVoiceSection.h"

@interface VoterVoiceBody : NSObject

@property (nonatomic, retain) NSString *givenNames;
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSNumber *surname;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSNumber *userId;
@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *suggestedZipCode;
@property (nonatomic, retain) NSArray *addresses;
@property (nonatomic, retain) NSString *groupId;
@property (nonatomic, retain) NSNumber *messageId;
@property (nonatomic, retain) NSArray *matches;

@property (nonatomic, retain) NSString *alert;
@property (nonatomic, retain) NSString *headline;
@property (nonatomic, assign) BOOL isPrivate;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *priority;
@property (nonatomic, assign) BOOL targetsFederal;
@property (nonatomic, assign) BOOL targetsState;

@property (nonatomic, retain) NSString *messageDisplay;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSString *photoUrl;
@property (nonatomic, retain) NSString *phoneCallMethod;
@property (nonatomic, retain) NSArray *preSelectedAnswers;
@property (nonatomic, retain) NSArray *targets;
@property (nonatomic, retain) NSArray *messages;
@property (nonatomic, retain) NSArray *sections;

@end
