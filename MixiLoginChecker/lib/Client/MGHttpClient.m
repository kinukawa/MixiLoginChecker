//
//  MGHttpClient.m
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGHttpClient.h"


@implementation MGHttpClient

@synthesize delegate;
@synthesize backupRequest;
@synthesize method;
@synthesize buffer;
@synthesize response;
@synthesize identifier;

-(id)init{
	if((self = [super init])){
		self.method = nil;
        refresh = YES;
	}
	return self;
}

- (void) dealloc {
	self.backupRequest = nil;
	self.buffer = nil;
    self.method = nil;
    self.identifier = nil;
	[super dealloc];
}

-(bool)doRequest:(NSURLRequest*)req{
	NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
    if (conn) {
        self.buffer = [NSMutableData data];
		return YES;
	} else {
		return NO;		
	}	
}

//get
-(bool)get:(NSURL*)url{
	//NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
	[request setHTTPMethod:@"GET"];
    
	NSString * accessToken = [NSString stringWithFormat:@"OAuth %@",[MGUserDefaults loadAccessToken]];
	[request setValue:accessToken forHTTPHeaderField:@"Authorization"];
	
	self.backupRequest = nil;
	self.backupRequest = request;
	self.method = nil;
    self.method = [NSString stringWithFormat:@"get"];
	return [self doRequest:request];
}


-(bool)post:(NSURL*)url 
	   param:(NSDictionary *)param 
	   body:(NSData*)body{
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
	[request setHTTPMethod:@"POST"];
	
	NSString * accessToken = [NSString stringWithFormat:@"OAuth %@",[MGUserDefaults loadAccessToken]];
	[request setValue:accessToken forHTTPHeaderField:@"Authorization"];
	
	for (id key in param){
		[request setValue:[param objectForKey:key] forHTTPHeaderField:key];		 
	}
	[request setHTTPBody:body];
	
	self.backupRequest = nil;
	self.backupRequest = request;
	
    self.method = nil;
    self.method = [NSString stringWithFormat:@"post"];
	return [self doRequest:request];
}

-(void)imagePost:(NSURL*)url 
		   image:(UIImage*)image{
	
	NSData* jpegData = UIImageJPEGRepresentation( image, 1.0 );
	[self post:url
		 param:[NSDictionary dictionaryWithObjectsAndKeys:
				@"image/jpeg",@"Content-type",nil]
		  body:jpegData];
}


//レスポンス受信時に呼ばれる
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)res {
	NSHTTPURLResponse *hres = (NSHTTPURLResponse *)res;
    self.response = hres;	
}

//レスポンスデータ受信
- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)receivedData {
	[self.buffer appendData:receivedData];
	if ([delegate respondsToSelector:@selector(mgHttpClient:didReceiveData:)]) {
		[delegate mgHttpClient:conn didReceiveData:receivedData];
	}
}


//エラー受信
-(void)connection:(NSURLConnection*)conn didFailWithError:(NSError*)error{
	NSLog(@"Connection failed! Error - %@ %d %@",
		  [error domain],
		  [error code],
		  [error localizedDescription]);
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.buffer = nil;
	self.method = nil;
	
	//ネットワークに接続されていない時
	
    if ([delegate respondsToSelector:@selector(mgHttpClient:didFailWithError:)]) {
		[delegate mgHttpClient:conn didFailWithError:error];
	}
}

-(void)retryRequest{
    NSLog(@"one more request!!!!!!");
    self.buffer = nil;
    
    NSString * accessToken = [NSString stringWithFormat:@"OAuth %@",[MGUserDefaults loadAccessToken]];
    [self.backupRequest setValue:accessToken forHTTPHeaderField:@"Authorization"];
    [self doRequest:self.backupRequest];
    //refresh = NO;
    //self.method = nil;    
}

//レスポンスエラーチェック
-(MGApiError *)checkResponseError:(NSDictionary *)dict{
	NSString *authenticate = [dict objectForKey:@"Www-Authenticate"];
	if(authenticate){
		NSDictionary * authDict = [MGUtil parseAuthenticateHeader:authenticate];
		NSString * error = [authDict objectForKey:@"error"];
		MGApiError * apiError = [[[MGApiError alloc]init]autorelease];
		if ([error isEqualToString:@"expired_token"]){
			apiError.errorType = MGApiErrorTypeExpiredToken;
		}else if([error isEqualToString:@"invalid_request"]){
			apiError.errorType = MGApiErrorTypeInvalidRequest;
		}else if([error isEqualToString:@"invalid_token"]){
			apiError.errorType = MGApiErrorTypeInvalidToken;
		}else if([error isEqualToString:@"insufficient_scope"]){
			apiError.errorType = MGApiErrorTypeInsufficientScope;
		}else{
			apiError.errorType = MGApiErrorTypeOther;
		}
		return apiError;
	}
	return nil;
}

