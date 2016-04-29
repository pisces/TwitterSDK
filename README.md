# TwitterSDK

[![CI Status](http://img.shields.io/travis/pisces/TwitterSDK.svg?style=flat)](https://travis-ci.org/pisces/TwitterSDK)
[![Version](https://img.shields.io/cocoapods/v/TwitterSDK.svg?style=flat)](http://cocoapods.org/pods/TwitterSDK)
[![License](https://img.shields.io/cocoapods/l/TwitterSDK.svg?style=flat)](http://cocoapods.org/pods/TwitterSDK)
[![Platform](https://img.shields.io/cocoapods/p/TwitterSDK.svg?style=flat)](http://cocoapods.org/pods/TwitterSDK)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Set up
#### AppDelegate
```objc
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
```

#### Info.plist
```objc
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLIconFile</key>
		<string></string>
		<key>CFBundleURLName</key>
		<string>mytwitter</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>twitterSDKDemoApp</string>
		</array>
	</dict>
</array>
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSExceptionDomains</key>
	<dict>
		<key>twimg.com</key>
		<dict>
			<key>NSIncludesSubdomains</key>
			<true/>
			<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
			<true/>
			<key>NSTemporaryExceptionMinimumTLSVersion</key>
			<string>TLSv1.1</string>
		</dict>
		<key>twitter.com</key>
		<dict>
			<key>NSIncludesSubdomains</key>
			<true/>
			<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
			<true/>
			<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
			<false/>
		</dict>
		<key>twittersdkdemoapp.com</key>
		<dict>
			<key>NSIncludesSubdomains</key>
			<true/>
			<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
			<true/>
			<key>NSTemporaryExceptionMinimumTLSVersion</key>
			<string>TLSv1.1</string>
		</dict>
	</dict>
</dict>
```

### Example
```objc
@implementation DemoViewController
{
    __weak IBOutlet UITextView *textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TwitterSDK Demo";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([TwitterAppCenter defaultCenter].hasSession) {
        [self load];
    } else {
        [[TwitterAppCenter defaultCenter] loginWithCompletion:^(id result, NSError *error) {
            if (!error) {
                [self load];
            }
        }];
    }
}

- (void)load {
    NSString *path = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
    NSDictionary *params = @{@"count": @"10",
                             @"user_id": [TwitterAppCenter defaultCenter].oauth.user.user_id,
                             @"screen_name": [TwitterAppCenter defaultCenter].oauth.user.screen_name};
    
    [[TwitterAppCenter defaultCenter] apiCallWithPath:path params:params completion:^(NSDictionary *result, NSError *error) {
        NSLog(@"result -> %@", result);
        textView.text = [NSString stringWithFormat:@"%@", result];
    }];
}

@end
```

## Requirements

iOS Deployment Target 7.0 higher

## Installation

TwitterSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TwitterSDK"
```

## Author

pisces, hh963103@gmail.com

## License

TwitterSDK is available under the MIT license. See the LICENSE file for more info.
