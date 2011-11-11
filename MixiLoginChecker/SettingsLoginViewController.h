//
//  SettingsLoginViewController.h
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGOAuthClient.h"

@interface SettingsLoginViewController : UIViewController {
	MGOAuthClient * oauthClient;
}

@end
