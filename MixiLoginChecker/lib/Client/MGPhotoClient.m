//
//  MGPhotoClient.m
//  libMixiGraph
//
//  Created by kinukawa on 11/02/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGPhotoClient.h"


@implementation MGPhotoClient
@synthesize delegate;

-(id)init{
	if((self = [super init])){
		//initialize
		httpClient = [[MGHttpClient alloc] init];
		
		httpClient.delegate = self;
	}
	return self;
}

//マイミクのフォトを取得
-(void)getFriendsRecentPhotos:(NSString*)groupID{
	
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
							   path:[NSArray arrayWithObjects:
									 @"2",
									 @"photo",
									 @"mediaItems",
									 @"@me",
									 groupID,
									 nil]
							  query:nil];
	[httpClient get:url];
	
}

//すべてのマイミクのフォトを取得
-(void)getAllFriendsRecentPhotos{
	[self getFriendsRecentPhotos:@"@friends"];
}

//フォトの投稿
-(void)postPhoto:(UIImage *)photo userId:(NSString*)userId albumId:(NSString *)albumId title:(NSString*)title{
	
	NSMutableDictionary * queryDict = [NSMutableDictionary dictionary];
	if (title) {
		[queryDict setObject:[title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"title"];
	}
	
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
							   path:[NSArray arrayWithObjects:
									 @"2",
									 @"photo",
									 @"mediaItems",
									 userId,
									 @"@self",
									 albumId,
									 nil]
							  query:queryDict];
	
	
	[httpClient imagePost:url image:photo];
}

//自分の簡単公開アルバムにフォトを投稿
-(void)postPhotoToMyEasyAlbum:(UIImage *)photo title:(NSString*)title{
    [self postPhoto:photo userId:@"@me" albumId:@"@default" title:title];
}

//アルバムの作成
-(void)makeAlbum:(NSString*)userId title:(NSString*)title body:(NSString*)body visibility:(NSString *)visibility accessKey:(NSString *)accessKey{
	NSURL * url = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
							   path:[NSArray arrayWithObjects:
									 @"2",
									 @"photo",
									 @"albums",
									 @"@me",
									 @"@self",
									 nil]
							  query:nil];
    
    NSString * json;
    if(accessKey){
        json = [NSString stringWithFormat:@"{\"title\":\"%@\",\"description\":\"%@\",\"privacy\":{\"visibility\":\"%@\",\"accessKey\":\"%@\"}}",title,body,visibility,accessKey];
	}else{
        json = [NSString stringWithFormat:@"{\"title\":\"%@\",\"description\":\"%@\",\"privacy\":{\"visibility\":\"%@\"}}",title,body,visibility,accessKey];
	}
    NSLog(@"%@",json);
	NSData * postData = [json dataUsingEncoding:NSUTF8StringEncoding];
	[httpClient post:url param:[NSDictionary dictionaryWithObjectsAndKeys:
								@"application/json",@"Content-type",nil] body:postData];
}


-(void)mgHttpClient:(NSURLConnection *)conn didReceiveResponseError:(MGApiError *)error{
	NSLog(@"didReceiveResponseError");
	if([delegate respondsToSelector:@selector(MGPhotoClient:didReceiveResponseError:)]){
		[delegate MGPhotoClient:conn didReceiveResponseError:error];
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
	if([delegate respondsToSelector:@selector(MGPhotoClient:didFinishGetting:)]){
		
	
		NSDictionary * jsonDict = [contents JSONValue];
		NSArray * entries = [jsonDict objectForKey:@"entry"];
		NSMutableArray * photos = [NSMutableArray array];
		
		for(NSDictionary * entry in entries){
			NSLog(@"%@",entry);
			MGPhoto * photo = [[[MGPhoto alloc]init]autorelease];
	
			photo.albumId			= [entry objectForKey:@"albumId"];
			photo.created			= [entry objectForKey:@"created"];
			photo.photoId			= [entry objectForKey:@"id"];
			photo.largeImageUrl		= [entry objectForKey:@"largeImageUrl"];
			photo.mimeType			= [entry objectForKey:@"mimeType"];
			photo.numComments		= [entry objectForKey:@"numComments"];
			photo.numFavorites		= [entry objectForKey:@"numFavorites"];
			photo.thumbnailUrl		= [entry objectForKey:@"thumbnailUrl"];
			photo.photoTitle		= [entry objectForKey:@"title"];
			photo.photoType			= [entry objectForKey:@"type"];
			photo.url				= [entry objectForKey:@"url"];
			photo.viewPageUrl		= [entry objectForKey:@"viewPageUrl"];
			NSDictionary * owner	= [entry objectForKey:@"owner"];
			photo.ownerThumbnailUrl = [owner objectForKey:@"thumbnailUrl"];
			photo.ownerId			= [owner objectForKey:@"id"];
			photo.ownerDisplayName	= [owner objectForKey:@"displayName"];
			photo.ownerProfileUrl	= [owner objectForKey:@"profileUrl"];
			
			[photos addObject:photo];
		}
		
		[delegate MGPhotoClient:conn didFinishGetting:photos];
	}
/*		NSMutableArray * voiceArray = [NSMutableArray array];
		NSArray * voiceJsonArray = [contents JSONValue];
		for(NSDictionary * voiceContentDict in voiceJsonArray){
			MGVoice * voice = [[[MGVoice alloc] init] autorelease];
			for (id key in voiceContentDict){
				NSLog(@"key=[%@] value=[%@] type=[%@]",key,[voiceContentDict objectForKey:key],[[voiceContentDict objectForKey:key] class]);	 
			}
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
*/		
}

-(void)mgHttpClient:(NSURLConnection *)conn didFinishLoadingPost:(NSMutableData *)data{
	NSLog(@"didFinishLoading");
	NSString *contents = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	if([delegate respondsToSelector:@selector(MGPhotoClient:didFinishPosting:)]){
		[delegate MGPhotoClient:conn didFinishPosting:contents];
	}
}

- (void) dealloc {
	[httpClient release];
	[super dealloc];
}

@end
