//
//  TwitterAppCenter.h
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterApiObject.h"
#import "TwitterOAuth.h"
#import "TwitterLoginViewController.h"
#import "NSString+TwitterSDK.h"

@interface TwitterAppCenter : NSObject
@property (nonatomic, readonly) BOOL hasSession;
@property (nonatomic, readonly) TwitterOAuth *oauth;
+ (TwitterAppCenter *)defaultCenter;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (TwitterApiObject *)apiCallWithPath:(NSString *)path params:(NSDictionary *)params completion:(TwitterApiCompletion)completion;
- (void)loginWithCompletion:(TwitterApiCompletion)completion;
- (void)logout;
- (BOOL)matchedURL:(NSURL *)URL;
- (void)setUpWithKey:(NSString *)key
              secret:(NSString *)secret
    callbackURLString:(NSString *)callbackURLString
    rediectURLString:(NSString *)rediectURLString
 serviceProviderName:(NSString *)serviceProviderName
              prefix:(NSString *)prefix;
@end
