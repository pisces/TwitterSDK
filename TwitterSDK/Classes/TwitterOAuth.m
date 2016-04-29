//
//  TwitterOAuth.m
//  TwitterSDK
//
//  Created by pisces on 4/16/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "TwitterOAuth.h"

NSInteger const oauthErrorCodeUnknown = 5001;
NSString *const kTwitterUserModel = @"twitterUserModel";
NSString *const oauthErrorDomainUnknown = @"OAuth error domain unknown.";
NSString *const twitterApiURLOfAccessToken = @"https://api.twitter.com/oauth/access_token";
NSString *const twitterApiURLOfAuthrize = @"https://api.twitter.com/oauth/authenticate";
NSString *const twitterApiURLOfRequestToken = @"https://api.twitter.com/oauth/request_token";

@implementation TwitterOAuth
{
@private
    TwitterOAuthCompletion _completion;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (void)dealloc {
    [self clear];
}

- (instancetype)initWithConsumer:(OAConsumer *)consumer serviceProviderName:(NSString * _Nullable)provider prefix:(NSString * _Nullable)prefix {
    self = [super init];
    
    if (self) {
        _consumer = consumer;
        _accessToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:provider prefix:prefix];
        NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] objectForKey:kTwitterUserModel];
        _user = userDict ? [[TwitterUserModel alloc] initWithDictionary:userDict] : nil;
    }
    
    return self;
}

- (void)accessTokenWithVerifier:(NSString *)verifier completion:(TwitterOAuthCompletion)completion {
    _token.verifier = verifier;
    
    NSURL *URL = [NSURL URLWithString:twitterApiURLOfAccessToken];
    [self requestTokenWithURL:URL
                        Token:_token
                       finish:@selector(accessTokenTicket:didFinishWithData:)
                         fail:@selector(accessTokenTicket:didFailWithError:)
                   completion:completion];
}

- (void)apiCallWithObject:(TwitterApiObject *)object completion:(TwitterApiCompletion)completion {
    NSURL *URL = [NSURL URLWithString:object.path];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:_consumer
                                                                      token:_accessToken
                                                                      realm:nil
                                                          signatureProvider:nil];
    NSMutableArray<OARequestParameter *> *params = [NSMutableArray arrayWithCapacity:object.params.count];
    OADataFetcherDelegateObject *delegate = [[OADataFetcherDelegateObject alloc] initWithCompletion:completion];
    
    for (NSString *key in object.params) {
        [params addObject:[[OARequestParameter alloc] initWithName:key value:object.params[key]]];
    }
    
    [request setParameters:params];
    [[[OADataFetcher alloc] init] fetchDataWithRequest:request
                                              delegate:delegate
                                     didFinishSelector:@selector(ticket:didFinishWithData:)
                                       didFailSelector:@selector(ticket:didFailWithError:)];
}

- (void)clear {
    _completion = nil;
}

- (void)requestTokenWithCompletion:(TwitterOAuthCompletion)completion {
    NSURL *URL = [NSURL URLWithString:twitterApiURLOfRequestToken];
    [self requestTokenWithURL:URL
                        Token:nil
                       finish:@selector(requestTokenTicket:didFinishWithData:)
                         fail:@selector(requestTokenTicket:didFailWithError:)
                   completion:completion];
}

- (void)removeInUserDefaultsWithServiceProviderName:(NSString *)provider prefix:(NSString *)prefix {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTwitterUserModel];
    [OAToken removeFromUserDefaultsWithServiceProviderName:provider prefix:prefix];
    
    _accessToken = nil;
    _user = nil;
}

- (int)storeInUserDefaultsWithServiceProviderName:(NSString *)provider prefix:(NSString *)prefix {
    if (_user) {
        [[NSUserDefaults standardUserDefaults] setObject:_user.dictionary forKey:kTwitterUserModel];
    }
    
    return [_accessToken storeInUserDefaultsWithServiceProviderName:provider prefix:prefix];
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - OADataFetcher delegate

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            _accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
            _user = [[TwitterUserModel alloc] initWithDictionary:responseBody.urlParameters];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self callCompletionWithToken:_accessToken error:nil];
            });
        });
    } else {
        [self callCompletionWithToken:nil error:[NSError errorWithDomain:oauthErrorDomainUnknown code:oauthErrorCodeUnknown userInfo:nil]];
    }
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    [self callCompletionWithToken:nil error:error];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _token = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        
        [self callCompletionWithToken:_token error:nil];
    } else {
        [self callCompletionWithToken:nil error:[NSError errorWithDomain:oauthErrorDomainUnknown code:oauthErrorCodeUnknown userInfo:nil]];
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    [self callCompletionWithToken:nil error:error];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)callCompletionWithToken:(OAToken *)token error:(NSError *)error {
    if (_completion) {
        _completion(token, error);
        _completion = nil;
    }
}

- (void)requestTokenWithURL:(NSURL *)URL Token:(OAToken *)token finish:(SEL)finish fail:(SEL)fail completion:(TwitterOAuthCompletion)completion {
    _completion = completion;
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
                                                                   consumer:_consumer
                                                                      token:token
                                                                      realm:nil
                                                          signatureProvider:nil];
    [request setHTTPMethod:@"POST"];
    [[[OADataFetcher alloc] init] fetchDataWithRequest:request
                                              delegate:self
                                     didFinishSelector:finish
                                       didFailSelector:fail];
}

@end
