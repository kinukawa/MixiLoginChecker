//
//  MGFeedbackClient.m
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGFeedbackClient.h"


@implementation MGFeedbackClient
@synthesize delegate;

-(id)init{
	if((self = [super init])){
		//initialize
		httpClient = [[MGHttpClient alloc] init];
		
		httpClient.delegate = self;
	}
	return self;
}

//idユーザーのボイスを取得
-(void)getFeedbacks:(NSString *)type 
			postId:(NSString *)postId 
		  trimUser:(bool)isTrimUser {
	
	NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if (isTrimUser) {
		[queryDict setObject:@"1" forKey:@"trim_user"];
	}
	
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
								 path:[NSArray arrayWithObjects:
									   @"2",
									   type,
									   @"favorites",
									   postId,
									   nil]
								query:queryDict];
	[httpClient get:url];
}

//イイネの取得
-(void)getPhotoFeedbacks:(NSString *)userId 
                 albumId:(NSString *)albumId 
             mediaItemId:(NSString *)mediaitemId{
	
		
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
								 path:[NSArray arrayWithObjects:
									   @"2",
									   @"photo",
									   @"favorites",
									   @"mediaItems",
									   userId,
                                       @"@self",
                                       albumId,
                                       mediaitemId,
									   nil]
								query:nil];
	[httpClient get:url];
}

-(void)postFeedback:(NSString *)type 
			 postId:(NSString *)postId {
	
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
								 path:[NSArray arrayWithObjects:
									   @"2",
									   type,
									   @"favorites",
									   postId,
									   nil]
								query:nil];
	[httpClient post:url param:nil body:nil];
}

-(void)postPhotoFeedback:(NSString *)type 
                  userId:(NSString *)userId 
                 albumId:(NSString *)albumId 
             mediaItemId:(NSString *)mediaitemId{
	
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
								 path:[NSArray arrayWithObjects:
									   @"2",
									   type,
									   @"favorites",
									   @"mediaItems",
									   userId,
                                       @"@self",
                                       albumId,
                                       mediaitemId,
									   nil]
								query:nil];
	[httpClient post:url param:nil body:nil];
}


-(void)mgHttpClient:(NSURLConnection *)conn didReceiveResponseError:(MGApiError *)error{
	if([delegate respondsToSelector:@selector(mgFeedbackClient:didReceiveResponseError:)]){
		[delegate mgFeedbackClient:conn didReceiveResponseError:error];
	}
}

-(void)mgHttpClient:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)res{
	NSLog(@"didReceiveResponse");
}

-(void)mgHttpClient:(NSURLConnection *)conn didReceiveData:(NSData *)receivedData{
	NSLog(@"didReceiveData");
}

-(void)mgHttpClient:(NSURLConnection *)conn didFailWithError:(NSError*)error{
	NSLog(@"didFailWithError");
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingGet:(NSMutableData *)data{
	NSLog(@"didFinishLoading");
	NSString *contents = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	if([delegate respondsToSelector:@selector(mgFeedbackClient:didFinishGetting:)]){
		NSMutableArray * feedbackArray = [NSMutableArray array];
		NSArray * feedbackJsonArray = [contents JSONValue];
		for(NSDictionary * feedbackContentDict in feedbackJsonArray){
			MGFeedback * feedback = [[[MGFeedback alloc] init] autorelease];
			/*for (id key in voiceContentDict){
			 NSLog(@"key=[%@] value=[%@] type=[%@]",key,[voiceContentDict objectForKey:key],[[voiceContentDict objectForKey:key] class]);	 
			 }*/
			feedback.userId = [feedbackContentDict objectForKey:@"id"];
			feedback.userScreeName = [feedbackContentDict objectForKey:@"screen_name"];
			feedback.userProfileImageUrl = [feedbackContentDict objectForKey:@"profile_image_url"];
			feedback.userUrl = [feedbackContentDict objectForKey:@"url"];
			[feedbackArray addObject:feedback];
		}
		
		[delegate mgFeedbackClient:conn didFinishGetting:feedbackArray];
	}
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingPost:(NSMutableData *)data{
	if([delegate respondsToSelector:@selector(mgFeedbackClient:didFinishPosting:)]){
		[delegate mgFeedbackClient:conn didFinishPosting:data];
	}	
}

- (void) dealloc {
	[httpClient release];
	[super dealloc];
}

@end
