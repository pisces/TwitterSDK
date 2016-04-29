//
//  NSString+TwitterSDK.m
//  TwitterSDK
//
//  Created by pisces on 4/16/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "NSString+TwitterSDK.h"

@implementation NSString (TwitterSDK)

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public getter/setter

- (NSString *)urlEncode {
    CFStringRef str = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) self, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSString *result = [NSString stringWithString:(__bridge NSString *) str];
    CFRelease(str);
    return result;
}

- (NSDictionary *)urlParameters {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *parameters = [self componentsSeparatedByString:@"&"];
    
    for (NSString *parameter in parameters) {
        NSArray *parts = [parameter componentsSeparatedByString:@"="];
        NSString *key = [[parts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([parts count] > 1) {
            id value = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [result setObject:value forKey:key];
        }
    }
    return result;
}

@end
