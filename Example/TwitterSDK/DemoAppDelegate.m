//
//  DemoAppDelegate.m
//  TwitterSDK
//
//  Created by pisces on 04/29/2016.
//  Copyright (c) 2016 pisces. All rights reserved.
//

#import "DemoAppDelegate.h"
#import <TwitterSDK/TwitterSDK.h>

NSString *const twitterConsumerkey = @"Your Consumer Key for Twitter API";
NSString *const twitterConsumerSecret = @"Your Consumer Secret for Twitter API";
NSString *const twitterOAuthCallbackURL = @"http://yourSiteDomain/oauth_callback";
NSString *const twitterRedirectURLString = @"yourAppScheme://authorize_complete";
NSString *const twitterServiceProviderName = @"yourServiceProviderName"; //ex twitterSDKDemoApp
NSString *const twitterPrefix = @"yourSiteDomain"; //ex twittersdkdemoapp.com

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
