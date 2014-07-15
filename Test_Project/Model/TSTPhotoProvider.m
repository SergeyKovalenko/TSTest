//
//  TSTPhotoProvider.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/15/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTPhotoProvider.h"
#import "TSTDataProvider.h"
#import <FlickrKit/FlickrKit.h>
#import "TSTObservable+Protected.h"

const NSUInteger TSTPhotoProviderDefaultPageSize = 100;

@interface TSTPhotoProvider () <TSTListener>
@property (nonatomic, strong) TSTDataProvider *dataProvider;
@property (nonatomic, strong) FKFlickrInterestingnessGetList *photoRequest;

@end

@implementation TSTPhotoProvider


- (id)init {
    return [self initWithPageSize:TSTPhotoProviderDefaultPageSize];
}

- (id)initWithPageSize:(NSUInteger)pageSize
{
    NSParameterAssert(pageSize > 0);
    
    self = [super init];
    if (self)
    {
        _photoRequest = [[FKFlickrInterestingnessGetList alloc] init];
        _photoRequest.per_page = [NSString stringWithFormat:@"%d", pageSize];
        
        _dataProvider = [[TSTDataProvider alloc] init];
        [_dataProvider addListener:self];
        
        [[FlickrKit sharedFlickrKit] initializeWithAPIKey:@"e3a39f9c4e7742df690a93e1d8d28803" sharedSecret:@"33603bd983c74c40"];
    }
    return self;
}

#pragma mark - Public Methods

- (NSUInteger)count {
    return self.dataProvider.count;
}

- (void)fetchNextPage {
    
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    
    __weak typeof(self) weakSelf = self;

    self.photoRequest.page = [NSString stringWithFormat:@"%d", [self nextPage]];
    
    [fk call:self.photoRequest completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        if (response) {
            NSMutableArray *photoURLs = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *url = [fk photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoData];
                [photoURLs addObject:url];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // Any GUI related operations here
                [weakSelf.dataProvider addObjectsFromArray:photoURLs];
                
            });
        }
    }];
}

- (void)imageForIndex:(NSUInteger)idx withBlock:(void (^)(UIImage *image))fetchBlock {
    if (fetchBlock) {
        NSURL *photoURL = [self.dataProvider objectAtIndex:idx];
        dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(downloadQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:photoURL];
            UIImage *image = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                fetchBlock(image);
            });
        });
    }
}

#pragma mark - Private Methods

- (NSUInteger)nextPage
{
    NSUInteger currentPage = self.dataProvider.count / self.photoRequest.per_page.integerValue;
    return ++currentPage;
}

#pragma mark - TSTListener

- (void)observableObjectWillChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo
{
    [self notifyWillChangeContent:userInfo];
}

- (void)observableObject:(id <TSTObservable>)observable didChangeObject:(id)anObject atIndex:(NSUInteger)index forChangeType:(TSTListenerChangeType)type userInfo:(NSMutableDictionary *)userInfo {
    [self notifyDidChangeObject:anObject atIndex:index forChangeType:type userInfo:userInfo];
}
- (void)observableObjectDidChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo
{
    [self notifyDidChangeContent:userInfo];
}

@end
