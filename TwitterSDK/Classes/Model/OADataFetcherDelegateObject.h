//
//  OADataFetcherDelegateObject.h
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OAuthConsumer/OAuthConsumer.h>
#import "TwitterApiObject.h"

@interface OADataFetcherDelegateObject : NSObject
- (instancetype)initWithCompletion:(TwitterApiCompletion)completion;
- (void)ticket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)ticket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;
@end
