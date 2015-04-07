//
//  OAM.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ObjectMap.h"

@interface OAM : NSObject

@property (nonatomic, retain) NSString *address_line;
@property (nonatomic, retain) NSString *ahaid;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *first_name;
@property (nonatomic, retain) NSString *last_name;
@property (nonatomic, retain) NSString *org_name;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *prefix;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *zip;

/* Example JSON
 
{
    "address_line": "1714 Sunshine Ln",
    "ahaid": "8022603524",
    "city": "Zion",
    "first_name": "Vince",
    "last_name": "Davis",
    "oam_groups": [
        "SHSMD",
        "AHA"
    ],
    "org_name": null,
    "phone": "(847) 212 - 8597",
    "prefix": "Dr.",
    "state": "IL",
    "status": "found user",
    "zip": "60099"
 }
 
*/

@end
