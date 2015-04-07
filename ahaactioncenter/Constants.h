//
//  Constants.h
//  ahaactioncenter
//
//  Created by Server on 4/4/15.
//  Copyright (c) 2015 AHA. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PREFS_PROFILE_USER      @"profileUser"      // Dictionary
#define PREFS_USER_EMAIL        @"userEmail"        // string
#define PREFS_PASSWORD          @"password"         // string
#define PREFS_IS_LOGGED_IN      @"isLoggedIn"       // boolean
#define PREFS_USER_TOKEN        @"userToken"        // string
#define PREFS_MESSAGE_INFO      @"messageInfo"      // string
#define PREFS_USER_ID           @"userID"           // int?
#define PREFS_LAST_UPDATE       @"lastUpdate"       // string
#define PREFS_HAS_LOADED        @"hasLoaded"        // boolean
#define PREFS_ADDRESS_VERIFIED  @"addressVerified"  // boolean
#define PREFS_USER_VERIFIED     @"userVerified"     // boolean
#define PREFS_USER_ADDRESS      @"userAddress"      // Dictionary

#define PREFS_USER_PHONE        @"userPhone"        // string
#define PREFS_USER_PREFIX       @"userPrefix"       // string

#define kParseAppId             @"eCgr0cenQyGE8gAGe2i3HSR4TA9l3DwkBZWkJ5NI"
#define kParseClientKey         @"SWJUl9v413kjadIrowI8GucGsBhEuqLYGxUMPeDM"

#define kAHABlue                [UIColor colorWithRed:13.0f/255.0f green:71.0f/255.0f blue:161.0f/255.0f alpha:1.0f]
#define kAHARed                 [UIColor colorWithRed:157.0f/255.0f green:34.0f/255.0f blue:53.0f/255.0f alpha:1.0f]

@interface Constants : NSObject

@end
