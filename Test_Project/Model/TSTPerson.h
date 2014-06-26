//
//  TSTPerson.h
//  Test_Project
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSTModel.h"

@interface TSTPerson : TSTModel <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDate *birthDate;

@property (nonatomic, strong, readonly) NSArray* friends;
//@property (nonatomic, strong, readonly) NSArray* emails;
//@property (nonatomic, strong, readonly) NSArray* phoneNumbers;

- (void)addFriend:(TSTPerson *)value;
- (void)removeFriend:(TSTPerson *)value;
- (void)addFriends:(NSArray *)values;
- (void)removeFriends:(NSArray *)values;

@end
