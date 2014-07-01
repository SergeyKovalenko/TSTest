//
//  TSTDataProvider+TSTFileUtils.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTDataProvider+TSTFileUtils.h"
#import "TSTPerson.h"

static NSString *TSTSavePath()
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"contacts"];
}

@implementation TSTDataProvider (TSTFileUtils)

+ (TSTDataProvider *)testDataProvider
{
    NSString *path = TSTSavePath();

    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [[TSTDataProvider alloc] initWithContentOfFile:path];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"plist"];
        
        NSArray *contactsDictionaries = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:contactsDictionaries.count];
        
        for (NSDictionary *dictionary in contactsDictionaries)
        {
            [contacts addObject:[[TSTPerson alloc] initWithDictionary:dictionary]];
        }
        return [[TSTDataProvider alloc] initWithArray:contacts];
    }
}

- (void)testSave
{
    [self saveToFile:TSTSavePath() error:nil];
}

@end
