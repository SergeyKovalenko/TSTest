//
//  TSTDataProvider.h
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/26/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TSTObservable.h"

@protocol TSTDataProvider <NSObject>

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)anObject;

- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;

@end

@interface TSTDataProvider : NSObject <TSTDataProvider>

- (instancetype)initWithContentOfFile:(NSString *)filePath;
- (instancetype)initWithArray:(NSArray *)anArray;
- (BOOL)saveToFile:(NSString *)path error:(NSError **)error;

@end
