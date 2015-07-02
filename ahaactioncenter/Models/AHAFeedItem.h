//
//  AHAFeedItem.h
//  ahaactioncenter
//
//  Created by Vince Davis on 4/7/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AHAFeedItem : NSObject

@property (nonatomic, retain) NSString *ALT_LongDescription;
@property (nonatomic, retain) NSString *AccessLevel;
@property (nonatomic, retain) NSString *ContentType;
@property (nonatomic, retain) NSString *Date;
@property (nonatomic, retain) NSString *Description;
@property (nonatomic, retain) NSNumber *EndTime;
@property (nonatomic, retain) NSString *ResourceURI;
@property (nonatomic, retain) NSString *Title;
@property (nonatomic, retain) NSString *Long_Description;
@property (nonatomic, retain) NSString *When_c;
@property (nonatomic, retain) NSString *Why;
@property (nonatomic, retain) NSString *ActionFrom;
@property (nonatomic, retain) NSString *ActionNeeded;

@end
