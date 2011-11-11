//
//  MGPeople.h
//  Picxi
//
//  Created by kinukawa on 11/02/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MGPeople : NSObject {
	NSString * peopleId;
	NSString * displayName;
	NSString * thumbnailUrl;
	NSString * profileUrl;
	
	NSString * statusPostedTime;
	NSString * statusText;
	int lastLogin;
}
@property (nonatomic,retain) NSString * peopleId;
@property (nonatomic,retain) NSString * displayName;
@property (nonatomic,retain) NSString * thumbnailUrl;
@property (nonatomic,retain) NSString * profileUrl;
@property (nonatomic,retain) NSString * statusPostedTime;
@property (nonatomic,retain) NSString * statusText;
@property (nonatomic) int lastLogin;

@end
