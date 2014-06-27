//
//  TSTModel.h
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSTObservable.h"

extern NSString *const TSTModelChangedKey;

@interface TSTModel : TSTObservable <NSCopying, NSCoding>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)primitiveValues;
- (id)primitiveValueForKey:(NSString *)key;
- (void)setPrinmitiveValue:(id <NSCoding>)value forKey:(NSString *)key;

@end
