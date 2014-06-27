//
//  TSTAppDelegate.h
//  Test_Project
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSTDataProvider;

@interface TSTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readonly) TSTDataProvider *dataProvider;

+ (TSTAppDelegate *)sharedDelegate;

@end
