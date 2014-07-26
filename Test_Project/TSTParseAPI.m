//
//  TSTParseAPI.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/26/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTParseAPI.h"



@implementation TSTParseAPI

+ (instancetype)api
{
    static TSTParseAPI *sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAPI = [[self alloc] init];
    });
    return sharedAPI;
}

@end
