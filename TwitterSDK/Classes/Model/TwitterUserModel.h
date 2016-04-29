//
//  UserModel.h
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "BaseModel.h"

@interface TwitterUserModel : BaseModel
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *user_id;
@end
