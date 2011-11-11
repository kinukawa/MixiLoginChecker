//
//  MGParams.h
//  libMixiGraph
//
//  Created by kenji.kinukawa on 11/03/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Consumer key & secret
#define CONSUMER_KEY        @""
#define CONSUMER_SECRET     @""

//OAuth constant definition
#define OAUTH_REQUEST_URL   @"https://secure.mixi-platform.com/2/token"
#define OAUTH_SCOPES        @"r_profile",@"r_profile_status",@"r_profile_last_login"
#define OAUTH_DISPLAY_TYPE  @"touch"
#define OAUTH_REFRESH_TOKEN @"refresh_token"
#define OAUTH_ACCESS_TOKEN  @"access_token"
#define OAUTH_EXPIRES_IN    @"expires_in"
#define OAUTH_REDIRECT_URL  @"http://mixi.jp/"

//API URL
#define API_BASE_URL        http://api.mixi-platform.com/
#define VOICE_BASE_URL      @"http://api.mixi-platform.com/2/voice/statuses/"

@interface MGParams : NSObject {
    
}

@end
