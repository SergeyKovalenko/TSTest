//
//  TSTPersonDescriptionFormatter.m
//  Test_Project
//
//  Created by Yury Grinenko on 21.06.14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTPersonDescriptionFormatter.h"
#import "TSTPerson.h"

@interface TSTPersonDescriptionFormatter ()

@property (nonatomic, strong) NSDateFormatter *birthDateForatter;

@end

@implementation TSTPersonDescriptionFormatter

- (id)init {
    self = [super init];
    if (self) {
        _birthDateForatter = [[NSDateFormatter alloc] init];
        [_birthDateForatter setDateFormat:@"dd MMMM yyyy"];
    }
    return self;
}

- (NSString *)descriptionStringFromPerson:(TSTPerson *)person {
    NSString *birthDateString = [self.birthDateForatter stringFromDate:person.birthDate];
    NSString *personInfo = [NSString stringWithFormat:@"%@ %@ %@", person.firstName, person.lastName, birthDateString];
    
    return personInfo;
}

@end
