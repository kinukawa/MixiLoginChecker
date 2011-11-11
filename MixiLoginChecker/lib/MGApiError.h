//
//  MGApiError.h
//  libMixiGraph
//
//  Created by kinukawa on 11/03/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    MGApiErrorTypeInvalidRequest,
    MGApiErrorTypeInvalidToken,
    MGApiErrorTypeExpiredToken,
    MGApiErrorTypeInsufficientScope,
    MGApiErrorTypeInvalidGrant,
    MGApiErrorTypeOther,
};

typedef NSUInteger MGApiErrorType;

@interface MGApiError : NSObject {
	MGApiErrorType errorType;
    NSHTTPURLResponse *response;
}

@property(nonatomic) MGApiErrorType errorType;
@property(nonatomic,retain) NSHTTPURLResponse *response;
@end
