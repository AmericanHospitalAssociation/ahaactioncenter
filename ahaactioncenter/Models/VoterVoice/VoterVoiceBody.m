//
//  VoterVoiceBody.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "VoterVoiceBody.h"

@implementation VoterVoiceBody

-(id)init {
    self = [super init];
    if (self) {
        [self setValue:@"VoterVoiceAddress" forKeyPath:@"propertyArrayMap.addresses"];
        [self setValue:@"VoterVoiceMatches" forKeyPath:@"propertyArrayMap.matches"];
        [self setValue:@"VoterVoiceMessage" forKeyPath:@"propertyArrayMap.messages"];
        [self setValue:@"VoterVoiceSelectedAnswers" forKeyPath:@"propertyArrayMap.preSelectedAnswers"];
        [self setValue:@"VoterVoiceTargets" forKeyPath:@"propertyArrayMap.targets"];
        [self setValue:@"VoterVoiceSection" forKeyPath:@"propertyArrayMap.sections"];
    }
    return self;
}

@end
