//
//  MGDiaryClient.h
//  libMixiGraph
//
//  Created by kenji kinukawa on 11/02/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGHttpClient.h"
#import "MGUtil.h"

@protocol MGDiaryClientDelegate;

@interface MGDiaryClient : NSObject {
@public	
	id <MGDiaryClientDelegate> delegate;
@private
	MGHttpClient * httpClient;
}

-(void)postDiary:(NSString*)title body:(NSString*)body;
-(void)postDiaryWithPhoto:(NSString*)title 
					 body:(NSString*)body 
					photo:(UIImage *)photo;

@property (nonatomic,assign) id delegate;

@end

@protocol MGDiaryClientDelegate<NSObject>
@end
