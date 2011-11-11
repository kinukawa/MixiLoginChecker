//
//  MGVoiceClient.m
//  libMixiGraph
//
//  Created by kinukawa on 11/02/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGVoiceClient.h"


@implementation MGVoiceClient

@synthesize delegate;
@synthesize identifier;
@synthesize httpClient;

-(id)init{
	if((self = [super init])){
		//initialize
		self.httpClient = [[[MGHttpClient alloc] init]autorelease];
		self.httpClient.delegate = self;
	}
	return self;
}

- (void) dealloc {
    self.delegate = nil;
	self.httpClient = nil;
	self.identifier = nil;
    [super dealloc];
}

//あるユーザのつぶやき一覧の取得
-(void)requestUserVoices:(NSString *)userId 
                trimUser:(bool)trimUser 
             attachPhoto:(bool)attachPhoto
              startIndex:(NSString *)startIndex
                   count:(NSString *)count{
    NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if (trimUser) {
		[queryDict setObject:@"1" forKey:@"trim_user"];
	}
	if (attachPhoto) {
		[queryDict setObject:@"1" forKey:@"attach_photo"];
	}
    if (startIndex) {
		[queryDict setObject:startIndex forKey:@"startIndex"];
	} 
    if (count) {
		[queryDict setObject:count forKey:@"count"];
	}    
	NSURL * url = [MGUtil buildAPIURL:VOICE_BASE_URL
                                 path:[NSArray arrayWithObjects:
                                       userId,
                                       @"user_timeline",
                                       nil]
                                query:queryDict];
    httpClient.identifier = @"requestUserVoices";
	[httpClient get:url];
}


//あるユーザのつぶやき一覧の取得
-(void)requestUserVoices:(NSString *)userId 
                trimUser:(bool)trimUser 
             attachPhoto:(bool)attachPhoto
              startIndex:(NSString *)startIndex
                   count:(NSString *)count
                 usingSinceId:(NSString *)sinceId {
    NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if (trimUser) {
		[queryDict setObject:@"1" forKey:@"trim_user"];
	}
	if (attachPhoto) {
		[queryDict setObject:@"1" forKey:@"attach_photo"];
	}
    if (sinceId) {
		[queryDict setObject:sinceId forKey:@"since_id"];
	}    
    if (startIndex) {
		[queryDict setObject:startIndex forKey:@"startIndex"];
	} 
    if (count) {
		[queryDict setObject:count forKey:@"count"];
	}    
	NSURL * url = [MGUtil buildAPIURL:VOICE_BASE_URL
                                 path:[NSArray arrayWithObjects:
                                       userId,
                                       @"user_timeline",
                                       nil]
                                query:queryDict];
    httpClient.identifier = @"requestUserVoicesUsingSinceId";
	[httpClient get:url];
}
//友人のつぶやき一覧の取得
-(void)requestFriendsVoices:(NSString *)groupID
                   trimUser:(bool)trimUser 
                attachPhoto:(bool)attachPhoto
                 startIndex:(NSString *)startIndex
                      count:(NSString *)count{
    NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if (trimUser) {
		[queryDict setObject:@"1" forKey:@"trim_user"];
	}
	if (attachPhoto) {
		[queryDict setObject:@"1" forKey:@"attach_photo"];
	}
    if (startIndex) {
		[queryDict setObject:startIndex forKey:@"startIndex"];
	} 
    if (count) {
		[queryDict setObject:count forKey:@"count"];
	}    
	NSURL * url = [MGUtil buildAPIURL:VOICE_BASE_URL
                                 path:[NSArray arrayWithObjects:
                                       @"friends_timeline",
                                       groupID,
                                       nil]
                                query:queryDict];
    httpClient.identifier = @"requestFriendsVoices";
	[httpClient get:url];
}

