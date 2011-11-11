//
//  MGVoice.h
//  libMixiGraph
//
//  Created by kinukawa on 11/02/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGCommentClient.h"
#import "MGFeedbackClient.h"
#import "MGComment.h"
#import "MGFeedback.h"

@protocol MGVoiceDelegate;

@interface MGVoice : NSObject {
@public	
	id <MGVoiceDelegate> delegate;

	NSString * postId;			//つぶやきを特定するためのID (Post-ID)
	NSString * createdAt;		//つぶやきが投稿された日時
	NSString * voiceText;			//つぶやきの本文
	NSString * userId;			//つぶやきを投稿したユーザのID
	NSString * userScreeName;	//つぶやきを投稿したユーザのニックネーム
	NSString * userProfileImageUrl;	//つぶやきを投稿したユーザのプロフィール画像のURL
	NSString * userUrl;			//つぶやきを投稿したユーザのプロフィールページのURL
	NSString * replyCount;		//このつぶやきに対してのコメントの件数
	NSString * favoriteCount;	//このつぶやきに対してのイイネ！の件数
	NSString * source;			//このつぶやきがTwitterからmixiボイスに取り込まれたものである場合に、このsourceプロパティが結果に含まれます。プロパティ値は”twitter”となります。
	bool favorited;		//認可ユーザがこのつぶやきに対してすでに”イイネ！”している場合 true。そうでなければ false。
	NSString * photoImageUrl;
	NSString * photoThumbnailUrl;

@private
	MGCommentClient * commentClient;
	MGFeedbackClient * feedbackClient;
}

-(void)getComments;
-(void)getFeedbacks;
-(void)postComment:(NSString *)comment;
-(void)postFeedback;
-(UIImage *)getPhotoThumbnail;
-(UIImage *)getUserProfileImage;
-(UIImage *)getPhotoImage;

@property (nonatomic,assign) id delegate;

@property (nonatomic,retain) NSString * postId;
@property (nonatomic,retain) NSString * createdAt;
@property (nonatomic,retain) NSString * voiceText;
@property (nonatomic,retain) NSString * userId;
@property (nonatomic,retain) NSString * userScreeName;
@property (nonatomic,retain) NSString * userProfileImageUrl;
@property (nonatomic,retain) NSString * userUrl;
@property (nonatomic,retain) NSString * replyCount;
@property (nonatomic,retain) NSString * favoriteCount;
@property (nonatomic,retain) NSString * source;
@property bool favorited;
@property (nonatomic,retain) NSString * photoImageUrl;
@property (nonatomic,retain) NSString * photoThumbnailUrl;

@end

@protocol MGVoiceDelegate<NSObject>
//-(void)mgVoice:(NSURLConnection *)conn didReceiveResponseError:(NSString *)error;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFailWithError:(NSError*)error;
-(void)mgVoice:(NSURLConnection *)conn didFinishGettingComments:(NSArray *)commentArray;
-(void)mgVoice:(NSURLConnection *)conn didFinishPostingComment:(id)reply;
-(void)mgVoice:(NSURLConnection *)conn didFinishGettingFeedbacks:(NSArray *)feedbackArray;
-(void)mgVoice:(NSURLConnection *)conn didFinishPostingFeedback:(id)reply;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFinishPosting:(MGVoice *)voice;
@end
