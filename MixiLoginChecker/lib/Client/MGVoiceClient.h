//
//  MGVoiceClient.h
//  libMixiGraph
//
//  Created by kinukawa on 11/02/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MGVoice.h"
#import "MGUserDefaults.h"
#import "MGHttpClient.h"
#import "JSON.h"
#import "MGApiError.h"
#import "MGUtil.h"
#import "MGParams.h"

@protocol MGVoiceClientDelegate;

@interface MGVoiceClient : NSObject {
@public	
	id <MGVoiceClientDelegate> delegate;
    NSString * identifier;
@private
	MGHttpClient * httpClient;
}
@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) NSString * identifier;
@property (nonatomic,retain) MGHttpClient * httpClient;

//あるユーザのつぶやき一覧の取得
-(void)requestUserVoices:(NSString *)userId 
                trimUser:(bool)trimUser 
             attachPhoto:(bool)attachPhoto
              startIndex:(NSString *)startIndex
                   count:(NSString *)count;
//あるユーザのつぶやき一覧の取得
-(void)requestUserVoices:(NSString *)userId 
                trimUser:(bool)trimUser 
             attachPhoto:(bool)attachPhoto
              startIndex:(NSString *)startIndex
                   count:(NSString *)count
            usingSinceId:(NSString *)sinceId;

//友人のつぶやき一覧の取得
-(void)requestFriendsVoices:(NSString *)groupID
                   trimUser:(bool)trimUser 
                attachPhoto:(bool)attachPhoto
                 startIndex:(NSString *)startIndex
                      count:(NSString *)count;
//友人のつぶやき一覧の取得
-(void)requestFriendsVoices:(NSString *)groupID
                   trimUser:(bool)trimUser 
                attachPhoto:(bool)attachPhoto
                 startIndex:(NSString *)startIndex
                      count:(NSString *)count
               usingSinceId:(NSString *)sinceId;

//ある特定のつぶやき情報の取得
-(void)requestVoiceInfo:(NSString *)postId
               trimUser:(bool)trimUser 
            attachPhoto:(bool)attachPhoto;

-(void)postVoice:(NSString*)text;
-(void)postPhotoVoice:(NSString*)text photo:(UIImage *)photo;

@end

@protocol MGVoiceClientDelegate<NSObject>
-(void)mgVoiceClient:(NSURLConnection *)conn didFailWithError:(NSError*)error;
-(void)mgVoiceClient:(NSURLConnection *)conn didFinishLoading:(id)result;
-(void)mgVoiceClient:(NSURLConnection *)conn didFinishGetting:(NSArray *)voices;
-(void)mgVoiceClient:(NSURLConnection *)conn didFinishPosting:(id)reply;
@end