//受信終了
- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
	NSLog(@"Succeed!! Received %d bytes of data", [buffer length]);
	//NSLog(@"%@", [[[NSString alloc]initWithData:buffer encoding:NSASCIIStringEncoding]autorelease]);
    
    NSLog(@"Received Response. Status Code: %d", [response statusCode]);
	NSLog(@"Expected ContentLength: %qi", [response expectedContentLength]);
	NSLog(@"MIMEType: %@", [response MIMEType]);
	NSLog(@"Suggested File Name: %@", [response suggestedFilename]);
	NSLog(@"Text Encoding Name: %@", [response textEncodingName]);
	NSLog(@"URL: %@", [response URL]);
	
    if([response statusCode]==401){
        //リフレッシュ処理
        MGApiError * apiError = [self checkResponseError:[response allHeaderFields]];
        apiError.response = response;
        if(apiError.errorType == MGApiErrorTypeExpiredToken){
            NSLog(@"OAuth Token is expired.");
            MGOAuthClient * oauthClient = [[[MGOAuthClient alloc]init]autorelease];
            if([oauthClient refreshOAuthToken]){
                NSLog(@"Refreshed and retry request.");
                self.buffer = nil;
                [self retryRequest];
                return;
            }else{
                NSLog(@"Invalid grant. please relogin.");
                apiError.errorType = MGApiErrorTypeInvalidGrant;
                //エラーデリゲート呼ぶ
                if([delegate respondsToSelector:@selector(mgHttpClient:didFailWithAPIError:)]){
                    [delegate mgHttpClient:conn didFailWithAPIError:apiError];
                }
                return;
            }
        }
        if([delegate respondsToSelector:@selector(mgHttpClient:didFailWithAPIError:)]){
            [delegate mgHttpClient:conn didFailWithAPIError:apiError];
        }
    }else if([response statusCode]==200){
        if([delegate respondsToSelector:@selector(mgHttpClient:didFinishLoading:)]){
            [delegate mgHttpClient:conn didFinishLoading:buffer];
        }
        
        if([method isEqualToString:@"get"]){
            if([delegate respondsToSelector:@selector(mgHttpClient:didFinishLoadingGet:)]){
                [delegate mgHttpClient:conn didFinishLoadingGet:buffer];
            }
        }else if([method isEqualToString:@"post"]){
            if([delegate respondsToSelector:@selector(mgHttpClient:didFinishLoadingPost:)]){
                [delegate mgHttpClient:conn didFinishLoadingPost:buffer];
            }
        }	
        
    }else{
        if([delegate respondsToSelector:@selector(mgHttpClient:didFailWithAPIError:)]){
            MGApiError * apiError = [self checkResponseError:[response allHeaderFields]];
            apiError.response = response;
            //apiError.errorType = MGApiErrorTypeOther;
            [delegate mgHttpClient:conn didFailWithAPIError:apiError];
        }
    }
    self.buffer = nil;
    self.method = nil;
    self.response = nil;
    return;
    /*	
    if(refresh){
        NSLog(@"one more request!!!!!!");
        self.buffer = nil;
        
        NSString * accessToken = [NSString stringWithFormat:@"OAuth %@",[MGUserDefaults loadAccessToken]];
        [self.backupRequest setValue:accessToken forHTTPHeaderField:@"Authorization"];
        [self doRequest:self.backupRequest];
        //refresh = NO;
        //self.method = nil;
    }else{
        if([method isEqualToString:@"get"]){
            if([delegate respondsToSelector:@selector(mgHttpClient:didFinishLoadingGet:)]){
                [delegate mgHttpClient:conn didFinishLoadingGet:buffer];
            }
        }else if([method isEqualToString:@"post"]){
            if([delegate respondsToSelector:@selector(mgHttpClient:didFinishLoadingPost:)]){
                [delegate mgHttpClient:conn didFinishLoadingPost:buffer];
            }
        }	
    
        self.buffer = nil;
        self.method = nil;
    }
*/	
}

@end
