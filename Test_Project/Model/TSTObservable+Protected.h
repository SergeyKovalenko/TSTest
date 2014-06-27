//
//  TSTObservable+Protected.h
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTObservable.h"

@interface TSTObservable (/*Protected*/)

@property (nonatomic, strong) NSHashTable *listeners;

- (void)notifyWillChangeContent:(NSMutableDictionary *)userInfo;
- (void)notifydidChangeObject:(id)anObject atIndex:(NSUInteger)index forChangeType:(TSTListenerChangeType)type userInfo:(NSMutableDictionary *)userInfo;
- (void)notifyDidChangeContent:(NSMutableDictionary *)userInfo;

@end
