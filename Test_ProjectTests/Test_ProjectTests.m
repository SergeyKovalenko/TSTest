//
//  Test_ProjectTests.m
//  Test_ProjectTests
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TSTPerson.h"

@interface Test_ProjectTests : XCTestCase
@property (nonatomic, strong) TSTPerson *person;
@property (nonatomic, strong) NSMutableArray *changes;


@end

@implementation Test_ProjectTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.person = [[TSTPerson alloc] init];
    self.changes = [NSMutableArray array];

    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPersonCopy
{
    TSTPerson *person = [[TSTPerson alloc] init];
    person.firstName = @"Name";

    TSTPerson *copy = [person copy];
    XCTAssertEqualObjects(person.firstName, copy.firstName);
}

- (void)testPersonEqual
{
    TSTPerson *person = [[TSTPerson alloc] init];
    person.firstName = @"Name";
    TSTPerson *person2 = [[TSTPerson alloc] init];
    person2.firstName = @"Name";
    
    XCTAssertEqualObjects(person, person2);
    XCTAssertTrue([person isEqualToPerson:person2]);
}

- (void)testCoding
{
    TSTPerson *person = [[TSTPerson alloc] init];

    person.firstName = @"firstName";
    person.lastName = @"lastName";
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:person];
    TSTPerson *copy = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertEqualObjects(person, copy);
}

- (void)testFullName
{

    self.person.firstName = @"firstName";
    self.person.lastName = @"lastName";
    XCTAssertEqualObjects(self.person.fullName, @"firstName lastName", @"fullName error");
}

- (void)testFullNameObserver
{
    [self.person addObserver:self
                  forKeyPath:@"fullName"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    
    self.person.firstName = @"firstName";
    
    self.person.lastName = @"lastName";
    
    self.person.lastName = @"lastName2";
 
    XCTAssertTrue([[self.changes objectAtIndex:1] isEqualToString:@"firstName lastName"]);
    XCTAssertTrue([[self.changes objectAtIndex:2] isEqualToString:@"firstName lastName2"]);


}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"fullName"]) {
        [self.changes addObject:change[NSKeyValueChangeNewKey]];

    }

}
@end
