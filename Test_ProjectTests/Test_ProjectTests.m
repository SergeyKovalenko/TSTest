//
//  Test_ProjectTests.m
//  Test_ProjectTests
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TSTDataProvider.h"
#import "TSTPerson.h"

@interface Test_ProjectTests : XCTestCase

@property (nonatomic, strong) TSTDataProvider *dataProvider;
@property (nonatomic, assign) BOOL didChange;
@property (nonatomic, strong) TSTPerson *testPerson;

@end

@interface Test_ProjectTests () <TSTListener>
@end

@implementation Test_ProjectTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 20; i++)
    {
        TSTPerson *person = [[TSTPerson alloc] init];
        person.firstName = [NSString stringWithFormat:@"Name %d", i];
        [array addObject:person];
    }
    
    self.dataProvider = [[TSTDataProvider alloc] initWithArray:array];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.dataProvider = nil;
}

- (void)testCount
{
    XCTAssertTrue([self.dataProvider count] == 20);
}

- (void)testListenerAdd
{
    self.testPerson = [TSTPerson new];
    self.testPerson.firstName = @"test";
    [self.dataProvider addListener:self];
    [self.dataProvider addObject:self.testPerson ];
    XCTAssertTrue(self.didChange);
}

- (void)testListenerRemove
{
    self.testPerson = [self.dataProvider objectAtIndex:self.dataProvider.count - 1];
    [self.dataProvider addListener:self];
    [self.dataProvider removeObject:self.testPerson];
    XCTAssertTrue(self.didChange);
}

- (void)testSave
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"testcontacts"];
    XCTAssertTrue([self.dataProvider saveToFile:path error:nil]);
    
    TSTDataProvider *data = [[TSTDataProvider alloc] initWithContentOfFile:path];
    for (NSUInteger i = 0; i < data.count; ++i) {
        id obj1 = [data objectAtIndex:i];
        id obj2 = [self.dataProvider objectAtIndex:i];
        XCTAssertEqualObjects(obj1, obj2);
    }
}


- (void)observableObjectWillChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo
{
    self.didChange = YES;
}

- (void)observableObject:(id <TSTObservable>)observable didChangeObject:(id)anObject atIndex:(NSUInteger)index1 forChangeType:(TSTListenerChangeType)type userInfo:(NSMutableDictionary *)userInfo
{
    XCTAssertEqualObjects(anObject, self.testPerson , @"inserted person");
}

- (void)observableObjectDidChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo
{
    self.didChange = YES;
}

@end
