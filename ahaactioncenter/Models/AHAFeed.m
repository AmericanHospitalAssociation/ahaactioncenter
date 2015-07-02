//
//  AHAFeed.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "AHAFeed.h"

@implementation AHAFeed

-(id)init {
    self = [super init];
    if (self) {
        [self setValue:@"AHAFeedItem" forKeyPath:@"propertyArrayMap.FEED_PAYLOAD"];
        
    }
    return self;
}

@end
