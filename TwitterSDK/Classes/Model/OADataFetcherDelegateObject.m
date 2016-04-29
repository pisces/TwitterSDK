//
//  OADataFetcherDelegateObject.m
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "OADataFetcherDelegateObject.h"

@implementation OADataFetcherDelegateObject
{
@private
    TwitterApiCompletion _completion;
}

- (instancetype)initWithCompletion:(TwitterApiCompletion)completion {
    self = [super init];
    
    if (self) {
        _completion = completion;
    }
    
    return self;
}

- (void)ticket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    [self callCompletionWithData:data error:nil];
}

- (void)ticket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    [self callCompletionWithData:nil error:error];
}

- (void)callCompletionWithData:(NSData *)data error:(NSError *)error {
    if (_completion) {
        _completion(data, error);
        _completion = nil;
    }
}

@end
