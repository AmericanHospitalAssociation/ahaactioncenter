//
//  Url.m
//
//  Created by   on 1/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "Url.h"
#import "Urls.h"


NSString *const kUrlUrls = @"urls";


@interface Url ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Url

@synthesize urls = _urls;


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
    NSObject *receivedUrls = [dict objectForKey:kUrlUrls];
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

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForUrls] forKey:kUrlUrls];

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

    self.urls = [aDecoder decodeObjectForKey:kUrlUrls];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_urls forKey:kUrlUrls];
}

- (id)copyWithZone:(NSZone *)zone
{
    Url *copy = [[Url alloc] init];
    
    if (copy) {

        copy.urls = [self.urls copyWithZone:zone];
    }
    
    return copy;
}


@end
