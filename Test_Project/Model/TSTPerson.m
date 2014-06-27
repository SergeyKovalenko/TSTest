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
static NSString *const kEmailKey = @"email";
static NSString *const kModelDictionaryKey = @"modelDictionary";

static NSString *const kTSTPersonErrorDomain = @"TSTPersonErrorDomain";

typedef NS_ENUM(NSInteger, TSTPersonErrorCode) {
    TSTPersonErrorEmailCode
};

@interface TSTPerson ()

@property (nonatomic, strong) NSMutableDictionary *modelDictionary;

@end

@implementation TSTPerson

#pragma mark - NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _modelDictionary = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    }
    return self;
}

- (id)init
{
    return [self initWithDictionary:nil];
}

- (NSUInteger)hash
{
    return self.modelDictionary.hash;
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

    return [self isEqualToPerson:object];

}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.modelDictionary = [coder decodeObjectForKey:kModelDictionaryKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.modelDictionary forKey:kModelDictionaryKey];
}

- (NSString *)description
{
    NSString *personInfo = [NSString stringWithFormat:@"%@", self.modelDictionary];
    return [[super description] stringByAppendingString:personInfo];
}

#pragma mark - Public Methods

- (NSString *)firstName
{
    return [self.modelDictionary objectForKey:kFirstNameKey];
}

- (void)setFirstName:(NSString *)firstName
{
    [self.modelDictionary setObject:firstName forKey:kFirstNameKey];
}

- (NSString *)lastName
{
    return [self.modelDictionary objectForKey:kLastNameKey];
}

- (void)setLastName:(NSString *)lastName
{
    [self.modelDictionary setObject:lastName forKey:kLastNameKey];
}

- (NSDate *)birthDate
{
    return [self.modelDictionary objectForKey:kBirthDateKey];
}

- (void)setBirthDate:(NSDate *)birthDate
{
    [self.modelDictionary setObject:birthDate forKey:kBirthDateKey];
}

- (NSString *)email
{
    return [self.modelDictionary objectForKey:kEmailKey];
}

- (void)setEmail:(NSString *)email
{
    [self.modelDictionary setObject:email forKey:kEmailKey];

}

- (BOOL)isEqualToPerson:(TSTPerson *)object
{
    return [self.modelDictionary isEqualToDictionary:object.modelDictionary];
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@%@%@", self.firstName, self.firstName.length ? @" " : @"", self.lastName];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    TSTPerson *copy = [[[self class] allocWithZone:zone] init];
    [copy.modelDictionary setDictionary:[self.modelDictionary copy]];
    return copy;
}

#pragma mark - Key-Value Observing

+ (NSSet *)keyPathsForValuesAffectingFullName
{
    return [NSSet setWithArray:@[@"firstName", @"lastName"]];
}

#pragma mark - Key-Value Coding

- (BOOL)validateEmail:(inout NSString **)ioValue error:(out NSError **)outError
{
    NSError *error;
    if (outError != NULL) {
        
        NSString *errorString = NSLocalizedString(
                                                  @"A Person's email must be at least three characters long", @"validation: Person, too short name error");
        NSDictionary *userInfoDict = @{NSLocalizedDescriptionKey : errorString};
        error = [[NSError alloc] initWithDomain:kTSTPersonErrorDomain code:TSTPersonErrorEmailCode userInfo:userInfoDict];
    }
    // The email must not be nil
    if ((*ioValue == nil) || [*ioValue length] < 3)
    {
        *outError = error;
        return NO;
    }
    
    NSRange entireRange = NSMakeRange(0, [*ioValue length]);
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
    NSArray *matches = [detector matchesInString:*ioValue options:0 range:entireRange];
    
    // should only a single match
    if ([matches count] != 1)
    {
        *outError = error;
        return NO;
    }
    
    NSTextCheckingResult *result = [matches firstObject];
    
    // result should be a link
    if (result.resultType != NSTextCheckingTypeLink)
    {
        *outError = error;
        return NO;
    }
    
    // result should be a recognized mail address
    if (![result.URL.scheme isEqualToString:@"mailto"])
    {
        *outError = error;
        return NO;
    }
    
    // match must be entire string
    if (!NSEqualRanges(result.range, entireRange))
    {
        *outError = error;
        return NO;
    }
    
    // but should not have the mail URL scheme
    if ([*ioValue hasPrefix:@"mailto:"])
    {
        *outError = error;
        return NO;
    }
    *ioValue = [[*ioValue lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // no complaints, string is valid email address
    return YES;
}
@end





