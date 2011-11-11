//
//  MGCommentClient.m
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGCommentClient.h"


@implementation MGCommentClient
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
-(void)getComments:(NSString *)type 
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
									 @"replies",
									 postId,
									 nil]
							  query:queryDict];
	[httpClient get:url];
}

-(void)postComment:(NSString *)type 
			postId:(NSString *)postId 
		   comment:(NSString*)comment{

	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
								 path:[NSArray arrayWithObjects:
									   @"2",
									   type,
									   @"replies",
									   postId,
									   nil]
								query:nil];
	NSData * body = [[[NSString stringWithFormat:@"text=%@",comment] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
	[httpClient post:url param:nil body:body];
}

-(void)mgHttpClient:(NSURLConnection *)conn didReceiveResponseError:(MGApiError *)error{
	NSLog(@"didReceiveResponseError");
	if([delegate respondsToSelector:@selector(mgCommentClient:didReceiveResponseError:)]){
		[delegate mgCommentClient:conn didReceiveResponseError:error];
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
	
	if([delegate respondsToSelector:@selector(mgCommentClient:didFinishGetting:)]){
		NSMutableArray * commentArray = [NSMutableArray array];
		NSArray * commentJsonArray = [contents JSONValue];
		for(NSDictionary * commentContentDict in commentJsonArray){
			MGComment * comment = [[[MGComment alloc] init] autorelease];
			/*for (id key in voiceContentDict){
			 NSLog(@"key=[%@] value=[%@] type=[%@]",key,[voiceContentDict objectForKey:key],[[voiceContentDict objectForKey:key] class]);	 
			 }*/
			NSDictionary * user = [commentContentDict objectForKey:@"user"];
			comment.commentId = [commentContentDict objectForKey:@"id"];
			comment.createdAt = [commentContentDict objectForKey:@"created_at"];
			comment.commentText = [commentContentDict objectForKey:@"text"];
			comment.userId = [user objectForKey:@"id"];
			comment.userScreeName = [user objectForKey:@"screen_name"];
			comment.userProfileImageUrl = [user objectForKey:@"profile_image_url"];
			comment.userUrl = [user objectForKey:@"url"];
			[commentArray addObject:comment];
		}
		
		[delegate mgCommentClient:conn didFinishGetting:commentArray];
	}
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingPost:(NSMutableData *)data{
	if([delegate respondsToSelector:@selector(mgCommentClient:didFinishPosting:)]){
		[delegate mgCommentClient:conn didFinishPosting:data];
	}	
}

- (void) dealloc {
	[httpClient release];
	[super dealloc];
}

@end
