//
//  UserStatusTwitterItem.m
//
//  Created by   on 1/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "UserStatusTwitterItem.h"
#import "Entities.h"
#import "User.h"


NSString *const kUserStatusTwitterItemPlace = @"place";
NSString *const kUserStatusTwitterItemCoordinates = @"coordinates";
NSString *const kUserStatusTwitterItemSource = @"source";
NSString *const kUserStatusTwitterItemTruncated = @"truncated";
NSString *const kUserStatusTwitterItemPossiblySensitive = @"possibly_sensitive";
NSString *const kUserStatusTwitterItemEntities = @"entities";
NSString *const kUserStatusTwitterItemInReplyToScreenName = @"in_reply_to_screen_name";
NSString *const kUserStatusTwitterItemRetweetCount = @"retweet_count";
NSString *const kUserStatusTwitterItemFavorited = @"favorited";
NSString *const kUserStatusTwitterItemGeo = @"geo";
NSString *const kUserStatusTwitterItemId = @"id";
NSString *const kUserStatusTwitterItemUser = @"user";
NSString *const kUserStatusTwitterItemInReplyToUserId = @"in_reply_to_user_id";
NSString *const kUserStatusTwitterItemRetweeted = @"retweeted";
NSString *const kUserStatusTwitterItemText = @"text";
NSString *const kUserStatusTwitterItemCreatedAt = @"created_at";
NSString *const kUserStatusTwitterItemInReplyToStatusIdStr = @"in_reply_to_status_id_str";
NSString *const kUserStatusTwitterItemInReplyToUserIdStr = @"in_reply_to_user_id_str";
NSString *const kUserStatusTwitterItemContributors = @"contributors";
NSString *const kUserStatusTwitterItemIdStr = @"id_str";
NSString *const kUserStatusTwitterItemInReplyToStatusId = @"in_reply_to_status_id";


@interface UserStatusTwitterItem ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserStatusTwitterItem

