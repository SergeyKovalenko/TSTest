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
static NSString *const kPrimitiveDictionaryKey = @"primitiveDictionary";

static NSString *const kTSTPersonErrorDomain = @"TSTPersonErrorDomain";

typedef NS_ENUM(NSInteger, TSTPersonErrorCode) {
    TSTPersonErrorEmailCode
};

@interface TSTPerson ()

@property (nonatomic, strong) NSMutableDictionary *modelDictionary;

@end

@implementation TSTPerson

#pragma mark - NSObject

- (id)init {
    self = [super init];
    if (self) {
        _modelDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)isEqualToPerson:(TSTPerson *)other {
    NSAssert([other isMemberOfClass:[TSTPerson class]], @"class");
    return [self.modelDictionary isEqualToDictionary:other.modelDictionary];
}

- (NSString *)firstName {
    return [self primitiveValueForKey:kFirstNameKey];
}

- (void)setFirstName:(NSString *)firstName {
    [self setPrimitiveValue:[firstName copy] forKey:kFirstNameKey];
}

- (NSString *)lastName {
    return [self primitiveValueForKey:kLastNameKey];
}

- (void)setLastName:(NSString *)lastName {
    [self setPrimitiveValue:[lastName copy] forKey:kLastNameKey];
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@%@%@", self.firstName, self.firstName.length ? @" " : @"", self.lastName];
}

- (NSDate *)birthDate {
    return [self primitiveValueForKey:kBirthDateKey];
}

- (void)setBirthDate:(NSDate *)birthDate {
    [self setPrimitiveValue:birthDate forKey:kBirthDateKey];
}

- (NSString *)email {
    return [self primitiveValueForKey:kEmailKey];
}

- (void)setEmail:(NSString *)email {
    [self setPrimitiveValue:[email copy] forKey:kEmailKey];
}

- (BOOL)validateEmail:(inout NSString **)ioValue error:(out NSError **)outError
{
    void(^setError)(void) = ^ {
        
        if (outError != NULL) {
            
            NSString *errorString = NSLocalizedString(
                                                      @"A Person's email must be at least three characters long", @"validation: Person, too short name error");
            NSDictionary *userInfoDict = @{NSLocalizedDescriptionKey : errorString};
            *outError = [[NSError alloc] initWithDomain:kTSTPersonErrorDomain code:TSTPersonErrorEmailCode userInfo:userInfoDict];
        }
        
    };
    
    // The email must not be nil
    if ((*ioValue == nil) || [*ioValue length] < 3)
    {
        setError();
        return NO;
    }
    
    NSRange entireRange = NSMakeRange(0, [*ioValue length]);
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL];
    NSArray *matches = [detector matchesInString:*ioValue options:0 range:entireRange];
    
    // should only a single match
    if ([matches count] != 1)
    {
        setError();
        return NO;
    }
    
    NSTextCheckingResult *result = [matches firstObject];
    
    // result should be a link
    if (result.resultType != NSTextCheckingTypeLink)
    {
        setError();
        return NO;
    }
    
    // result should be a recognized mail address
    if (![result.URL.scheme isEqualToString:@"mailto"])
    {
        setError();
        return NO;
    }
    
    // match must be entire string
    if (!NSEqualRanges(result.range, entireRange))
    {
        setError();
        return NO;
    }
    
    // but should not have the mail URL scheme
    if ([*ioValue hasPrefix:@"mailto:"])
    {
        setError();
        return NO;
    }
    *ioValue = [[*ioValue lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // no complaints, string is valid email address
    return YES;
}

#pragma mark - Key-Value Observing

+ (NSSet *)keyPathsForValuesAffectingFullName
{
    return [NSSet setWithArray:@[@"firstName", @"lastName"]];
}


@end





