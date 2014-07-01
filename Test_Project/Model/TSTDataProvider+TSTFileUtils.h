//
//  TSTDataProvider+TSTFileUtils.h
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTDataProvider.h"

@interface TSTDataProvider (TSTFileUtils)

+ (TSTDataProvider *)testDataProvider;
- (void)testSave;
@end
