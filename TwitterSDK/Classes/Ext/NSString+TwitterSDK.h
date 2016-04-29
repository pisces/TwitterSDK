//
//  NSString+TwitterSDK.h
//  TwitterSDK
//
//  Created by pisces on 4/16/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TwitterSDK)
@property (nonatomic, readonly) NSString *urlEncode;
@property (nonatomic, readonly) NSDictionary *urlParameters;
@end
