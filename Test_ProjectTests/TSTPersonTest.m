//
//  TSTPersonTest.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TSTPerson.h"

@interface TSTPersonTest : XCTestCase

@property (nonatomic, strong) TSTPerson *person;
@end

@implementation TSTPersonTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.person = [[TSTPerson alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.person = nil;
}

- (void)testFullName
{
    self.person.firstName = @"firstName";
    self.person.lastName = @"lastName";
    XCTAssertEqualObjects(self.person.fullName, @"firstName lastName", @"fullName error");
}

- (void)testEmail
{
    NSString *email = @"test@test.com";
    NSError *error = nil;

    XCTAssertTrue([[self person] validateEmail:&email error:&error]);
    XCTAssertNil(error);
}

- (void)testEmailError
{
    NSString *email = @"testtest.com";
    NSError *error = nil;

    XCTAssertFalse([[self person] validateEmail:&email error:&error]);
    XCTAssertNotNil(error);
}

- (void)testCopy
{
    self.person.firstName = @"firstName";
    self.person.lastName = @"lastName";
    TSTPerson *copy = [self.person copy];
    
    XCTAssertEqualObjects(self.person.fullName, copy.fullName);
    XCTAssertEqualObjects(self.person, copy);
}

- (void)testCoding
{
    self.person.firstName = @"firstName";
    self.person.lastName = @"lastName";
    TSTPerson *copy = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.person]];
    
    XCTAssertEqualObjects(self.person, copy);
}

@end