@synthesize place = _place;
@synthesize coordinates = _coordinates;
@synthesize source = _source;
@synthesize truncated = _truncated;
@synthesize possiblySensitive = _possiblySensitive;
@synthesize entities = _entities;
@synthesize inReplyToScreenName = _inReplyToScreenName;
@synthesize retweetCount = _retweetCount;
@synthesize favorited = _favorited;
@synthesize geo = _geo;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize user = _user;
@synthesize inReplyToUserId = _inReplyToUserId;
@synthesize retweeted = _retweeted;
@synthesize text = _text;
@synthesize createdAt = _createdAt;
@synthesize inReplyToStatusIdStr = _inReplyToStatusIdStr;
@synthesize inReplyToUserIdStr = _inReplyToUserIdStr;
@synthesize contributors = _contributors;
@synthesize idStr = _idStr;
@synthesize inReplyToStatusId = _inReplyToStatusId;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.place = [self objectOrNilForKey:kUserStatusTwitterItemPlace fromDictionary:dict];
            self.coordinates = [self objectOrNilForKey:kUserStatusTwitterItemCoordinates fromDictionary:dict];
            self.source = [self objectOrNilForKey:kUserStatusTwitterItemSource fromDictionary:dict];
            self.truncated = [[self objectOrNilForKey:kUserStatusTwitterItemTruncated fromDictionary:dict] boolValue];
            self.possiblySensitive = [[self objectOrNilForKey:kUserStatusTwitterItemPossiblySensitive fromDictionary:dict] boolValue];
            self.entities = [Entities modelObjectWithDictionary:[dict objectForKey:kUserStatusTwitterItemEntities]];
            self.inReplyToScreenName = [self objectOrNilForKey:kUserStatusTwitterItemInReplyToScreenName fromDictionary:dict];
            self.retweetCount = [[self objectOrNilForKey:kUserStatusTwitterItemRetweetCount fromDictionary:dict] doubleValue];
            self.favorited = [[self objectOrNilForKey:kUserStatusTwitterItemFavorited fromDictionary:dict] boolValue];
            self.geo = [self objectOrNilForKey:kUserStatusTwitterItemGeo fromDictionary:dict];
            self.internalBaseClassIdentifier = [[self objectOrNilForKey:kUserStatusTwitterItemId fromDictionary:dict] intValue];
            self.user = [User modelObjectWithDictionary:[dict objectForKey:kUserStatusTwitterItemUser]];
            self.inReplyToUserId = [self objectOrNilForKey:kUserStatusTwitterItemInReplyToUserId fromDictionary:dict];
            self.retweeted = [[self objectOrNilForKey:kUserStatusTwitterItemRetweeted fromDictionary:dict] boolValue];
            self.text = [self objectOrNilForKey:kUserStatusTwitterItemText fromDictionary:dict];
            self.createdAt = [self objectOrNilForKey:kUserStatusTwitterItemCreatedAt fromDictionary:dict];
            self.inReplyToStatusIdStr = [self objectOrNilForKey:kUserStatusTwitterItemInReplyToStatusIdStr fromDictionary:dict];
            self.inReplyToUserIdStr = [self objectOrNilForKey:kUserStatusTwitterItemInReplyToUserIdStr fromDictionary:dict];
            self.contributors = [self objectOrNilForKey:kUserStatusTwitterItemContributors fromDictionary:dict];
            self.idStr = [self objectOrNilForKey:kUserStatusTwitterItemIdStr fromDictionary:dict];
            self.inReplyToStatusId = [self objectOrNilForKey:kUserStatusTwitterItemInReplyToStatusId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.place forKey:kUserStatusTwitterItemPlace];
    [mutableDict setValue:self.coordinates forKey:kUserStatusTwitterItemCoordinates];
    [mutableDict setValue:self.source forKey:kUserStatusTwitterItemSource];
    [mutableDict setValue:[NSNumber numberWithBool:self.truncated] forKey:kUserStatusTwitterItemTruncated];
    [mutableDict setValue:[NSNumber numberWithBool:self.possiblySensitive] forKey:kUserStatusTwitterItemPossiblySensitive];
    [mutableDict setValue:[self.entities dictionaryRepresentation] forKey:kUserStatusTwitterItemEntities];
    [mutableDict setValue:self.inReplyToScreenName forKey:kUserStatusTwitterItemInReplyToScreenName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.retweetCount] forKey:kUserStatusTwitterItemRetweetCount];
    [mutableDict setValue:[NSNumber numberWithBool:self.favorited] forKey:kUserStatusTwitterItemFavorited];
    [mutableDict setValue:self.geo forKey:kUserStatusTwitterItemGeo];
    [mutableDict setValue:[NSNumber numberWithInt:(int)self.internalBaseClassIdentifier] forKey:kUserStatusTwitterItemId];
    [mutableDict setValue:[self.user dictionaryRepresentation] forKey:kUserStatusTwitterItemUser];
    [mutableDict setValue:self.inReplyToUserId forKey:kUserStatusTwitterItemInReplyToUserId];
    [mutableDict setValue:[NSNumber numberWithBool:self.retweeted] forKey:kUserStatusTwitterItemRetweeted];
    [mutableDict setValue:self.text forKey:kUserStatusTwitterItemText];
    [mutableDict setValue:self.createdAt forKey:kUserStatusTwitterItemCreatedAt];
    [mutableDict setValue:self.inReplyToStatusIdStr forKey:kUserStatusTwitterItemInReplyToStatusIdStr];
    [mutableDict setValue:self.inReplyToUserIdStr forKey:kUserStatusTwitterItemInReplyToUserIdStr];
    [mutableDict setValue:self.contributors forKey:kUserStatusTwitterItemContributors];
    [mutableDict setValue:self.idStr forKey:kUserStatusTwitterItemIdStr];
    [mutableDict setValue:self.inReplyToStatusId forKey:kUserStatusTwitterItemInReplyToStatusId];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.place = [aDecoder decodeObjectForKey:kUserStatusTwitterItemPlace];
    self.coordinates = [aDecoder decodeObjectForKey:kUserStatusTwitterItemCoordinates];
    self.source = [aDecoder decodeObjectForKey:kUserStatusTwitterItemSource];
    self.truncated = [aDecoder decodeBoolForKey:kUserStatusTwitterItemTruncated];
    self.possiblySensitive = [aDecoder decodeBoolForKey:kUserStatusTwitterItemPossiblySensitive];
    self.entities = [aDecoder decodeObjectForKey:kUserStatusTwitterItemEntities];
    self.inReplyToScreenName = [aDecoder decodeObjectForKey:kUserStatusTwitterItemInReplyToScreenName];
    self.retweetCount = [aDecoder decodeDoubleForKey:kUserStatusTwitterItemRetweetCount];
    self.favorited = [aDecoder decodeBoolForKey:kUserStatusTwitterItemFavorited];
    self.geo = [aDecoder decodeObjectForKey:kUserStatusTwitterItemGeo];
    self.internalBaseClassIdentifier = [aDecoder decodeIntegerForKey:kUserStatusTwitterItemId];
    self.user = [aDecoder decodeObjectForKey:kUserStatusTwitterItemUser];
    self.inReplyToUserId = [aDecoder decodeObjectForKey:kUserStatusTwitterItemInReplyToUserId];
    self.retweeted = [aDecoder decodeBoolForKey:kUserStatusTwitterItemRetweeted];
    self.text = [aDecoder decodeObjectForKey:kUserStatusTwitterItemText];
    self.createdAt = [aDecoder decodeObjectForKey:kUserStatusTwitterItemCreatedAt];
    self.inReplyToStatusIdStr = [aDecoder decodeObjectForKey:kUserStatusTwitterItemInReplyToStatusIdStr];
    self.inReplyToUserIdStr = [aDecoder decodeObjectForKey:kUserStatusTwitterItemInReplyToUserIdStr];
    self.contributors = [aDecoder decodeObjectForKey:kUserStatusTwitterItemContributors];
    self.idStr = [aDecoder decodeObjectForKey:kUserStatusTwitterItemIdStr];
    self.inReplyToStatusId = [aDecoder decodeObjectForKey:kUserStatusTwitterItemInReplyToStatusId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_place forKey:kUserStatusTwitterItemPlace];
    [aCoder encodeObject:_coordinates forKey:kUserStatusTwitterItemCoordinates];
    [aCoder encodeObject:_source forKey:kUserStatusTwitterItemSource];
    [aCoder encodeBool:_truncated forKey:kUserStatusTwitterItemTruncated];
    [aCoder encodeBool:_possiblySensitive forKey:kUserStatusTwitterItemPossiblySensitive];
    [aCoder encodeObject:_entities forKey:kUserStatusTwitterItemEntities];
    [aCoder encodeObject:_inReplyToScreenName forKey:kUserStatusTwitterItemInReplyToScreenName];
    [aCoder encodeDouble:_retweetCount forKey:kUserStatusTwitterItemRetweetCount];
    [aCoder encodeBool:_favorited forKey:kUserStatusTwitterItemFavorited];
    [aCoder encodeObject:_geo forKey:kUserStatusTwitterItemGeo];
    [aCoder encodeInteger:_internalBaseClassIdentifier forKey:kUserStatusTwitterItemId];
    [aCoder encodeObject:_user forKey:kUserStatusTwitterItemUser];
    [aCoder encodeObject:_inReplyToUserId forKey:kUserStatusTwitterItemInReplyToUserId];
    [aCoder encodeBool:_retweeted forKey:kUserStatusTwitterItemRetweeted];
    [aCoder encodeObject:_text forKey:kUserStatusTwitterItemText];
    [aCoder encodeObject:_createdAt forKey:kUserStatusTwitterItemCreatedAt];
    [aCoder encodeObject:_inReplyToStatusIdStr forKey:kUserStatusTwitterItemInReplyToStatusIdStr];
    [aCoder encodeObject:_inReplyToUserIdStr forKey:kUserStatusTwitterItemInReplyToUserIdStr];
    [aCoder encodeObject:_contributors forKey:kUserStatusTwitterItemContributors];
    [aCoder encodeObject:_idStr forKey:kUserStatusTwitterItemIdStr];
    [aCoder encodeObject:_inReplyToStatusId forKey:kUserStatusTwitterItemInReplyToStatusId];
}


@end
