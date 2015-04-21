//
//  ActionCenterManager.h
//  ahaactioncenter
//
//  Created by Server on 4/4/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "OAM.h"
#import "VoterVoice.h"
#import "AHACalendar.h"
#import "AHAFeed.h"

/**
 `ActionCenterManager` is a class that pulls in data from Solstice rest to get contact info
 */
@interface ActionCenterManager : NSObject

typedef void (^CompletionAHANews)(NSArray *news, NSError *error);
typedef void (^CompletionAHALink)(NSString *link, NSError *error);
typedef void (^CompletionAHAFeed)(NSArray *feeds, NSArray *alerts, NSError *error);
typedef void (^CompletionAHACalendar)(AHACalendar *calendar, NSError *error);
typedef void (^CompletionOAM)(OAM *oam, NSError *error);
typedef void (^CompletionVoterVoice)(VoterVoice *voterVoice, NSError *error);
typedef void (^CompletionVoterVoiceBody)(NSDictionary *dict, NSError *error);
typedef void (^CompletionVoterVoiceNew)(NSString *userId, NSString *token, NSError *error);
//typedef void (^CompletionContactBlock)(Contact *contact, NSError *error);

@property(nonatomic, retain)NSArray *feeds, *alerts;

///------------------------------------------------
/// @name Getting Contact info
///------------------------------------------------

/**
 Shared instance
 */
+ (id)sharedInstance;

- (void)getAHAFeed:(CompletionAHAFeed)completion;
- (void)getAHACalendar:(CompletionAHACalendar)completion;
- (void)getAHANews:(CompletionAHANews)completion;
- (void)getAHAArticle:(NSString *)link completion:(CompletionAHALink)completion;
- (void)getOAMUser:(NSString *)email withPassword:(NSString *)password completion:(CompletionOAM)completion;

- (void)verifyUser:(NSString *)email withZip:(NSString *)zip completion:(CompletionVoterVoice)completion;
- (void)verifyAddress:(NSString *)address withZip:(NSString *)zip  andCountry:(NSString *)country completion:(CompletionVoterVoice)completion;
- (void)createUser:(OAM *)oam withEmail:(NSString *)email completion:(CompletionVoterVoiceNew)completion;
- (void)sendEmailVerification:(NSString *)email completion:(CompletionVoterVoice)completion;
- (void)getMatchesForCampaign:(NSString*)campaignId withToken:(NSString *)token completion:(CompletionVoterVoice)completion;
- (void)verifyEmailID:(OAM *)oam withID:(NSString *)verificationID andCode:(NSString *)code completion:(CompletionVoterVoice)completion;
- (void)getCampaignSummaries:(CompletionVoterVoice)completion;
- (void)postVoterUrl:(NSString *)strUrl completion:(CompletionVoterVoice)completion;
- (void)getTargetedMessages:(NSString *)campaignID completion:(CompletionVoterVoice)completion;
- (void)getProfile:(NSString *)profileID withType:(NSString *)type completion:(CompletionVoterVoiceBody)completion;

+ (NSArray *)menuItems;

+ (UIBarButtonItem *)dragButton;
+ (UIBarButtonItem *)splitButton;

+ (NSString *)formatDate:(NSString *)date;

- (void)showAlert:(NSString *)alert withMessage:(NSString *)msg;

//+ (void)resetViews;

+ (UIBarButtonItem *)refreshButton;

+ (void)openPane;

- (BOOL)isReachable;

- (NSString *)encodeURL:(NSString *)url;
- (NSString *)cleanPhone:(NSString *)str;
- (NSString *)isNull:(NSString *)str;

@end
