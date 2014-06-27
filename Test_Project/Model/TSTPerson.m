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

static NSString *const kTSTPersonErrorDomain = @"TSTPersonErrorDomain";

typedef NS_ENUM(NSInteger, TSTPersonErrorCode) {
    TSTPersonErrorEmailCode
};

@implementation TSTPerson


- (NSString *)description
{
    NSString *personInfo = [NSString stringWithFormat:@"%@", self.primitiveValues];
    return [[super description] stringByAppendingString:personInfo];
}

#pragma mark - Public Methods

- (NSString *)firstName
{
    return [self primitiveValueForKey:kFirstNameKey];
}

- (void)setFirstName:(NSString *)firstName
{
    [self setPrinmitiveValue:firstName forKey:kFirstNameKey];
}

- (NSString *)lastName
{
    return [self primitiveValueForKey:kLastNameKey];
}

- (void)setLastName:(NSString *)lastName
{
    [self setPrinmitiveValue:lastName forKey:kLastNameKey];
}

- (NSDate *)birthDate
{
    return [self primitiveValueForKey:kBirthDateKey];
}

- (void)setBirthDate:(NSDate *)birthDate
{
    [self setPrinmitiveValue:birthDate forKey:kBirthDateKey];
}

- (NSString *)email
{
    return [self primitiveValueForKey:kEmailKey];
}

- (void)setEmail:(NSString *)email
{
    [self setPrinmitiveValue:email forKey:kEmailKey];
}

- (BOOL)isEqualToPerson:(TSTPerson *)object
{
    return [self.primitiveValues isEqualToDictionary:object.primitiveValues];
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@%@%@", self.firstName, self.firstName.length ? @" " : @"", self.lastName];
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