//友人のつぶやき一覧の取得
-(void)requestFriendsVoices:(NSString *)groupID
                trimUser:(bool)trimUser 
             attachPhoto:(bool)attachPhoto
              startIndex:(NSString *)startIndex
                   count:(NSString *)count
               usingSinceId:(NSString *)sinceId {
    NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if (trimUser) {
		[queryDict setObject:@"1" forKey:@"trim_user"];
	}
	if (attachPhoto) {
		[queryDict setObject:@"1" forKey:@"attach_photo"];
	}
    if (sinceId) {
		[queryDict setObject:sinceId forKey:@"since_id"];
	}    
    if (startIndex) {
		[queryDict setObject:startIndex forKey:@"startIndex"];
	} 
    if (count) {
		[queryDict setObject:count forKey:@"count"];
	}    
	NSURL * url = [MGUtil buildAPIURL:VOICE_BASE_URL
                                 path:[NSArray arrayWithObjects:
                                       @"friends_timeline",
                                       groupID,
                                       nil]
                                query:queryDict];
    httpClient.identifier = @"requestFriendsVoicesUsingSinceId";
	[httpClient get:url];
}
//ある特定のつぶやき情報の取得
-(void)requestVoiceInfo:(NSString *)postId
               trimUser:(bool)trimUser 
            attachPhoto:(bool)attachPhoto{
    
    NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if (trimUser) {
		[queryDict setObject:@"1" forKey:@"trim_user"];
	}
	if (attachPhoto) {
		[queryDict setObject:@"1" forKey:@"attach_photo"];
	}
    NSURL * url = [MGUtil buildAPIURL:VOICE_BASE_URL
                                 path:[NSArray arrayWithObjects:
                                       postId,
                                       nil]
                                query:queryDict];
    httpClient.identifier = @"requestVoiceInfo";
	[httpClient get:url];
}

