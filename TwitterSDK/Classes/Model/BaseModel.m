//
//  BaseModel.m
//  TwitterSDK
//
//  Created by pisces on 4/17/16.
//  Copyright © 2016 coupang. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

// ================================================================================================
//  Public
// ================================================================================================

#pragma mark - Public methods

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        [self setProperties:dictionary];
    }
    
    return self;
}

- (id)childWithKey:(NSString *)key classType:(Class)classType {
    return [self childWithKey:key classType:classType map:NULL];
}

- (id)childWithKey:(NSString *)key classType:(Class)classType map:(void (^)(BaseModel *result))map {
    id object = _rawDictionary[key];
    BaseModel *model = nil;
    
    if (object && [classType isSubclassOfClass:[BaseModel class]]) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            model = [[classType alloc] initWithDictionary:object];
            
            if (map)
                map(model);
            
            return model;
        }
        
        if ([object isKindOfClass:[NSArray class]]) {
            NSArray *rawArray = (NSArray *)object;
            NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:rawArray.count];
            
            for (id obj in rawArray) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    model = [[classType alloc] initWithDictionary:obj];
                    [resultArray addObject:model];
                    
                    if (map) {
                        map(model);
                    }
                } else if ([obj isKindOfClass:[NSArray class]]) {
                    [resultArray addObject:[self childWithArray:obj classType:classType map:map]];
                }
            }
            
            return resultArray;
        }
        
    }
    return nil;
}

- (id)childWithArray:(NSArray *)array classType:(Class)classType {
    return [self childWithArray:array classType:classType map:NULL];
}

- (id)childWithArray:(NSArray *)array classType:(Class)classType map:(void (^)(BaseModel *model))map {
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:array.count];
    
    if ([classType isSubclassOfClass:[BaseModel class]]) {
        for (id obj in array)
        {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                BaseModel *model = [[classType alloc] initWithDictionary:obj];
                [resultArray addObject:model];
                
                if (map) {
                    map(model);
                }
            } else if ([obj isKindOfClass:[NSArray class]]) {
                [resultArray addObject:[self childWithArray:obj classType:classType map:map]];
            }
        }
    }
    
    return resultArray;
}

- (NSDictionary *)dictionary {
    return [self dictionaryWithExcludes:nil];
}

- (NSDictionary *)dictionaryWithExcludes:(NSArray *)excludes {
    NSDictionary *properties = [self classProperties];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSString *key in properties) {
        if ([key isEqualToString:@"rawDictionary"] ||
            (excludes && [excludes indexOfObject:key] != NSNotFound))
            continue;
        
        id value = [self valueForKey:key];
        if (value && ![value isKindOfClass:[NSNull class]] && ![value isKindOfClass:[NSAttributedString class]])
            [dict setObject:[self unformat:[self dictionaryWithValue:value] forKey:key] forKey:key];
    }
    
    return dict;
}

- (void)setProperties:(NSDictionary *)dictionary {
    _rawDictionary = dictionary;
    
    for (NSString *key in dictionary) {
        @try {
            @autoreleasepool {
                id value = dictionary[key];
                
                if (value && ![value isKindOfClass:[NSNull class]]) {
                    [self setValue:[self format:value forKey:key] forKey:key];
                }
            }
        }
        @catch (NSException *exception) {
            if ([exception.name isEqualToString:NSInvalidArgumentException]) {
                NSNumber *boolVal = [NSNumber numberWithBool:[dictionary[key] boolValue]];
                [self setValue:boolVal forKey:key];
            }
        }
    }
}

// ================================================================================================
//  Protocol Implementation
// ================================================================================================

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self){
        [self setWithCoder:aDecoder];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    for (NSString *key in [self classProperties]) {
        id object = [self valueForKey:key];
        if (object) {
            [aCoder encodeObject:object forKey:key];
        }
    }
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] allocWithZone:zone] init];
    
    if (copy) {
        for (NSString *key in [self classProperties]) {
            id value = [self valueForKey:key];
            
            if (!value)
                continue;
            
            if ([value isKindOfClass:[NSObject class]]) {
                NSObject *object = (NSObject *) value;
                NSObject *copiedObject = object.copy;
                
                if (![object isKindOfClass:[copiedObject class]])
                    [copy setValue:object.mutableCopy forKey:key];
                else
                    [copy setValue:copiedObject forKey:key];
            } else {
                [copy setValue:value forKey:key];
            }
        }
    }
    
    return copy;
}

// ================================================================================================
//  Protected
// ================================================================================================

#pragma mark - Protected methods

- (id)format:(id)value forKey:(NSString *)key {
    id orgValue = [self valueForKey:key];
    
    if ([orgValue isKindOfClass:[NSNumber class]]) {
        if ([value isKindOfClass:[NSNull class]])
            return nil;
        
        NSString *typeString = @([orgValue objCType]);
        
        if ([typeString isEqualToString:@"c"] ||
            [typeString isEqualToString:@"B"])
            return @([value boolValue]);
        
        if ([typeString isEqualToString:@"i"])
            return @([value integerValue]);
        
        if ([typeString isEqualToString:@"s"])
            return @([value shortValue]);
        
        if ([typeString isEqualToString:@"l"])
            return @([value longValue]);
        
        if ([typeString isEqualToString:@"q"])
            return @([value longLongValue]);
        
        if ([typeString isEqualToString:@"I"])
            return @([value unsignedIntegerValue]);
        
        if ([typeString isEqualToString:@"L"])
            return @([value unsignedLongValue]);
        
        if ([typeString isEqualToString:@"Q"])
            return @([value unsignedLongLongValue]);
        
        if ([typeString isEqualToString:@"f"])
            return @([value floatValue]);
        
        if ([typeString isEqualToString:@"d"])
            return @([value doubleValue]);
    }
    
    return value;
}

