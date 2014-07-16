//
//  TSTTestViewController.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 7/9/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTPersonsCollectionViewController.h"
#import "TSTDataProvider.h"
#import "TSTAppDelegate.h"
#import "TSTPerson.h"
#import "TSTPersonCollectionViewCell.h"
#import "TSTPersonDetailsTableViewController.h"

@interface TSTPersonsCollectionViewController () <TSTListener>

@property (nonatomic, strong) id <TSTDataProvider, TSTObservable> dataProvider;

@end

@implementation TSTPersonsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataProvider = [TSTAppDelegate sharedDelegate].dataProvider;
    [self.dataProvider addListener:self];

    self.navigationItem.rightBarButtonItem = [self addPersonButton];
}

- (UIBarButtonItem *)addPersonButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson:)];
}

- (void)addPerson:(id)sender {
    TSTPerson *person = [[TSTPerson alloc] init];
    person.firstName = @"John";
    person.lastName = @"Doe";
    [self.dataProvider addObject:person];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataProvider.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TSTPerson *person = [self.dataProvider objectAtIndex:(NSUInteger) indexPath.row];
    
    TSTPersonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PersonCell" forIndexPath:indexPath];
    [cell setupWithPerson:person];
    
    return cell;
}

#pragma mark - TSTListener protocol methods

- (void)observableObjectWillChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo {

}

- (void)observableObject:(id <TSTObservable>)observable didChangeObject:(id)anObject atIndex:(NSUInteger)index1 forChangeType:(TSTListenerChangeType)type userInfo:(NSMutableDictionary *)userInfo {
    
    [self.collectionView performBatchUpdates:^{
        switch (type)
        {
            case TSTListenerChangeTypeInsert:
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index1 inSection:0]]];
                
                break;
            case TSTListenerChangeTypeDelete:
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index1 inSection:0]]];
                
                break;
            case TSTListenerChangeTypeUpdate:
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index1 inSection:0]]];
                
                break;
        }

    } completion:^(BOOL finished) {
        
    }];
}

- (void)observableObjectDidChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo {

}

#pragma mark - Interface orientation methods

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UICollectionViewCell *)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TSTPersonDetailsTableViewController *details = segue.destinationViewController;
    NSUInteger index = [self.collectionView indexPathForCell:sender].row;
    TSTPerson *person = [self.dataProvider objectAtIndex:index];
    details.person = person;
}

@end
