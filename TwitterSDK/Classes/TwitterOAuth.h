//
//  TwitterOAuth.h
//  TwitterSDK
//
//  Created by pisces on 4/16/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OAuthConsumer/OAuthConsumer.h>
#import "OADataFetcherDelegateObject.h"
#import "TwitterApiObject.h"
#import "TwitterUserModel.h"
#import "NSString+TwitterSDK.h"

extern NSInteger const oauthErrorCodeUnknown;
extern NSString * _Nonnull const oauthErrorDomainUnknown;
extern NSString * _Nonnull const twitterApiURLOfRequestToken;
extern NSString * _Nonnull const twitterApiURLOfAuthrize;

typedef void (^TwitterOAuthCompletion)(OAToken * _Nullable token, NSError * _Nullable error);

@interface TwitterOAuth : NSObject
@property (nonatomic, readonly) OAConsumer * _Nullable consumer;
@property (nonatomic, readonly) OAToken * _Nullable accessToken;
@property (nonatomic, readonly) OAToken * _Nullable token;
@property (nonatomic, readonly) TwitterUserModel * _Nullable user;
- (instancetype _Nonnull)initWithConsumer:(OAConsumer * _Nonnull)consumer serviceProviderName:(NSString * _Nullable)provider prefix:(NSString * _Nullable)prefix;
- (void)accessTokenWithVerifier:(NSString * _Nullable)verifier completion:(TwitterOAuthCompletion _Nullable)completion;
- (void)apiCallWithObject:(TwitterApiObject * _Nonnull)object completion:(TwitterApiCompletion _Nullable)completion;
- (void)clear;
- (void)requestTokenWithCompletion:(TwitterOAuthCompletion _Nullable)completion;
- (void)removeInUserDefaultsWithServiceProviderName:(NSString * _Nullable)provider prefix:(NSString * _Nullable)prefix;
- (int)storeInUserDefaultsWithServiceProviderName:(NSString * _Nullable)provider prefix:(NSString * _Nullable)prefix;
@end