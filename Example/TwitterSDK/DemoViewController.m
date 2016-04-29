//
//  DemoViewController.m
//  TwitterSDK
//
//  Created by pisces on 04/29/2016.
//  Copyright (c) 2016 pisces. All rights reserved.
//

#import "DemoViewController.h"
#import <TwitterSDK/TwitterSDK.h>

@interface DemoViewController ()

@end

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