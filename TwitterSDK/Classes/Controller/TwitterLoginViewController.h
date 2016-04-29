//
//  TwitterLoginViewController.h
//  TwitterSDK
//
//  Created by pisces on 4/16/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OAuthConsumer/OAuthConsumer.h>

@interface TwitterLoginViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, readonly, getter=isFirstViewAppearence) BOOL firstViewAppearence;
- (instancetype)initWithToken:(OAToken *)token
            callbackURLString:(NSString *)callbackURLString
            redirectURLString:(NSString *)redirectURLString;
- (void)present;
@end
