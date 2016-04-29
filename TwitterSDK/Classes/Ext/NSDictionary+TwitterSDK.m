//
//  NSDictionary+TwitterSDK.m
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "NSDictionary+TwitterSDK.h"

@implementation NSDictionary (TwitterSDK)

- (NSString *)urlString {
    NSMutableArray *parts = [NSMutableArray array];
    
    for (id key in self) {
        id value = [self objectForKey:key];
        
        [parts addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    return [parts componentsJoinedByString:@"&"];
}

@end
