//
//  TSTPhotoProvider.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/15/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTPhotoProvider.h"
#import <FlickrKit/FlickrKit.h>
#import "TSTDataProvider.h"

@interface TSTPhotoProvider () <TSTListener>
@property (nonatomic, strong) FKFlickrInterestingnessGetList *photoRequest;
@property (nonatomic, strong) TSTDataProvider *dataProvider;

@end

@implementation TSTPhotoProvider

- (id)initWithPageSize:(NSUInteger)pageSize {
    self = [super init];
    if (self) {
        [[FlickrKit sharedFlickrKit] initializeWithAPIKey:@"e3a39f9c4e7742df690a93e1d8d28803"
                                             sharedSecret:@"33603bd983c74c40"];
        
        _photoRequest = [[FKFlickrInterestingnessGetList alloc] init];
        _photoRequest.per_page = [NSString stringWithFormat:@"%d",pageSize];
        _dataProvider = [[TSTDataProvider alloc] init];
        [_dataProvider addListener:self];
    }
    return self;
}

@end
