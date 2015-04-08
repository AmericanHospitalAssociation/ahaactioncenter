//
//  AHACalendar.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "AHACalendar.h"

@implementation AHACalendar

-(id)init {
    self = [super init];
    if (self) {
        [self setValue:@"AHACalendarItem" forKeyPath:@"propertyArrayMap.items"];

    }
    return self;
}

@end
