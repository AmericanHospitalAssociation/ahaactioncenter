//
//  AHANavigationItem.m
//  ahaactioncenter
//
//  Created by Vince Davis on 4/6/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import "AHANavigationItem.h"
#import "FontAwesomeKit.h"

@implementation AHANavigationItem

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static AHANavigationItem *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[AHANavigationItem alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self) {
        FAKIonIcons *drag = [FAKIonIcons iconWithCode:@"\uf130" size:30];
        [drag addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        FAKIonIcons *refresh = [FAKIonIcons iconWithCode:@"\uf49a" size:30];
        [refresh addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[drag imageWithSize:CGSizeMake(30, 30)]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:nil
                                                                 action:nil];
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[refresh imageWithSize:CGSizeMake(30, 30)]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
        
    }
    return self;
}

@end
