//
//  TSTPerson.m
//  Test_Project
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTPerson.h"

@implementation TSTPerson

- (NSString *)description
{
    NSString *personInfo = [NSString stringWithFormat:@"%@ %@ %@", self.firstName, self.lastName, self.birthDate];
    
    return [[super description] stringByAppendingString:personInfo];
}

@end
