//
//  MGPhotoClient.h
//  libMixiGraph
//
//  Created by kinukawa on 11/02/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGHttpClient.h"
#import "MGUtil.h"
#import "MGPhoto.h"

@protocol MGPhotoClientDelegate;

@interface MGPhotoClient : NSObject {
@public	
	id <MGPhotoClientDelegate> delegate;
@private
	MGHttpClient * httpClient;	
}

-(void)getAllFriendsRecentPhotos;
-(void)getFriendsRecentPhotos:(NSString*)groupID;
-(void)makeAlbum:(NSString*)userId title:(NSString*)title body:(NSString*)body visibility:(NSString *)visibility accessKey:(NSString *)accessKey;
-(void)postPhoto:(UIImage *)photo userId:(NSString*)userId albumId:(NSString *)albumId title:(NSString*)title;
-(void)postPhotoToMyEasyAlbum:(UIImage *)photo title:(NSString*)title;

@property (nonatomic,assign) id delegate;

@end

@protocol MGPhotoClientDelegate<NSObject>
-(void)MGPhotoClient:(NSURLConnection *)conn didReceiveResponseError:(MGApiError *)error;
-(void)MGPhotoClient:(NSURLConnection *)conn didFailWithError:(NSError*)error;
-(void)MGPhotoClient:(NSURLConnection *)conn didFinishGetting:(id)photos;
-(void)MGPhotoClient:(NSURLConnection *)conn didFinishPosting:(id)reply;
@end