//
//  TSTPersonDetailsTableViewController.h
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSTPerson;

@interface TSTPersonDetailsTableViewController : UITableViewController
@property (nonatomic, strong) TSTPerson *person;
@end
