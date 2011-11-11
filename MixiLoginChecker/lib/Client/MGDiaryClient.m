//
//  MGDiaryClient.m
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGDiaryClient.h"


@implementation MGDiaryClient
@synthesize delegate;

-(id)init{
	if((self = [super init])){
		//initialize
		httpClient = [[MGHttpClient alloc] init];
		
		httpClient.delegate = self;
	}
	return self;
}

//日記の投稿
-(void)postDiary:(NSString*)title body:(NSString*)body{
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
							   path:[NSArray arrayWithObjects:
									 @"2",
									 @"diary",
									 @"articles",
									 @"@me",
									 @"@self",
									 nil]
							  query:nil];
	NSString * json = [NSString stringWithFormat:@"{\"title\":\"%@\",\"body\":\"%@\",\"privacy\":{\"visibility\":\"self\",\"show_users\":\"0\"}}",title,body];
	NSLog(@"%@",json);
	NSData * postData = [json dataUsingEncoding:NSUTF8StringEncoding];
	[httpClient post:url param:[NSDictionary dictionaryWithObjectsAndKeys:
								@"application/json",@"Content-type",nil] body:postData];
}

//
//写真をサーバにPOSTする
//
-(void)postDiaryWithPhoto:(NSString*)title 
					 body:(NSString*)body 
					photo:(UIImage *)photo{
	
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
								 path:[NSArray arrayWithObjects:
									   @"2",
									   @"diary",
									   @"articles",
									   @"@me",
									   @"@self",
									   nil]
								query:nil];

	NSString * json = [NSString stringWithFormat:@"{\"title\":\"%@\",\"body\":\"%@\",\"privacy\":{\"visibility\":\"self\",\"show_users\":\"0\"}}",title,body];
	
	NSMutableData* imgData = [[[NSData alloc] initWithData:UIImageJPEGRepresentation(photo, 1.0)] autorelease];
	NSString *stringBoundary, *contentType; 
	stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"]; 
    contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary]; 
	
    // Setting up the POST request's multipart/form-data body 
	NSMutableData *postBody; 
    postBody = [NSMutableData data]; 
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"request\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; 
	[postBody appendData:[[NSString stringWithString:json] dataUsingEncoding:NSUTF8StringEncoding]]; 
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo1\"; filename=\"%@\"\r\n", @"test.jpg" ] dataUsingEncoding:NSUTF8StringEncoding]]; 
    [postBody appendData:[[NSString stringWithString:@"Content-Type: image/jpg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; // jpeg as data 
    [postBody appendData:imgData];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]]; 
	
	[httpClient post:url param:[NSDictionary dictionaryWithObjectsAndKeys:
								contentType,@"Content-type",nil] body:postBody];
}


-(void)mgHttpClient:(NSURLConnection *)conn didReceiveResponseError:(MGApiError *)error{
	NSLog(@"didReceiveResponseError");
	/*if([delegate respondsToSelector:@selector(mgFeedbackClient:didReceiveResponseError:)]){
		[delegate mgFeedbackClient:conn didReceiveResponseError:error];
	}*/
	
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
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingPost:(NSMutableData *)data{
	NSLog(@"didFinishLoading");
	NSString *contents = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"%@",contents);
	/*if([delegate respondsToSelector:@selector(mgVoiceClient:didFinishPosting:)]){
		[delegate mgVoiceClient:conn didFinishPosting:contents];
	}*/
}

- (void) dealloc {
	[httpClient release];
	[super dealloc];
}

@end
