//
//  MGComment.h
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MGComment : NSObject {
	NSString * commentId;
	NSString * createdAt;
	NSString * commentText;
	NSString * userId;
	NSString * userScreeName;
	NSString * userProfileImageUrl;
	NSString * userUrl;	
}

@property (nonatomic,retain) NSString * commentId;
@property (nonatomic,retain) NSString * createdAt;
@property (nonatomic,retain) NSString * commentText;
@property (nonatomic,retain) NSString * userId;
@property (nonatomic,retain) NSString * userScreeName;
@property (nonatomic,retain) NSString * userProfileImageUrl;
@property (nonatomic,retain) NSString * userUrl;

@end
