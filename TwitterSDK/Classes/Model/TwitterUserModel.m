//
//  UserModel.m
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "TwitterUserModel.h"

@implementation TwitterUserModel

- (NSString *)user_id {
    return _user_id ? _user_id : @"";
}

- (NSString *)screen_name {
    return _screen_name ? _screen_name : @"";
}

@end
