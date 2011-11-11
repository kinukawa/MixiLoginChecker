//
//  MGPeopleClient.m
//  Picxi
//
//  Created by kinukawa on 11/02/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGPeopleClient.h"


@implementation MGPeopleClient
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
-(void)getMyProfile:(bool)status{
	NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if(status){
		[queryDict setObject:@"status" forKey:@"fields"];
	}
	
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
                                 path:[NSArray arrayWithObjects:
                                       @"2",
                                       @"people",
                                       @"@me",
                                       @"@self",
                                       nil]
                                query:queryDict];
	[httpClient get:url];
}

//idユーザーのボイスを取得
-(void)getFriends:(bool)lastLogin{
	NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if(lastLogin){
		[queryDict setObject:@"lastLogin" forKey:@"fields"];
	}
    [queryDict setObject:@"1000" forKey:@"count"];
	
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
                                 path:[NSArray arrayWithObjects:
                                       @"2",
                                       @"people",
                                       @"@me",
                                       @"@friends",
                                       nil]
                                query:queryDict];
	[httpClient get:url];
}


-(void)mgHttpClient:(NSURLConnection *)conn didFailWithAPIError:(MGApiError *)error{
	if([delegate respondsToSelector:@selector(mgPeopleClient:didFailWithAPIError:)]){
		[delegate mgPeopleClient:conn didFailWithAPIError:error];
	}	
}

-(void)mgHttpClient:(NSURLConnection *)conn didFailWithError:(NSError*)error{
	if([delegate respondsToSelector:@selector(mgPeopleClient:didFailWithError:)]){
		[delegate mgPeopleClient:conn didFailWithError:error];
	}
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoading:(NSMutableData *)data{
	NSString *contents = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	//NSLog(@"%@",contents);
	if([delegate respondsToSelector:@selector(mgPeopleClient:didFinishLoading:)]){
		id json = [contents JSONValue];
		id entry = [json objectForKey:@"entry"];
		if ([entry isKindOfClass:[NSArray class]]) {
			NSMutableArray * pepleArray = [NSMutableArray array];
			for(NSDictionary * pd in entry){
				MGPeople * people = [[[MGPeople alloc]init]autorelease];
				people.peopleId			= [pd objectForKey:@"id"];
				people.displayName		= [pd objectForKey:@"displayName"];
				people.thumbnailUrl		= [pd objectForKey:@"thumbnailUrl"];
				people.profileUrl		= [pd objectForKey:@"profileUrl"];
				people.lastLogin = [[pd objectForKey:@"lastLogin"] intValue]/60;
                [pepleArray addObject:people];
			}
			[delegate mgPeopleClient:conn didFinishLoading:pepleArray];
		}else if([entry isKindOfClass:[NSDictionary class]]) {
			MGPeople * people = [[[MGPeople alloc]init]autorelease];
			people.peopleId			= [entry objectForKey:@"id"];
			people.displayName		= [entry objectForKey:@"displayName"];
			people.thumbnailUrl		= [entry objectForKey:@"thumbnailUrl"];
			people.profileUrl		= [entry objectForKey:@"profileUrl"];
			NSDictionary * status = [entry objectForKey:@"status"];
			people.statusText		= [status objectForKey:@"text"];
			people.statusPostedTime		= [status objectForKey:@"postedTime"];
            people.lastLogin = [[status objectForKey:@"lastLogin"] intValue]/60;
            [delegate mgPeopleClient:conn didFinishLoading:people];
		}
	}
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingPost:(NSMutableData *)data{
	NSString *contents = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	if([delegate respondsToSelector:@selector(mgPeopleClient:didFinishPosting:)]){
		[delegate mgPeopleClient:conn didFinishPosting:contents];
	}
}

- (void) dealloc {
	[httpClient release];
	[super dealloc];
}

@end
