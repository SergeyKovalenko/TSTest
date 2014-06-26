//
//  TSTPerson.m
//  Test_Project
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTPerson.h"
#import <objc/runtime.h>


@interface TSTPerson () {
    @public
    NSMutableArray *_friends;
    NSMutableArray *_emails;
    NSMutableArray *_phoneNumbers;
}

@property (nonatomic, strong) NSMutableDictionary *modelDictionary;

@end

id getter (TSTPerson *self, SEL _cmd)
{
    return self->_friends;
}

@implementation TSTPerson
@dynamic friends;
@dynamic firstName;
@dynamic lastName;
@dynamic fullName;
@dynamic image;
@dynamic birthDate;

- (id)init {
    self = [super init];
    if (self) {
        _modelDictionary = [NSMutableDictionary dictionary];
        _friends = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Getters / Setters Methods


- (NSString *)description
{
    NSString *personInfo = [NSString stringWithFormat:@"%@ %@ %@", self.firstName, self.lastName, self.birthDate];
    return [[super description] stringByAppendingString:personInfo];
}

#pragma mark - NSCoding Methods

//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.modelDictionary forKey:kModelDictionaryKey];
//
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super init];
//    if (self) {
//        self.modelDictionary = [aDecoder decodeObjectForKey:kModelDictionaryKey];
//    }
//    return self;
//}

#pragma mark - NSCopying Methods

//- (id)copyWithZone:(NSZone *)zone {
//    TSTPerson *copy = [[[self class] allocWithZone:zone] init];
//    copy.modelDictionary = [self.modelDictionary copy];
//    return copy;
//}

#pragma mark - KVC Methods

//- (NSUInteger)countOfFriends {
//    return [_friends count];
//}
//
//- (id)objectInFriendsAtIndex:(NSUInteger)index {
//    return [_friends objectAtIndex:index];
//}
//
//- (void)insertObject:(TSTPerson *)person inFriendsAtIndex:(NSUInteger)index {
//    NSParameterAssert([person isKindOfClass:[TSTPerson class]]);
//    [_friends insertObject:person atIndex:index];
//}
//
//- (void)removeObjectFromFriendsAtIndex:(NSUInteger)index {
//    [_friends removeObjectAtIndex:index];
//}
//
//- (void)replaceObjectInFriendsAtIndex:(NSUInteger)index
//                             withObject:(TSTPerson *)person {
//    NSParameterAssert([person isKindOfClass:[TSTPerson class]]);
//    [_friends replaceObjectAtIndex:index withObject:person];
//}
//
//- (NSMutableArray *)friendsProxy {
//    return [self mutableArrayValueForKey:kBackingFriendsKey];
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    NSString *string = NSStringFromSelector(sel);
//    if ([string isEqualToString:@"friends"]) {
//        class_addMethod([self class], sel, (IMP)getter, "@@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
//
//- (void)addFriend:(TSTPerson *)value {
//    [[self friendsProxy] addObject:value];
//}
//
//- (void)addFriends:(NSArray *)values {
//    [[self friendsProxy] addObjectsFromArray:values];
//}

@end





