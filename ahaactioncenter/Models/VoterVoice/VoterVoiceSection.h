//
//  VoterVoiceSection.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"
#import "VoterVoiceProperty.h"

@interface VoterVoiceSection : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *properties;

@end
