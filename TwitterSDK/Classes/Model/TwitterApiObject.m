//
//  TwitterApiObject.m
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "TwitterApiObject.h"

@implementation TwitterApiObject

+ (TwitterApiObject *)objectWithPath:(NSString *)path params:(NSDictionary *)params headers:(NSDictionary *)headers completion:(TwitterApiCompletion)completion {
    TwitterApiObject *object = [[TwitterApiObject alloc] init];
    object.path = path;
    object.params = params;
    object.headers = headers;
    object.completion = completion;
    return object;
}

- (void)dealloc {
    [self clear];
}

- (void)clear {
    _path = nil;
    _params = nil;
    _headers = nil;
    _completion = NULL;
}

@end