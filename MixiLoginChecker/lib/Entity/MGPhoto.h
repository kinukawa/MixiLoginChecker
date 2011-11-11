//
//  MGPhoto.h
//  Picxi
//
//  Created by kenji kinukawa on 11/03/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MGCommentClient.h"
#import "MGFeedbackClient.h"
#import "MGComment.h"
#import "MGFeedback.h"

@protocol MGPhotoDelegate;

@interface MGPhoto : NSObject {
    id <MGPhotoDelegate> delegate;
	NSString * albumId;
	NSString * created;
	NSString * photoId;
	NSString * largeImageUrl;
	NSString * mimeType;
	NSString * numComments;
	NSString * numFavorites;
	NSString * thumbnailUrl;
	NSString * photoTitle;
	NSString * photoType;
	NSString * url;
	NSString * viewPageUrl;
	NSString * ownerThumbnailUrl;
	NSString * ownerId;
	NSString * ownerDisplayName;
	NSString * ownerProfileUrl;
    UIImage * ownerThumbnailImage;
@private
	MGCommentClient * commentClient;
	MGFeedbackClient * feedbackClient;

}
-(UIImage *)getPhoto;
-(void)postFeedback;
-(id)getFeedback;

@property (nonatomic,assign) id delegate;

@property (nonatomic,retain) NSString * albumId;
@property (nonatomic,retain) NSString * created;
@property (nonatomic,retain) NSString * photoId;
@property (nonatomic,retain) NSString * largeImageUrl;
@property (nonatomic,retain) NSString * mimeType;
@property (nonatomic,retain) NSString * numComments;
@property (nonatomic,retain) NSString * numFavorites;
@property (nonatomic,retain) NSString * thumbnailUrl;
@property (nonatomic,retain) NSString * photoTitle;
@property (nonatomic,retain) NSString * photoType;
@property (nonatomic,retain) NSString * url;
@property (nonatomic,retain) NSString * viewPageUrl;
@property (nonatomic,retain) NSString * ownerThumbnailUrl;
@property (nonatomic,retain) NSString * ownerId;
@property (nonatomic,retain) NSString * ownerDisplayName;
@property (nonatomic,retain) NSString * ownerProfileUrl;
@property (nonatomic,retain) UIImage * ownerThumbnailImage;

@end

@protocol MGPhotoDelegate<NSObject>
//-(void)mgVoice:(NSURLConnection *)conn didReceiveResponseError:(NSString *)error;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFailWithError:(NSError*)error;
-(void)mgPhoto:(NSURLConnection *)conn didFinishGettingComments:(NSArray *)commentArray;
-(void)mgPhoto:(NSURLConnection *)conn didFinishPostingComment:(id)reply;
-(void)mgPhoto:(NSURLConnection *)conn didFinishGettingFeedbacks:(NSArray *)feedbackArray;
-(void)mgPhoto:(NSURLConnection *)conn didFinishPostingFeedback:(id)reply;
//-(void)mgVoiceClient:(NSURLConnection *)conn didFinishPosting:(MGVoice *)voice;
@end