- (id)unformat:(id)value forKey:(NSString *)key {
    return value;
}

// ================================================================================================
//  Private
// ================================================================================================

#pragma mark - Private class methods

+ (NSDictionary *)classProperties
{
    @synchronized([self class]) {
        static NSMutableDictionary *keysByClass = nil;
        
        if (!keysByClass) {
            keysByClass = [[NSMutableDictionary alloc] init];
        }
        
        NSString *className = NSStringFromClass(self);
        NSMutableDictionary *codableProperties = [keysByClass objectForKey:className];
        
        if (!codableProperties) {
            codableProperties = [NSMutableDictionary dictionary];
            unsigned int propertyCount;
            objc_property_t *properties = class_copyPropertyList(self, &propertyCount);
            
            for (unsigned int i = 0; i < propertyCount; i++) {
                objc_property_t property = properties[i];
                const char *propertyName = property_getName(property);
                NSString *key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
                
                if (![[self uncodableProperties] containsObject:key]) {
                    Class class = nil;
                    char *typeEncoding = property_copyAttributeValue(property, "T");
                    
                    switch (typeEncoding[0]) {
                        case '@':
                            if (strlen(typeEncoding) >= 3) {
                                char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                                NSString *name = [NSString stringWithUTF8String:className];
                                NSRange range = [name rangeOfString:@"<"];
                                if (range.location != NSNotFound)
                                {
                                    name = [name substringToIndex:range.location];
                                }
                                class = NSClassFromString(name) ?: [BaseModel class];
                                free(className);
                            }
                            break;
                        case 'c':
                        case 'i':
                        case 's':
                        case 'l':
                        case 'q':
                        case 'Q':
                        case 'C':
                        case 'I':
                        case 'S':
                        case 'f':
                        case 'd':
                        case 'B':
                            class = [NSNumber class];
                            break;
                        case '{':
                            class = [NSValue class];
                            break;
                    }
                    free(typeEncoding);
                    
                    if (class)
                    {
                        //see if there is a backing ivar
                        char *ivar = property_copyAttributeValue(property, "V");
                        if (ivar)
                        {
                            char *readonly = property_copyAttributeValue(property, "R");
                            if (readonly)
                            {
                                //check if ivar has KVC-compliant name
                                NSString *ivarName = [NSString stringWithFormat:@"%s", ivar];
                                if ([ivarName isEqualToString:key] ||
                                    [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                                {
                                    //no setter, but setValue:forKey: will still work
                                    codableProperties[key] = class;
                                }
                                free(readonly);
                            }
                            else
                            {
                                //there is a setter method so setValue:forKey: will work
                                codableProperties[key] = class;
                            }
                            free(ivar);
                        }
                    }
                }
            }
            free(properties);
            [keysByClass setObject:[NSDictionary dictionaryWithDictionary:codableProperties] forKey:className];
        }
        return codableProperties;
    }
}

+ (NSArray *)uncodableProperties {
    return nil;
}

#pragma mark - Private methods

- (NSDictionary *)classProperties {
    @synchronized([self class]) {
        static NSMutableDictionary *propertiesByClass = nil;
        
        if (propertiesByClass == nil) {
            propertiesByClass = [[NSMutableDictionary alloc] init];
        }
        
        NSString *className = NSStringFromClass([self class]);
        NSDictionary *codableProperties = propertiesByClass[className];
        
        if (!codableProperties) {
            NSMutableDictionary *properties = [NSMutableDictionary dictionary];
            Class class = [self class];
            
            while (class != [BaseModel class]) {
                [properties addEntriesFromDictionary:[class classProperties]];
                class = [class superclass];
            }
            codableProperties = [properties copy];
            [propertiesByClass setObject:codableProperties forKey:className];
        }
        return codableProperties;
    }
}

- (id)dictionaryWithValue:(id)value {
    if ([value isKindOfClass:[BaseModel class]])
        return ((BaseModel *) value).dictionary;
    
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray *rawArray = (NSArray *) value;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:rawArray.count];
        
        for (id object in rawArray)
            [array addObject:[self dictionaryWithValue:object]];
        
        return array;
    }
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *rawDict = (NSDictionary *) value;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:rawDict.count];
        
        for (NSString *key in rawDict)
            [dict setObject:[self dictionaryWithValue:[rawDict valueForKey:key]] forKey:key];
        
        return dict;
    }
    
    return value;
}

- (void)setWithCoder:(NSCoder *)aDecoder {
    BOOL secureAvailable = [aDecoder respondsToSelector:@selector(decodeObjectOfClass:forKey:)];
    BOOL secureSupported = [[self class] supportsSecureCoding];
    NSDictionary *properties = [self classProperties];
    
    for (NSString *key in properties) {
        id object = nil;
        Class class = properties[key];
        
        if (secureAvailable && secureSupported) {
            object = [aDecoder decodeObjectOfClass:class forKey:key];
        } else {
            object = [aDecoder decodeObjectForKey:key];
        }
        
        if (object) {
            if ([object isKindOfClass:[NSNull class]]) {
                [self setValue:[NSNull null] forKey:key];
            } else if ([object isKindOfClass:class]) {
                [self setValue:object forKey:key];
            }
        }
    }
}

@end
