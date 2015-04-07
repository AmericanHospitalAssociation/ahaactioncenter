//
//  User.h
//
//  Created by   on 1/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Entities;

@interface User : NSObject <NSCoding>

@property (nonatomic, assign) BOOL protectedProperty;
@property (nonatomic, assign) BOOL isTranslator;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, assign) double userIdentifier;
@property (nonatomic, assign) BOOL defaultProfileImage;
@property (nonatomic, assign) double listedCount;
@property (nonatomic, strong) NSString *profileBackgroundColor;
@property (nonatomic, assign) BOOL followRequestSent;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) Entities *entities;
@property (nonatomic, assign) BOOL geoEnabled;
@property (nonatomic, assign) double followersCount;
@property (nonatomic, strong) NSString *profileTextColor;
@property (nonatomic, assign) BOOL showAllInlineMedia;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, assign) double statusesCount;
@property (nonatomic, assign) id notifications;
@property (nonatomic, assign) id following;
@property (nonatomic, assign) BOOL profileBackgroundTile;
@property (nonatomic, assign) BOOL profileUseBackgroundImage;
@property (nonatomic, strong) NSString *profileSidebarFillColor;
@property (nonatomic, strong) NSString *profileImageUrlHttps;
@property (nonatomic, assign) BOOL defaultProfile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileSidebarBorderColor;
@property (nonatomic, assign) BOOL contributorsEnabled;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSString *profileBackgroundImageUrl;
@property (nonatomic, strong) NSString *profileBackgroundImageUrlHttps;
@property (nonatomic, strong) NSString *profileLinkColor;
@property (nonatomic, assign) double favouritesCount;
@property (nonatomic, assign) double utcOffset;
@property (nonatomic, assign) double friendsCount;
@property (nonatomic, assign) BOOL verified;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
