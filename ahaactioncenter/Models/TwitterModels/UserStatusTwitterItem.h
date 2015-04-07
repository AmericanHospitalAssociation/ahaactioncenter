//
//  UserStatusTwitterItem.h
//
//  Created by   on 1/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Entities, User;

@interface UserStatusTwitterItem : NSObject <NSCoding>

@property (nonatomic, assign) id place;
@property (nonatomic, assign) id coordinates;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign) BOOL truncated;
@property (nonatomic, assign) BOOL possiblySensitive;
@property (nonatomic, strong) Entities *entities;
@property (nonatomic, assign) id inReplyToScreenName;
@property (nonatomic, assign) double retweetCount;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) id geo;
@property (nonatomic, assign) NSInteger internalBaseClassIdentifier;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) id inReplyToUserId;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) id inReplyToStatusIdStr;
@property (nonatomic, assign) id inReplyToUserIdStr;
@property (nonatomic, assign) id contributors;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, assign) id inReplyToStatusId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
