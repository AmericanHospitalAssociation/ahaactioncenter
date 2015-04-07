//
//  VoterVoice.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"
#import "VoterVoiceResponse.h"

@interface VoterVoice : NSObject

@property (nonatomic, retain) NSNumber *lastUpdate;
@property (nonatomic, retain) VoterVoiceResponse *response;

/* Response for Verify User
 {
    "lastUpdate": 142838004584.89,
    "response": {
        "body": [
            {
                "givenNames": "Vince",
                "id": 3738231,
                "surname": "Davis",
                "token": "GdiZwwmjHu-HDZ0dn9qUUQ"
            }
        ],
        "status": 200
    }
 }
 */

@end
