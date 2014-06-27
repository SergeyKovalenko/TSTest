//
//  TSTModel.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTModel.h"

@interface TSTModel ()

@property (nonatomic, strong) NSMutableDictionary *primitiveDictionary;
@end

@implementation TSTModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _primitiveDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    return self;
}

- (NSDictionary *)primitiveValues
{
    return [self.primitiveDictionary copy];
}

- (id)primitiveValueForKey:(id)key
{
    return [self.primitiveDictionary objectForKey:key];
}

- (void)setPrinmitiveValue:(id <NSCoding>)value forKey:(id <NSCopying, NSObject>)key
{
    [self willChangeValueForKey:[key description]];
    [self.primitiveDictionary setObject:value forKey:key];
    [self didChangeValueForKey:[key description]];

}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    return NO;
}

@end
