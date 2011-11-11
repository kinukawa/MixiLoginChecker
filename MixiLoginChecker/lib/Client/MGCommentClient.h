//
//  MGCommentClient.h
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "MGHttpClient.h"
#import "MGComment.h"
#import "MGUtil.h"

@protocol MGCommentClientDelegate;

@interface MGCommentClient : NSObject <MGHttpCliendDelegate>{
@public	
	id <MGCommentClientDelegate> delegate;
@private
	MGHttpClient * httpClient;
}

-(void)getComments:(NSString *)type postId:(NSString *)postId trimUser:(bool)isTrimUser;
-(void)postComment:(NSString *)type postId:(NSString *)postId comment:(NSString*)comment;
	

@property (nonatomic,assign) id delegate;

@end

@protocol MGCommentClientDelegate<NSObject>
-(void)mgCommentClient:(NSURLConnection *)conn didFinishGetting:(NSArray *)commentArray;
-(void)mgCommentClient:(NSURLConnection *)conn didFinishPosting:(id)reply;
-(void)mgCommentClient:(NSURLConnection *)conn didReceiveResponseError:(MGApiError *)error;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFailWithError:(NSError*)error;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFinishGetting:(NSArray *)voices;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFinishPosting:(MGVoice *)voice;
@end
