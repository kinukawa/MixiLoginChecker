//
//  MGPhoto.m
//  Picxi
//
//  Created by kenji kinukawa on 11/03/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGPhoto.h"


@implementation MGPhoto
@synthesize delegate;
@synthesize albumId;
@synthesize created;
@synthesize photoId;
@synthesize largeImageUrl;
@synthesize mimeType;
@synthesize numComments;
@synthesize numFavorites;
@synthesize thumbnailUrl;
@synthesize photoTitle;
@synthesize photoType;
@synthesize url;
@synthesize viewPageUrl;
@synthesize ownerThumbnailUrl;
@synthesize ownerId;
@synthesize ownerDisplayName;
@synthesize ownerProfileUrl;
//@synthesize ownerThumbnailImage;

-(UIImage *)ownerThumbnailImage
{
    if (ownerThumbnailImage) {
        return ownerThumbnailImage;
        
    }else{
        NSURL * otu =[NSURL URLWithString:ownerThumbnailUrl];
        NSMutableURLRequest* otReq = [[[NSMutableURLRequest alloc] initWithURL:otu] autorelease];
        NSHTTPURLResponse* otRes;
        NSError* otErr;
        NSData * otData = [NSURLConnection sendSynchronousRequest:otReq returningResponse:&otRes error:&otErr];      
        ownerThumbnailImage = [[UIImage alloc] initWithData:otData];
        return ownerThumbnailImage;        
    }
}

- (void)setOwnerThumbnailImage:(UIImage *)oti
{
    ownerThumbnailImage = oti;
    [ownerThumbnailImage retain];
}

-(UIImage *)getPhoto{
	NSURL * photoUrl =[NSURL URLWithString:self.url];
	NSMutableURLRequest* photoReq = [[[NSMutableURLRequest alloc] initWithURL:photoUrl] autorelease];
	NSHTTPURLResponse* photoRes;
	NSError* photoErr;
	NSData * photoData = [NSURLConnection sendSynchronousRequest:photoReq returningResponse:&photoRes error:&photoErr];      
	return [[[UIImage alloc] initWithData:photoData] autorelease];
}

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

//このフォトに、いいねをする
-(void)postFeedback{
    [feedbackClient postPhotoFeedback:@"photo" 
                               userId:self.ownerId 
                              albumId:self.albumId 
                          mediaItemId:photoId];
}

//このフォトに、いいねをする
-(id)getFeedback{
    /*[feedbackClient getPhotoFeedbacks:self.ownerId 
                              albumId:self.albumId 
                          mediaItemId:photoId];*/
    
    NSURL * favUrl = [MGUtil buildAPIURL:@"http://api.mixi-platform.com/" 
								 path:[NSArray arrayWithObjects:
									   @"2",
									   @"photo",
									   @"favorites",
									   @"mediaItems",
									   self.ownerId,
                                       @"@self",
                                       self.albumId,
                                       self.photoId,
									   nil]
								query:nil];

	NSMutableURLRequest* req = [[[NSMutableURLRequest alloc] initWithURL:favUrl] autorelease];
	NSHTTPURLResponse* res;
	NSError* err;
	NSData * favData = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];      
	return [[[UIImage alloc] initWithData:favData] autorelease];
}

-(void)mgFeedbackClient:(NSURLConnection *)conn didFinishGetting:(NSArray *)feedbackArray{
    if([delegate respondsToSelector:@selector(mgPhoto:didFinishGettingFeedbacks:)]){
		[delegate mgPhoto:conn didFinishGettingFeedbacks:feedbackArray];
	}
}

-(void)mgFeedbackClient:(NSURLConnection *)conn didFinishPosting:(id)reply{
    NSString *contents = [[[NSString alloc] initWithData:reply encoding:NSUTF8StringEncoding] autorelease];
	if([delegate respondsToSelector:@selector(mgPhoto:didFinishPostingFeedback:)]){
		[delegate mgPhoto:conn didFinishPostingFeedback:contents];
	}
}

-(void)mgFeedbackClient:(NSURLConnection *)conn didReceiveResponseError:(MGApiError *)error{
    
}

- (void) dealloc {
	[commentClient release];
	[feedbackClient release];
	[super dealloc];
}

@end
