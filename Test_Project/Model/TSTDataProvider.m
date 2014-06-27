//
//  TSTDataProvider.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/26/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTDataProvider.h"
#import "TSTObservable+Protected.h"

static void *TSTDataProviderObserveContext = &TSTDataProviderObserveContext;

@interface TSTDataProvider ()

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

- (void)dealloc {
    if (self.listeners.count) {
        [self removeObserver:self forKeyPath:@"objects" context:TSTDataProviderObserveContext];
    }
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

#pragma mark - TSTListener

- (void)addListener:(id <TSTListener>)listener
{
    [super addListener:listener];
    if ([self.listeners count] == 1)
    {
        [self addObserver:self forKeyPath:@"objects" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior
        context:TSTDataProviderObserveContext];
    }
}

- (void)removeListener:(id <TSTListener>)listener
{
    [super removeListener:listener];
    if ([self.listeners count] == 0)
    {
        [self removeObserver:self forKeyPath:@"objects" context:TSTDataProviderObserveContext];
    }
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == TSTDataProviderObserveContext && [keyPath isEqualToString:@"objects"])
    {
        NSNumber *isPriorNotification = change[NSKeyValueChangeNotificationIsPriorKey];
        if (isPriorNotification.boolValue)
        {
            [self notifyWillChangeContent:[change mutableCopy]];
        }
        else
        {
            NSKeyValueChange changeKind = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
            TSTListenerChangeType type = TSTListenerChangeTypeInsert;
            NSArray *objects;
            switch (changeKind)
            {
                case NSKeyValueChangeRemoval:
                case NSKeyValueChangeReplacement:
                    type = TSTListenerChangeTypeDelete;
                    objects = change[NSKeyValueChangeOldKey];
                    break;
                case NSKeyValueChangeInsertion:
                case NSKeyValueChangeSetting:
                    type = TSTListenerChangeTypeInsert;
                    objects = change[NSKeyValueChangeNewKey];
                    break;
            }
            
            NSIndexSet *indexes = change[NSKeyValueChangeIndexesKey];
            NSEnumerator *objectEnumeration = [objects objectEnumerator];
            
            [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                id obj = [objectEnumeration nextObject];
                [self notifydidChangeObject:obj atIndex:idx forChangeType:type userInfo:[change mutableCopy]];
            }];
            
            [self notifyDidChangeContent:[change mutableCopy]];
        }
    }
}


@end
