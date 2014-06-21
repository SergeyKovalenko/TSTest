//
//  TSTPerson.m
//  Test_Project
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTPerson.h"

static NSString *const kFirstNameKey = @"firstName";
static NSString *const kLastNameKey = @"lastName";
static NSString *const kBirthDateKey = @"birthDate";

@interface TSTPerson ()

@property (nonatomic, strong) NSMutableDictionary *modelDictionary;

@end

@implementation TSTPerson

- (id)init {
    self = [super init];
    if (self) {
        _modelDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)firstName {
//    return _firstName;
    return [self.modelDictionary objectForKey:kFirstNameKey];
}

- (void)setFirstName:(NSString *)firstName {
//    _firstName = firstName;
    [self.modelDictionary setObject:firstName forKey:kFirstNameKey];
}

- (NSString *)lastName {
//    return _lastName;
    return [self.modelDictionary objectForKey:kLastNameKey];
}

- (void)setLastName:(NSString *)lastName {
//    _lastName = lastName;
    [self.modelDictionary setObject:lastName forKey:kLastNameKey];
}

- (NSDate *)birthDate {
//    return _birthDate;
    return [self.modelDictionary objectForKey:kBirthDateKey];
}

- (void)setBirthDate:(NSDate *)birthDate {
//    _birthDate = birthDate;
    [self.modelDictionary setObject:birthDate forKey:kBirthDateKey];
}

- (NSString *)description
{
    NSString *personInfo = [NSString stringWithFormat:@"%@ %@ %@", self.firstName, self.lastName, self.birthDate];
    
    return [[super description] stringByAppendingString:personInfo];
}

@end





