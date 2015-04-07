//
//  Entities.m
//
//  Created by   on 1/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Entities.h"
#import "DescriptionClass.h"
#import "Urls.h"
#import "Url.h"


NSString *const kEntitiesDescription = @"description";
NSString *const kEntitiesUserMentions = @"user_mentions";
NSString *const kEntitiesUrls = @"urls";
NSString *const kEntitiesUrl = @"url";
NSString *const kEntitiesHashtags = @"hashtags";


@interface Entities ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Entities

@synthesize entitiesDescription = _entitiesDescription;
@synthesize userMentions = _userMentions;
@synthesize urls = _urls;
@synthesize url = _url;
@synthesize hashtags = _hashtags;


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
            self.entitiesDescription = [DescriptionClass modelObjectWithDictionary:[dict objectForKey:kEntitiesDescription]];
            self.userMentions = [self objectOrNilForKey:kEntitiesUserMentions fromDictionary:dict];
    NSObject *receivedUrls = [dict objectForKey:kEntitiesUrls];
    NSMutableArray *parsedUrls = [NSMutableArray array];
    if ([receivedUrls isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedUrls) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedUrls addObject:[Urls modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedUrls isKindOfClass:[NSDictionary class]]) {
       [parsedUrls addObject:[Urls modelObjectWithDictionary:(NSDictionary *)receivedUrls]];
    }

    self.urls = [NSArray arrayWithArray:parsedUrls];
            self.url = [Url modelObjectWithDictionary:[dict objectForKey:kEntitiesUrl]];
            self.hashtags = [self objectOrNilForKey:kEntitiesHashtags fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.entitiesDescription dictionaryRepresentation] forKey:kEntitiesDescription];
    NSMutableArray *tempArrayForUserMentions = [NSMutableArray array];
    for (NSObject *subArrayObject in self.userMentions) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForUserMentions addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForUserMentions addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForUserMentions] forKey:kEntitiesUserMentions];
    NSMutableArray *tempArrayForUrls = [NSMutableArray array];
    for (NSObject *subArrayObject in self.urls) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForUrls addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForUrls addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForUrls] forKey:kEntitiesUrls];
    [mutableDict setValue:[self.url dictionaryRepresentation] forKey:kEntitiesUrl];
    NSMutableArray *tempArrayForHashtags = [NSMutableArray array];
    for (NSObject *subArrayObject in self.hashtags) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForHashtags addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForHashtags addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForHashtags] forKey:kEntitiesHashtags];

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

    self.entitiesDescription = [aDecoder decodeObjectForKey:kEntitiesDescription];
    self.userMentions = [aDecoder decodeObjectForKey:kEntitiesUserMentions];
    self.urls = [aDecoder decodeObjectForKey:kEntitiesUrls];
    self.url = [aDecoder decodeObjectForKey:kEntitiesUrl];
    self.hashtags = [aDecoder decodeObjectForKey:kEntitiesHashtags];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_entitiesDescription forKey:kEntitiesDescription];
    [aCoder encodeObject:_userMentions forKey:kEntitiesUserMentions];
    [aCoder encodeObject:_urls forKey:kEntitiesUrls];
    [aCoder encodeObject:_url forKey:kEntitiesUrl];
    [aCoder encodeObject:_hashtags forKey:kEntitiesHashtags];
}

- (id)copyWithZone:(NSZone *)zone
{
    Entities *copy = [[Entities alloc] init];
    
    if (copy) {

        copy.entitiesDescription = [self.entitiesDescription copyWithZone:zone];
        copy.userMentions = [self.userMentions copyWithZone:zone];
        copy.urls = [self.urls copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.hashtags = [self.hashtags copyWithZone:zone];
    }
    
    return copy;
}


@end
