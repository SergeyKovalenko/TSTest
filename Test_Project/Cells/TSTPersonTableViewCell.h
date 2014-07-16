//
//  TSTPersonTableViewCell.h
//  Test_Project
//
//  Created by Yury Grinenko on 12.07.14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSTPerson;

@interface TSTPersonTableViewCell : UITableViewCell

- (void)setupWithPerson:(TSTPerson *)person;

@end
