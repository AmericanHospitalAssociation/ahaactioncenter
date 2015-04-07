//
//  Entities.h
//
//  Created by   on 1/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DescriptionClass, Url;

@interface Entities : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) DescriptionClass *entitiesDescription;
@property (nonatomic, strong) NSArray *userMentions;
@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) Url *url;
@property (nonatomic, strong) NSArray *hashtags;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
