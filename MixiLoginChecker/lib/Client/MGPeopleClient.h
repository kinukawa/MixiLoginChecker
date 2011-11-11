//
//  MGPeopleClient.h
//  Picxi
//
//  Created by kinukawa on 11/02/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGHttpClient.h"
#import "MGUtil.h"
#import "JSON.h"
#import "MGPeople.h"

@protocol MGPeopleClientDelegate;

@interface MGPeopleClient : NSObject {
@public	
	id <MGPeopleClientDelegate> delegate;
@private
	MGHttpClient * httpClient;	
}

-(void)getMyProfile:(bool)status;
-(void)getFriends:(bool)lastLogin;

@property (nonatomic,assign) id delegate;

@end

@protocol MGPeopleClientDelegate<NSObject>
-(void)mgPeopleClient:(NSURLConnection *)conn didFailWithAPIError:(MGApiError *)error;
-(void)mgPeopleClient:(NSURLConnection *)conn didFailWithError:(NSError*)error;
-(void)mgPeopleClient:(NSURLConnection *)conn didFinishLoading:(id)reply;

//-(void)mgPeopleClient:(NSURLConnection *)conn didFinishGetting:(id)reply;
//-(void)mgPeopleClient:(NSURLConnection *)conn didFinishPosting:(id)reply;
@end
