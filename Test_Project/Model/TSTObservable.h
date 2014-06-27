//
// Created by Sergey Kovalenko on 6/27/14.
// Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

typedef NS_ENUM(NSUInteger, TSTListenerChangeType) {
    TSTListenerChangeTypeInsert = 1, TSTListenerChangeTypeDelete = 2, TSTListenerChangeTypeUpdate = 3
};

@protocol TSTObservable;

@protocol TSTListener <NSObject>

@optional

- (void)observableObjectWillChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo;

- (void)observableObject:(id <TSTObservable>)observable didChangeObject:(id)anObject atIndex:(NSUInteger)index forChangeType:(TSTListenerChangeType)type userInfo:(NSMutableDictionary *)userInfo;

- (void)observableObjectDidChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo;

@end

@protocol TSTObservable <NSObject>

- (void)addListener:(id <TSTListener>)listener;

- (void)removeListener:(id <TSTListener>)listener;

@end

@interface TSTObservable : NSObject <TSTObservable>


@end

