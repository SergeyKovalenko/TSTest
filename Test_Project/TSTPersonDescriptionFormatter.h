//
//  TSTPersonDescriptionFormatter.h
//  Test_Project
//
//  Created by Yury Grinenko on 21.06.14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSTPerson;

@interface TSTPersonDescriptionFormatter : NSObject

- (NSString *)descriptionStringFromPerson:(TSTPerson *)person;

@end
