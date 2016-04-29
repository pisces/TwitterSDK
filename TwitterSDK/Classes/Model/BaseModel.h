//
//  BaseModel.h
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseModelProtected <NSObject>
- (id)format:(id)value forKey:(NSString *)key;
- (id)unformat:(id)value forKey:(NSString *)key;
@end

@interface BaseModel : NSObject <NSCoding, NSSecureCoding, NSCopying, BaseModelProtected>
@property (nonatomic, readonly) NSDictionary *rawDictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (id)childWithKey:(NSString *)key classType:(Class)classType;
- (id)childWithKey:(NSString *)key classType:(Class)classType map:(void (^)(BaseModel *result))map;
- (id)childWithArray:(NSArray *)array classType:(Class)classType;
- (id)childWithArray:(NSArray *)array classType:(Class)classType map:(void (^)(BaseModel *model))map;
- (NSDictionary *)dictionary;
- (NSDictionary *)dictionaryWithExcludes:(NSArray *)excludes;
- (void)setProperties:(NSDictionary *)dictionary;
@end
