//
//  TSTPErsonListTableViewController.h
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/28/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSTAppDelegate.h"

@interface TSTPErsonListTableViewController : UITableViewController

@property (nonatomic, strong) id <TSTDataProvider> dataProvider;

@end
