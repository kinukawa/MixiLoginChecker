//
//  MGOAuthClient.m
//  MVCTest
//
//  Created by kenji kinukawa on 11/02/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGOAuthClient.h"



@implementation MGOAuthClient
@synthesize delegate;

-(id)init{
	if((self = [super init])){
		//initialize
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}


-(NSURL *)buildAuthorizeURL:(NSArray *)scopeArr
				displayType:(NSString *)display{
	NSString * scope = @"";
	if (scopeArr) {
		if ([scopeArr count]>=1) {
			scope = [scope stringByAppendingString:@"&scope="];
			scope = [scope stringByAppendingString:[scopeArr objectAtIndex:0]];
			for (int i = 1; i < [scopeArr count];i++){
				scope = [scope stringByAppendingString:@"%20"];
				scope = [scope stringByAppendingString:[scopeArr objectAtIndex:i]];
			}
		}
	}
	NSString * displayType = @"";
	if (display) {
		displayType = [displayType stringByAppendingString:display];
	}
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://mixi.jp/connect_authorize.pl?client_id=%@&response_type=code%@&display=%@",CONSUMER_KEY,scope,displayType]];
	return url;
}

//AuthorizationCode取得のためのWebViewを表示
-(void)showAuthorizationWebView:(UIView *)parentView{
	authorizationWebView = [[UIWebView alloc] init];
	authorizationWebView.delegate = self;
	//authorizationWebView.frame = CGRectMake(0, 0, 320, 400);
	authorizationWebView.frame = parentView.frame;
	authorizationWebView.scalesPageToFit = YES;
	[parentView addSubview:authorizationWebView];
	
	//NSURL * url = [self buildAuthorizeURL:[NSArray arrayWithObjects:@"r_photo",@"w_photo",@"r_voice",@"w_voice",@"w_diary",@"r_profile",@"r_profile_status",nil] displayType:@"touch"];
	NSURL * url = [self buildAuthorizeURL:[NSArray arrayWithObjects:OAUTH_SCOPES,nil] displayType:OAUTH_DISPLAY_TYPE];
	
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
	[authorizationWebView loadRequest:req];	
	
	//WebViewの表示
	[UIView beginAnimations:nil context:NULL];
	authorizationWebView.alpha = 1.0;
	[UIView commitAnimations];
}


-(BOOL)requestOAuthToken:(NSString *)param{
	NSURL* oauthUrl = [NSURL URLWithString:OAUTH_REQUEST_URL];
	NSMutableURLRequest* oauthRequest = [[[NSMutableURLRequest alloc] initWithURL:oauthUrl] autorelease];
	[oauthRequest setHTTPMethod:@"POST"];
	[oauthRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
	[oauthRequest setHTTPBody:[param dataUsingEncoding:NSASCIIStringEncoding]];
	[oauthRequest setTimeoutInterval:10];
	NSHTTPURLResponse* oauthResponse;
	NSError* oauthError;
	NSData * oauthResponseData = [NSURLConnection sendSynchronousRequest:oauthRequest returningResponse:&oauthResponse error:&oauthError];      
	NSString *oauthResponseString= [[[NSString alloc] initWithData:oauthResponseData encoding:NSUTF8StringEncoding] autorelease];
	
    NSDictionary * oauthJsonDict = [oauthResponseString JSONValue];
	if ([oauthJsonDict objectForKey:@"error"]) {
		if([@"invalid_grant" isEqualToString:[oauthJsonDict objectForKey:@"error"]]){
			//認証からやり直し
			return NO;
		}
	}
	if ([oauthJsonDict objectForKey:@"refresh_token"]) {
		[MGUserDefaults setRefreshToken:[oauthJsonDict objectForKey:OAUTH_REFRESH_TOKEN]];
		NSLog(@"refresh token = [%@]",[oauthJsonDict objectForKey:OAUTH_REFRESH_TOKEN]);
		[MGUserDefaults setAccessToken:[oauthJsonDict objectForKey:OAUTH_ACCESS_TOKEN]];
		NSLog(@"access_token = [%@]",[oauthJsonDict objectForKey:OAUTH_ACCESS_TOKEN]);
		[MGUserDefaults setExpiresIn:[oauthJsonDict objectForKey:OAUTH_EXPIRES_IN]];
		NSLog(@"expires_in = [%@]",[oauthJsonDict objectForKey:OAUTH_EXPIRES_IN]);
		return YES;
	}else{
		return NO;
	}		
}

//AuthorizationCodeを使って、OAuthTokenを取得する
-(BOOL)getOauthToken:(NSString *)authorizationCode{
	NSString* param = [NSString stringWithFormat:
					   @"grant_type=authorization_code&client_id=%@&client_secret=%@&code=%@&redirect_uri=%@",CONSUMER_KEY,CONSUMER_SECRET,authorizationCode, OAUTH_REDIRECT_URL];
	return [self requestOAuthToken:param];
}

//OAuthTokenのリフレッシュ
-(BOOL)refreshOAuthToken{
	NSString* param = [NSString stringWithFormat:
					   @"grant_type=refresh_token&client_id=%@&client_secret=%@&refresh_token=%@",CONSUMER_KEY,CONSUMER_SECRET, [MGUserDefaults loadRefreshToken]];
	return [self requestOAuthToken:param];
}

+(void)deleteOAuthToken{
	[MGUserDefaults removeExpiresIn];
	[MGUserDefaults removeRefreshToken];
	[MGUserDefaults removeAccessToken];
}

////////////UIWebViewDelegate////////////////
- (BOOL)webView:(UIWebView *)webView 
		shouldStartLoadWithRequest:(NSURLRequest *)request 
					navigationType:(UIWebViewNavigationType)navigationType {
	//クエリーにAuthorizationCodeが含まれているときは、リダイレクトをストップしてcodeを取得、
	NSString * query = [[request URL] query];
    NSLog(@"query = %@",query);
	NSArray  * array = [query componentsSeparatedByString:@"="];
    if([array count]>1){
		NSString * q = [array objectAtIndex:0];
		if([q isEqualToString: @"error"]){	//キャンセル時
			authorizationWebView.hidden=YES;	//WebViewの破棄
			authorizationWebView.delegate = nil;
			[authorizationWebView release];
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			if([delegate respondsToSelector:@selector(mgOAuthClientError)]){
				[delegate mgOAuthClientError];
			}
			return NO;
		}
		if([q isEqualToString: @"code"]){	//AuthorizationCodeだったら
			authorizationWebView.hidden=YES;	//WebViewの破棄
			authorizationWebView.delegate = nil;
			[authorizationWebView release];
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			//NSLog(@"AuthorizationCode = [%@]",[array objectAtIndex:1]);
			[self getOauthToken:[array objectAtIndex:1]];
			if([delegate respondsToSelector:@selector(mgOAuthClientDidGet)]){
				[delegate mgOAuthClientDidGet];
			}
			return NO;
		}
	}
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/////////////////////////////////////////////

@end
