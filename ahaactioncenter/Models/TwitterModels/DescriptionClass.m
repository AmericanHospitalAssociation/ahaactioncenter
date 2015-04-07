//
//  DescriptionClass.m
//
//  Created by   on 1/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "DescriptionClass.h"


NSString *const kDescriptionClassUrls = @"urls";


@interface DescriptionClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation DescriptionClass

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
            self.urls = [self objectOrNilForKey:kDescriptionClassUrls fromDictionary:dict];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForUrls] forKey:kDescriptionClassUrls];

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

    self.urls = [aDecoder decodeObjectForKey:kDescriptionClassUrls];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_urls forKey:kDescriptionClassUrls];
}

- (id)copyWithZone:(NSZone *)zone
{
    DescriptionClass *copy = [[DescriptionClass alloc] init];
    
    if (copy) {

        copy.urls = [self.urls copyWithZone:zone];
    }
    
    return copy;
}


@end
