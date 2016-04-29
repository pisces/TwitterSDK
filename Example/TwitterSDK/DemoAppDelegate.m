//
//  DemoAppDelegate.m
//  TwitterSDK
//
//  Created by pisces on 04/29/2016.
//  Copyright (c) 2016 pisces. All rights reserved.
//

#import "DemoAppDelegate.h"
#import <TwitterSDK/TwitterSDK.h>

NSString *const twitterConsumerkey = @"9MhNCyIMMZFP3G6XwByYNlY3Y";
NSString *const twitterConsumerSecret = @"Pl30RmdAEJSLp5W3nKtD2XWnb3ORKVEFVLow8gm3yqkEi1XOYH";
NSString *const twitterOAuthCallbackURL = @"http://www.twittersdkdemoapp.com/oauth_callback";
NSString *const twitterRedirectURLString = @"twitterSDKDemoApp://authorize_complete";
NSString *const twitterServiceProviderName = @"twitterSDKDemoApp";
NSString *const twitterPrefix = @"twittersdkdemoapp.com";

@implementation DemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[TwitterAppCenter defaultCenter] setUpWithKey:twitterConsumerkey
                                            secret:twitterConsumerSecret
                                 callbackURLString:twitterOAuthCallbackURL
                                  rediectURLString:twitterRedirectURLString
                               serviceProviderName:twitterServiceProviderName
                                            prefix:twitterPrefix];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[TwitterAppCenter defaultCenter] matchedURL:url])
        return [[TwitterAppCenter defaultCenter] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return YES;
}

@end
