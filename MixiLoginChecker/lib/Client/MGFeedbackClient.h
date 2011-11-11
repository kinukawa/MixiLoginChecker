//
//  MGFeedbackClient.h
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "MGHttpClient.h"
#import "MGUtil.h"
#import "MGFeedback.h"

@protocol MGFeedbackClientDelegate;

@interface MGFeedbackClient : NSObject {
@public	
	id <MGFeedbackClientDelegate> delegate;
@private
	MGHttpClient * httpClient;
	
}

-(void)getFeedbacks:(NSString *)type postId:(NSString *)postId trimUser:(bool)isTrimUser;
-(void)postFeedback:(NSString *)type postId:(NSString *)postId;
-(void)postPhotoFeedback:(NSString *)type
                  userId:(NSString *)userId 
                 albumId:(NSString *)albumId 
             mediaItemId:(NSString *)mediaitemId;
-(void)getPhotoFeedbacks:(NSString *)userId 
                 albumId:(NSString *)albumId 
             mediaItemId:(NSString *)mediaitemId;

@property (nonatomic,assign) id delegate;

@end

@protocol MGFeedbackClientDelegate<NSObject>
-(void)mgFeedbackClient:(NSURLConnection *)conn didFinishGetting:(NSArray *)feedbackArray;
-(void)mgFeedbackClient:(NSURLConnection *)conn didFinishPosting:(id)reply;
-(void)mgFeedbackClient:(NSURLConnection *)conn didReceiveResponseError:(MGApiError *)error;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFailWithError:(NSError*)error;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFinishGetting:(NSArray *)voices;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFinishPosting:(MGVoice *)voice;
@end