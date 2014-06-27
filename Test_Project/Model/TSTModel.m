//
//  TSTModel.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTModel.h"
#import "TSTObservable+Protected.h"

static NSString *const kPrimitiveDictionaryKey = @"primitiveDictionary";
NSString *const TSTModelChangedKey = @"TSTModelChangedKey";

@interface TSTModel ()

@property (nonatomic, strong) NSMutableDictionary *primitiveDictionary;
@end

@implementation TSTModel

#pragma mark - TSTModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _primitiveDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    return self;
}

- (id)init
{
    return [self initWithDictionary:nil];
}

- (NSDictionary *)primitiveValues
{
    return self.primitiveDictionary;
}

- (id)primitiveValueForKey:(id)key
{
    return [self.primitiveDictionary objectForKey:key];
}

- (void)setPrinmitiveValue:(id <NSCoding>)value forKey:(NSString *)key
{
    [self willChangeValueForKey:key];
    [self.primitiveDictionary setObject:value forKey:key];
    [self didChangeValueForKey:key];

}

#pragma mark - Key-Value Observing

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    return NO;
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return self.primitiveValues.hash;
}

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if ([self class] != [object class])
    {
        return NO;
    }

    TSTModel *otherModel = object;
    return [self.primitiveDictionary isEqualToDictionary:otherModel.primitiveDictionary];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder
{
    return [self initWithDictionary:[coder decodeObjectForKey:kPrimitiveDictionaryKey]];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.primitiveDictionary forKey:kPrimitiveDictionaryKey];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithDictionary:self.primitiveDictionary];
}

#pragma mark - TSTObservable

- (void)willChangeValueForKey:(NSString *)key
{
    [super willChangeValueForKey:key];
    [self notifyWillChangeContent:[@{TSTModelChangedKey : key} mutableCopy]];
}

- (void)didChangeValueForKey:(NSString *)key
{
    [super didChangeValueForKey:key];
    [self notifyDidChangeContent:[@{TSTModelChangedKey : key} mutableCopy]];



}

@end
