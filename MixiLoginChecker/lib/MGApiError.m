//
//  MGApiError.m
//  libMixiGraph
//
//  Created by kinukawa on 11/03/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MGApiError.h"


@implementation MGApiError
@synthesize errorType;
@synthesize response;
- (void) dealloc {
	//self.errorType = nil;
    self.response = nil;
	[super dealloc];
}
@end
