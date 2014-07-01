//
//  TSTAppDelegate.h
//  Test_Project
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSTDataProvider.h"

@interface TSTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) TSTDataProvider *dataProvider;

+ (TSTAppDelegate *)appDelegate;

@end
