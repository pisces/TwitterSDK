//
//  TwitterApiObject.h
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TwitterApiCompletion)(id result, NSError *error);

@interface TwitterApiObject : NSObject
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, copy) TwitterApiCompletion completion;
+ (TwitterApiObject *)objectWithPath:(NSString *)path params:(NSDictionary *)params headers:(NSDictionary *)headers completion:(TwitterApiCompletion)completion;
- (void)clear;
@end
