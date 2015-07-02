//
//  VoterVoiceSelectedAnswers.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"

@interface VoterVoiceSelectedAnswers : NSObject

@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *questionId;

@end
