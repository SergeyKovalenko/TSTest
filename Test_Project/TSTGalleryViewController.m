//
//  TSTGalleryViewController.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/15/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTGalleryViewController.h"
#import "TSTPhotoProvider.h"

@interface TSTGalleryViewController () <TSTListener>
@property (nonatomic, strong) TSTPhotoProvider *provider;
@end

@implementation TSTGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _provider = [[TSTPhotoProvider alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_provider removeListener:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.provider addListener:self];
    [self.provider fetchNextPage];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.provider count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:123];
    imageView.image = nil;
    [self.provider imageForIndex:indexPath.item
                       withBlock:^(UIImage *image) {
                           imageView.image = image;
                       }];
    
    if (indexPath.item == self.provider.count - 1){
        [self.provider fetchNextPage];
    }
    
    return cell;
}


- (void)observableObjectDidChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo {
    [self.collectionView reloadData];
}



@end
