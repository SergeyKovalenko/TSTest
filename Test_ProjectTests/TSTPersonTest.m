//
//  TSTPersonTest.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TSTPerson.h"

@interface TSTPersonTest : XCTestCase <TSTListener>

@property (nonatomic, strong) TSTPerson *person;
@property (nonatomic, strong) NSMutableArray *personChangedKeys;

@end

@implementation TSTPersonTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.person = [[TSTPerson alloc] init];
    self.personChangedKeys = [NSMutableArray array];
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

- (void)testObservable
{
    [self.person addListener:self];
    
    self.person.firstName = @"firstName";
    self.person.lastName = @"lastName";
    NSArray *array =  [@[@"firstName",@"firstName", @"lastName",@"lastName"] mutableCopy];
    XCTAssertEqualObjects(self.personChangedKeys, array);
}

- (void)observableObjectWillChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo
{
    XCTAssertEqualObjects(self.person, observable);
    [self.personChangedKeys addObject:userInfo[TSTModelChangedKey]];
}


- (void)observableObjectDidChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo
{
    XCTAssertEqualObjects(self.person, observable);
    [self.personChangedKeys addObject:userInfo[TSTModelChangedKey]];
}

@end
