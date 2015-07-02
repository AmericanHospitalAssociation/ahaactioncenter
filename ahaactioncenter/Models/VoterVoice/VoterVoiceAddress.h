//
//  VoterVoiceAddress.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"

@interface VoterVoiceAddress : NSObject

@property (nonatomic, retain) NSString *checksum;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *county;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *streetAddress;
@property (nonatomic, retain) NSString *zipCode;
@property (nonatomic, retain) NSString *zipCodeExtension;

@end
