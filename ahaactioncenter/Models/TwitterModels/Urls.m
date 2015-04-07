//
//  Urls.m
//
//  Created by   on 1/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Urls.h"


NSString *const kUrlsDisplayUrl = @"display_url";
NSString *const kUrlsUrl = @"url";
NSString *const kUrlsIndices = @"indices";
NSString *const kUrlsExpandedUrl = @"expanded_url";


@interface Urls ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Urls

@synthesize displayUrl = _displayUrl;
@synthesize url = _url;
@synthesize indices = _indices;
@synthesize expandedUrl = _expandedUrl;


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
            self.displayUrl = [self objectOrNilForKey:kUrlsDisplayUrl fromDictionary:dict];
            self.url = [self objectOrNilForKey:kUrlsUrl fromDictionary:dict];
            self.indices = [self objectOrNilForKey:kUrlsIndices fromDictionary:dict];
            self.expandedUrl = [self objectOrNilForKey:kUrlsExpandedUrl fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.displayUrl forKey:kUrlsDisplayUrl];
    [mutableDict setValue:self.url forKey:kUrlsUrl];
    NSMutableArray *tempArrayForIndices = [NSMutableArray array];
    for (NSObject *subArrayObject in self.indices) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForIndices addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForIndices addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForIndices] forKey:kUrlsIndices];
    [mutableDict setValue:self.expandedUrl forKey:kUrlsExpandedUrl];

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

    self.displayUrl = [aDecoder decodeObjectForKey:kUrlsDisplayUrl];
    self.url = [aDecoder decodeObjectForKey:kUrlsUrl];
    self.indices = [aDecoder decodeObjectForKey:kUrlsIndices];
    self.expandedUrl = [aDecoder decodeObjectForKey:kUrlsExpandedUrl];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_displayUrl forKey:kUrlsDisplayUrl];
    [aCoder encodeObject:_url forKey:kUrlsUrl];
    [aCoder encodeObject:_indices forKey:kUrlsIndices];
    [aCoder encodeObject:_expandedUrl forKey:kUrlsExpandedUrl];
}

- (id)copyWithZone:(NSZone *)zone
{
    Urls *copy = [[Urls alloc] init];
    
    if (copy) {

        copy.displayUrl = [self.displayUrl copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.indices = [self.indices copyWithZone:zone];
        copy.expandedUrl = [self.expandedUrl copyWithZone:zone];
    }
    
    return copy;
}


@end
