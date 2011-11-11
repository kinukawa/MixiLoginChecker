//
//  MGVoice.m
//  libMixiGraph
//
//  Created by kinukawa on 11/02/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGVoice.h"


@implementation MGVoice

@synthesize delegate;

@synthesize postId;
@synthesize createdAt;
@synthesize voiceText;
@synthesize userId;
@synthesize userScreeName;
@synthesize userProfileImageUrl;
@synthesize userUrl;
@synthesize replyCount;
@synthesize favoriteCount;
@synthesize source;
@synthesize favorited;
@synthesize photoImageUrl;
@synthesize photoThumbnailUrl;

-(id)init{
	if((self = [super init])){
		//initialize
		commentClient = [[MGCommentClient alloc] init];
		feedbackClient = [[MGFeedbackClient alloc] init];
		
		commentClient.delegate = self;
		feedbackClient.delegate = self;
	}
	return self;
}


-(void)getComments{
	[commentClient getComments:@"voice" postId:self.postId trimUser:0];
}

-(void)mgCommentClient:(NSURLConnection *)conn didFinishGetting:(NSArray *)commentArray{
	if([delegate respondsToSelector:@selector(mgVoice:didFinishGettingComments:)]){
		[delegate mgVoice:conn didFinishGettingComments:commentArray];
	}

	/*
	for(MGComment * comment in commentArray){
		NSLog(@"===============");
		NSLog(@"%@",comment.commentId);
		NSLog(@"%@",comment.createdAt);
		NSLog(@"%@",comment.commentText);
		NSLog(@"%@",comment.userId);
		NSLog(@"%@",comment.userScreeName);
		NSLog(@"%@",comment.userProfileImageUrl);
		NSLog(@"%@",comment.userUrl);
		NSLog(@"===============");
	}*/
}

-(void)postComment:(NSString *)comment{
	[commentClient postComment:@"voice" postId:self.postId comment:comment];
}

-(void)mgCommentClient:(NSURLConnection *)conn didFinishPosting:(id)reply{
	NSString *contents = [[[NSString alloc] initWithData:reply encoding:NSUTF8StringEncoding] autorelease];
	if([delegate respondsToSelector:@selector(mgVoice:didFinishPostingComment:)]){
		[delegate mgVoice:conn didFinishPostingComment:contents];
	}
	
	/*
	 for(MGComment * comment in commentArray){
	 NSLog(@"===============");
	 NSLog(@"%@",comment.commentId);
	 NSLog(@"%@",comment.createdAt);
	 NSLog(@"%@",comment.commentText);
	 NSLog(@"%@",comment.userId);
	 NSLog(@"%@",comment.userScreeName);
	 NSLog(@"%@",comment.userProfileImageUrl);
	 NSLog(@"%@",comment.userUrl);
	 NSLog(@"===============");
	 }*/
}

-(void)getFeedbacks{
	[feedbackClient getFeedbacks:@"voice" postId:self.postId trimUser:0];
}

-(void)mgFeedbackClient:(NSURLConnection *)conn didFinishGetting:(NSArray *)feedbackArray{
	/*for(MGFeedback * feedback in feedbackArray){
		NSLog(@"===============");
		NSLog(@"%@",feedback.userId);
		NSLog(@"%@",feedback.userScreeName);
		NSLog(@"%@",feedback.userProfileImageUrl);
		NSLog(@"%@",feedback.userUrl);
		NSLog(@"===============");
	}*/
	if([delegate respondsToSelector:@selector(mgVoice:didFinishGettingFeedbacks:)]){
		[delegate mgVoice:conn didFinishGettingFeedbacks:feedbackArray];
	}
}

-(void)postFeedback{
	[feedbackClient postFeedback:@"voice" postId:self.postId];
}

-(void)mgFeedbackClient:(NSURLConnection *)conn didFinishPosting:(id)reply{
	NSString *contents = [[[NSString alloc] initWithData:reply encoding:NSUTF8StringEncoding] autorelease];
	if([delegate respondsToSelector:@selector(mgVoice:didFinishPostingFeedback:)]){
		[delegate mgVoice:conn didFinishPostingFeedback:contents];
	}
	
	/*
	 for(MGComment * comment in commentArray){
	 NSLog(@"===============");
	 NSLog(@"%@",comment.commentId);
	 NSLog(@"%@",comment.createdAt);
	 NSLog(@"%@",comment.commentText);
	 NSLog(@"%@",comment.userId);
	 NSLog(@"%@",comment.userScreeName);
	 NSLog(@"%@",comment.userProfileImageUrl);
	 NSLog(@"%@",comment.userUrl);
	 NSLog(@"===============");
	 }*/
}

-(UIImage *)getPhotoImage{
    NSURL * imageUrl =[NSURL URLWithString:self.photoImageUrl];
    NSMutableURLRequest* imageReq = [[[NSMutableURLRequest alloc] initWithURL:imageUrl] autorelease];
    NSHTTPURLResponse* imageRes;
    NSError* imageError;
    NSData * imageData = [NSURLConnection sendSynchronousRequest:imageReq returningResponse:&imageRes error:&imageError];      
    return [[[UIImage alloc] initWithData:imageData] autorelease];
}

-(UIImage *)getPhotoThumbnail{
    NSURL * thumbUrl =[NSURL URLWithString:self.photoThumbnailUrl];
    NSMutableURLRequest* thumbReq = [[[NSMutableURLRequest alloc] initWithURL:thumbUrl] autorelease];
    NSHTTPURLResponse* thumbRes;
    NSError* thumbError;
    NSData * thumbData = [NSURLConnection sendSynchronousRequest:thumbReq returningResponse:&thumbRes error:&thumbError];      
    return [[[UIImage alloc] initWithData:thumbData] autorelease];
}

-(UIImage *)getUserProfileImage{
    NSURL * thumbUrl =[NSURL URLWithString:self.userProfileImageUrl];
    NSMutableURLRequest* thumbReq = [[[NSMutableURLRequest alloc] initWithURL:thumbUrl] autorelease];
    NSHTTPURLResponse* thumbRes;
    NSError* thumbError;
    NSData * thumbData = [NSURLConnection sendSynchronousRequest:thumbReq returningResponse:&thumbRes error:&thumbError];      
    return [[[UIImage alloc] initWithData:thumbData] autorelease];
}

- (void) dealloc {
	[commentClient release];
	[feedbackClient release];
	[super dealloc];
}

@end
