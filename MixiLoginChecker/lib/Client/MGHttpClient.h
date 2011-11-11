//
//  MGHttpClient.h
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGUserDefaults.h"
#import "MGUtil.h"
#import "MGApiError.h"
#import "MGOAuthClient.h"

@protocol MGHttpCliendDelegate;

@interface MGHttpClient : NSObject {
	NSMutableData * buffer;
	id <MGHttpCliendDelegate> delegate;
	NSString * method;
	NSMutableURLRequest * backupRequest;
    bool refresh;
    NSHTTPURLResponse *response;
    NSString * identifier;
}

-(bool)post:(NSURL*)url param:(NSDictionary *)param body:(NSData*)body;
-(bool)get:(NSURL*)url;
-(void)imagePost:(NSURL*)url image:(UIImage*)image;

@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) NSMutableURLRequest * backupRequest;
@property (nonatomic,retain) NSString * method;
@property (nonatomic,retain) NSMutableData * buffer;
@property (nonatomic,retain) NSHTTPURLResponse *response;
@property (nonatomic,retain) NSString * identifier;
@end

@protocol MGHttpCliendDelegate<NSObject>
-(void)mgHttpClient:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)res;
-(void)mgHttpClient:(NSURLConnection *)conn didReceiveData:(NSData *)receivedData;
-(void)mgHttpClient:(NSURLConnection *)conn didFailWithError:(NSError*)error;
-(void)mgHttpClient:(NSURLConnection *)conn didFailWithAPIError:(MGApiError*)error;

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoading:(NSMutableData *)data;
-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingGet:(NSMutableData *)data;
-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingPost:(NSMutableData *)data;
@end

