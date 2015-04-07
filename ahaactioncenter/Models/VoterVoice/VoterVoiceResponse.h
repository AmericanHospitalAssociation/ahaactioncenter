//
//  VoterVoiceResponse.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"
#import "VoterVoiceBody.h"

@interface VoterVoiceResponse : NSObject

@property (nonatomic, retain) NSArray *body;
@property (nonatomic, retain) NSNumber *status;

@end
