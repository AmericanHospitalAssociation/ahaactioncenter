//
//  VoterVoiceResponse.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "VoterVoiceResponse.h"

@implementation VoterVoiceResponse

-(id)init {
    self = [super init];
    if (self) {
        [self setValue:@"VoterVoiceBody" forKeyPath:@"propertyArrayMap.body"];
    }
    return self;
}

@end
