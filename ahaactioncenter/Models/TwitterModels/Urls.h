//
//  Urls.h
//
//  Created by   on 1/8/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Urls : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *displayUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *indices;
@property (nonatomic, strong) NSString *expandedUrl;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