//ボイスの投稿
-(void)postVoice:(NSString*)text{
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
							   path:[NSArray arrayWithObjects:
									 @"2",
									 @"voice",
									 @"statuses",
									 nil]
							  query:nil];
	NSData * body = [[[NSString stringWithFormat:@"status=%@",text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
	[httpClient post:url param:nil body:body];
	
}

//ボイスの投稿
-(void)postPhotoVoice:(NSString*)text photo:(UIImage *)photo{
	
	NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if (text) {
		[queryDict setObject:[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"status"];
	}
	
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
							   path:[NSArray arrayWithObjects:
									 @"2",
									 @"voice",
									 @"statuses",
									 nil]
							  query:queryDict];
	
	
	[httpClient imagePost:url image:photo];
}

//ボイスの削除
-(void)deleteVoice:(MGVoice*)voice{
}

-(void)mgHttpClient:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)res{
	NSLog(@"MGVoiceClient didReceiveResponse");
}

-(void)mgHttpClient:(NSURLConnection *)conn didReceiveData:(NSData *)receivedData{
	NSLog(@"MGVoiceClient didReceiveData");
}

-(void)mgHttpClient:(NSURLConnection *)conn didFailWithError:(NSError*)error{
	NSLog(@"MGVoiceClient didFailWithError");
	if([delegate respondsToSelector:@selector(mgVoiceClient:didFailWithError:)]){
		[delegate mgVoiceClient:conn didFailWithError:error];
	}
}

-(NSArray *)makeVoiceArrayFromResponseContents:(NSData*)data{
    NSString *contents = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSMutableArray * voiceArray = [NSMutableArray array];
    NSArray * voiceJsonArray = [contents JSONValue];
    for(NSDictionary * voiceContentDict in voiceJsonArray){
        MGVoice * voice = [[[MGVoice alloc] init] autorelease];
        /*for (id key in voiceContentDict){
         NSLog(@"key=[%@] value=[%@] type=[%@]",key,[voiceContentDict objectForKey:key],[[voiceContentDict objectForKey:key] class]);	 
        }*/
        NSDictionary * user = [voiceContentDict objectForKey:@"user"];
        voice.postId = [voiceContentDict objectForKey:@"id"];
        voice.createdAt = [voiceContentDict objectForKey:@"created_at"];
        voice.voiceText = [voiceContentDict objectForKey:@"text"];
        voice.userId = [user objectForKey:@"id"];
        voice.userScreeName = [user objectForKey:@"screen_name"];
        voice.userProfileImageUrl = [user objectForKey:@"profile_image_url"];
        voice.userUrl = [user objectForKey:@"url"];
        voice.replyCount = [voiceContentDict objectForKey:@"reply_count"];
        voice.favoriteCount = [voiceContentDict objectForKey:@"favorite_count"];
        voice.source = [voiceContentDict objectForKey:@"source"];
        voice.favorited = [voiceContentDict objectForKey:@"favorited"];
        NSArray * photoArr =[voiceContentDict objectForKey:@"photo"];
        if (photoArr) {
            if ([photoArr count]>0) {
                voice.photoImageUrl = [[photoArr objectAtIndex:0] objectForKey:@"image_url"];
                voice.photoThumbnailUrl = [[photoArr objectAtIndex:0] objectForKey:@"thumbnail_url"];
            }
        }
        [voiceArray addObject:voice];
    }
    return voiceArray;
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoading:(NSMutableData *)data{
	NSLog(@"MGVoiceClient didFinishLoading");
    id result;
    if(httpClient.identifier==@"requestUserVoices"){
        result = [self makeVoiceArrayFromResponseContents:data];
    }else if(httpClient.identifier==@"requestUserVoicesUsingSinceId"){
        result = [self makeVoiceArrayFromResponseContents:data];
    }else if(httpClient.identifier==@"requestFriendsVoices"){
        result = [self makeVoiceArrayFromResponseContents:data];
    }else if(httpClient.identifier==@"requestFriendsVoicesUsingSinceId"){
        result = [self makeVoiceArrayFromResponseContents:data];
    }else if(httpClient.identifier==@"requestVoiceInfo"){
        result = [self makeVoiceArrayFromResponseContents:data];
    }

	if([delegate respondsToSelector:@selector(mgVoiceClient:didFinishLoading:)]){
        [delegate mgVoiceClient:conn didFinishLoading:result];
    }
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingGet:(NSMutableData *)data{
	NSLog(@"MGVoiceClient didFinishLoading Get");
	NSString *contents = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	if([delegate respondsToSelector:@selector(mgVoiceClient:didFinishGetting:)]){
		NSMutableArray * voiceArray = [NSMutableArray array];
		NSArray * voiceJsonArray = [contents JSONValue];
		for(NSDictionary * voiceContentDict in voiceJsonArray){
			MGVoice * voice = [[[MGVoice alloc] init] autorelease];
			/*for (id key in voiceContentDict){
				NSLog(@"key=[%@] value=[%@] type=[%@]",key,[voiceContentDict objectForKey:key],[[voiceContentDict objectForKey:key] class]);	 
			}*/
			NSDictionary * user = [voiceContentDict objectForKey:@"user"];
			voice.postId = [voiceContentDict objectForKey:@"id"];
			voice.createdAt = [voiceContentDict objectForKey:@"created_at"];
			voice.voiceText = [voiceContentDict objectForKey:@"text"];
			voice.userId = [user objectForKey:@"id"];
			voice.userScreeName = [user objectForKey:@"screen_name"];
			voice.userProfileImageUrl = [user objectForKey:@"profile_image_url"];
			voice.userUrl = [user objectForKey:@"url"];
			voice.replyCount = [voiceContentDict objectForKey:@"reply_count"];
			voice.favoriteCount = [voiceContentDict objectForKey:@"favorite_count"];
			voice.source = [voiceContentDict objectForKey:@"source"];
			voice.favorited = [voiceContentDict objectForKey:@"favorited"];
			NSArray * photoArr =[voiceContentDict objectForKey:@"photo"];
			if (photoArr) {
				if ([photoArr count]>0) {
					voice.photoImageUrl = [[photoArr objectAtIndex:0] objectForKey:@"image_url"];
					voice.photoThumbnailUrl = [[photoArr objectAtIndex:0] objectForKey:@"thumbnail_url"];
				}
			}
			[voiceArray addObject:voice];
		}
		
		[delegate mgVoiceClient:conn didFinishGetting:voiceArray];
	}
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingPost:(NSMutableData *)data{
	NSLog(@"MGVoiceClient didFinishPosting");
	NSString *contents = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"post response : %@",contents);
	if([delegate respondsToSelector:@selector(mgVoiceClient:didFinishPosting:)]){
		[delegate mgVoiceClient:conn didFinishPosting:contents];
	}
}

@end