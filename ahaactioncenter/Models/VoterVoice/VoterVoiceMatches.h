//
//  VoterVoiceMatches.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"

@interface VoterVoiceMatches : NSObject

@property (nonatomic, retain) NSString *country;
@property (nonatomic, assign) BOOL canSend;
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;

@end
