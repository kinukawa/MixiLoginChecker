//
//  MGOAuthClient.h
//  MVCTest
//
//  Created by kenji kinukawa on 11/02/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSON.h"
#import "MGUserDefaults.h"
#import "MGParams.h"

@protocol MGOAuthClientDelegate;

@interface MGOAuthClient : NSObject <UIWebViewDelegate>{
@public	
	id <MGOAuthClientDelegate> delegate;
@private
	UIWebView * authorizationWebView;
}

@property (nonatomic,assign) id delegate;

-(void)showAuthorizationWebView:(UIView *)parentView;
-(BOOL)refreshOAuthToken;
+(void)deleteOAuthToken;
@end

@protocol MGOAuthClientDelegate<NSObject>
-(void)mgOAuthClientError;
-(void)mgOAuthClientDidGet;
@end
