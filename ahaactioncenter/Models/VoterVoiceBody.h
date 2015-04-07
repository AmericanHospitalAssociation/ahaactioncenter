//
//  VoterVoiceBody.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"

@interface VoterVoiceBody : NSObject

@property (nonatomic, retain) NSString *givenNames;
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSNumber *surname;
@property (nonatomic, retain) NSNumber *token;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *suggestedZipCode;

@end
