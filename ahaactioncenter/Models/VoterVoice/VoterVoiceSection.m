//
//  VoterVoiceSection.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "VoterVoiceSection.h"

@implementation VoterVoiceSection

-(id)init {
    self = [super init];
    if (self) {
        [self setValue:@"VoterVoiceProperty" forKeyPath:@"propertyArrayMap.properties"];
    }
    return self;
}

@end
