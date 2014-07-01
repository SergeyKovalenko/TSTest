//
//  TSTDataProvider.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/26/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTDataProvider.h"
//#import "TSTObservable+Protected.h"

static void *TSTDataProviderObserveContext = &TSTDataProviderObserveContext;

@interface TSTDataProvider () // <TSTListener>

@property (nonatomic, strong) NSMutableArray *backingArray;

@end

@implementation TSTDataProvider

#pragma mark - TSTDataProvider Methods

- (instancetype)initWithContentOfFile:(NSString *)filePath
{
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return [self initWithArray:array];
}

- (instancetype)initWithArray:(NSArray *)anArray
{
    self = [super init];
    if (self)
    {
        _backingArray = [NSMutableArray arrayWithArray:anArray];
    }

    return self;
}



- (BOOL)saveToFile:(NSString *)path error:(NSError **)error
{
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:self.backingArray];
    return [saveData writeToFile:path options:NSDataWritingAtomic error:error];
}

#pragma mark - TSTDataProvider Protocol Methods

- (NSUInteger)count
{
    return [self.proxyObjects count];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return self.proxyObjects[index];
}

- (NSUInteger)indexOfObject:(id)anObject
{
    return [self.proxyObjects indexOfObject:anObject];
}

- (void)addObject:(id)anObject
{
    [self.proxyObjects addObject:anObject];
}

- (void)removeObject:(id)anObject
{
    [self.proxyObjects removeObject:anObject];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    [self.proxyObjects insertObject:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [self.proxyObjects removeObjectAtIndex:index];
}

#pragma mark - Key-Value Coding

- (NSUInteger)countOfObjects
{
    return [self.backingArray count];
}

- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes
{
    return [self.backingArray objectsAtIndexes:indexes];
}

- (void)insertObjects:(NSArray *)employeeArray atIndexes:(NSIndexSet *)indexes
{
    [self.backingArray insertObjects:employeeArray atIndexes:indexes];
    
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    [self.backingArray removeObjectsAtIndexes:indexes];
}

- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withEmployees:(NSArray *)employeeArray
{
    [self.backingArray replaceObjectsAtIndexes:indexes withObjects:employeeArray];
}

- (NSMutableArray *)proxyObjects
{
    return [self mutableArrayValueForKey:@"objects"];
}


@end
