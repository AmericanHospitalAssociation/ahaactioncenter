//
//  VoterVoiceMessage.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"

@interface VoterVoiceMessage : NSObject

@property (nonatomic, retain) NSString *guidelines;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, assign) BOOL readOnly;
@property (nonatomic, retain) NSNumber *sampleMessageId;
@property (nonatomic, retain) NSString *shortenedGuidelines;
@property (nonatomic, retain) NSNumber *showOpeningAndClosing;
@property (nonatomic, retain) NSString *subject;

@end
