//
//  TwitterAppCenter.m
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "TwitterAppCenter.h"

NSTimeInterval const kExecutionDelayTimeInterval = 0.1;

@interface TwitterAppCenter ()
@property (nonatomic, readonly) NSString *callbackURLString;
@property (nonatomic, readonly) NSString *rediectURLString;
@property (nonatomic, readonly) NSString *prefix;
@property (nonatomic, readonly) NSString *serviceProviderName;
@end

@implementation TwitterAppCenter
{
@private
    NSTimer *executionDelayTimer;
    NSMutableArray<TwitterApiObject *> *apiObjectQueue;
    TwitterLoginViewController *loginViewController;
    TwitterApiCompletion loginCompletion;
}

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public class methods

+ (TwitterAppCenter *)defaultCenter {
    static TwitterAppCenter *instance;
    static dispatch_once_t precate;
    
    dispatch_once(&precate, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

#pragma mark - Public getter/setter

- (BOOL)hasSession {
    return _oauth.accessToken != nil;
}

#pragma mark - Public methods

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.absoluteString hasPrefix:_rediectURLString]) {
        NSString *verifier = url.query.urlParameters[@"oauth_verifier"];
        
        if (verifier) {
            [_oauth accessTokenWithVerifier:verifier completion:^(OAToken * _Nullable token, NSError * _Nullable error) {
                if (self.hasSession) {
                    [_oauth storeInUserDefaultsWithServiceProviderName:_serviceProviderName prefix:_prefix];
                    
                    if (loginViewController) {
                        [loginViewController dismissViewControllerAnimated:YES completion:nil];
                        loginViewController = nil;
                    }
                    
                    if (loginCompletion)
                        loginCompletion(token, error);
                    
                    [self dequeue];
                }
            }];
        }
        return YES;
    }
    
    return NO;
}

- (id)init {
    self = [super init];
    
    if (self) {
        apiObjectQueue = [NSMutableArray array];
    }
    
    return self;
}

- (TwitterApiObject *)apiCallWithPath:(NSString *)path params:(NSDictionary *)params completion:(TwitterApiCompletion)completion {
    TwitterApiObject *object = [TwitterApiObject objectWithPath:path params:params headers:nil completion:completion];
    [self enqueueWithObject:object];
    [self dequeue];
    return object;
}

- (void)loginWithCompletion:(TwitterApiCompletion)completion {
    if (self.hasSession)
        return;
    
    [_oauth requestTokenWithCompletion:^(OAToken * _Nullable token, NSError * _Nullable error) {
        if (token) {
            loginCompletion = completion;
            loginViewController = [[TwitterLoginViewController alloc] initWithToken:token callbackURLString:_callbackURLString redirectURLString:_rediectURLString];
            
            [loginViewController present];
        }
    }];
}

- (void)logout {
    if (self.hasSession) {
        [_oauth removeInUserDefaultsWithServiceProviderName:_serviceProviderName prefix:_prefix];
        [executionDelayTimer invalidate];
        
        executionDelayTimer = nil;
        apiObjectQueue = nil;
    }
}

- (BOOL)matchedURL:(NSURL *)URL {
    return [URL.absoluteString hasPrefix:_rediectURLString];
}

- (void)setUpWithKey:(NSString *)key
              secret:(NSString *)secret
   callbackURLString:(NSString *)callbackURLString
    rediectURLString:(NSString *)rediectURLString
 serviceProviderName:(NSString *)serviceProviderName
              prefix:(NSString *)prefix {
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:key secret:secret];
    _callbackURLString = callbackURLString;
    _rediectURLString = rediectURLString;
    _prefix = prefix;
    _serviceProviderName = serviceProviderName;
    _oauth = [[TwitterOAuth alloc] initWithConsumer:consumer serviceProviderName:_serviceProviderName prefix:prefix];
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private methods

- (void)dequeue {
    if (apiObjectQueue.count < 1 || executionDelayTimer)
        return;
    
    TwitterApiObject *object = apiObjectQueue.firstObject;
    
    void(^errorState)(NSError *) = ^void(NSError *error) {
        if (object.completion)
            object.completion(nil, error);
        
        [object clear];
    };
    
    if (self.hasSession) {
        [self executeWithObject:object];
    } else {
        [self loginWithCompletion:^(id result, NSError *error) {
            if (result) {
                [self executeWithObject:object];
            } else {
                errorState(error);
            }
        }];
    }
}

- (void)enqueueWithObject:(TwitterApiObject *)object {
    if (![apiObjectQueue containsObject:object]) {
        [apiObjectQueue addObject:object];
    }
}

- (void)executeWithObject:(TwitterApiObject *)object {
    if (!object)
        return;
    
    [apiObjectQueue removeObjectAtIndex:0];
    
    [_oauth apiCallWithObject:object completion:^(id result, NSError *error) {
        @try {
            object.completion([NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil], error);
            [object clear];
        }
        @catch (NSException *exception) {
            object.completion(nil, [NSError errorWithDomain:exception.reason code:0 userInfo:nil]);
            [object clear];
        }
    }];
    
    executionDelayTimer = [NSTimer scheduledTimerWithTimeInterval:kExecutionDelayTimeInterval target:self selector:@selector(timerComplete) userInfo:nil repeats:NO];
}

- (void)timerComplete {
    [executionDelayTimer invalidate];
    executionDelayTimer = nil;
    [self dequeue];
}

@end