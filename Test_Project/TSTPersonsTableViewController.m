//
//  TSTPersonsTableViewController.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTPersonsTableViewController.h"
#import "TSTDataProvider.h"
#import "TSTPerson.h"
#import "TSTAppDelegate.h"
#import "TSTPersonDetailsTableViewController.h"
#import "TSTPersonTableViewCell.h"

@interface TSTPersonsTableViewController () <TSTListener>

@property (nonatomic, strong) id <TSTDataProvider, TSTObservable> dataProvider;

@end

@implementation TSTPersonsTableViewController

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

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataProvider.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TSTPerson *person = [self.dataProvider objectAtIndex:(NSUInteger) indexPath.row];
    
    TSTPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    [cell setupWithPerson:person];

    return cell;
}

#pragma mark - TSTListener protocol methods

- (void)observableObjectWillChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo {
    [self.tableView beginUpdates];
}

- (void)observableObject:(id <TSTObservable>)observable didChangeObject:(id)anObject atIndex:(NSUInteger)index1 forChangeType:(TSTListenerChangeType)type userInfo:(NSMutableDictionary *)userInfo {
    
    switch (type)
    {
        case TSTListenerChangeTypeInsert:
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TSTListenerChangeTypeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TSTListenerChangeTypeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)observableObjectDidChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo {
    [self.tableView endUpdates];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataProvider removeObjectAtIndex:indexPath.row];
    }
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TSTPersonDetailsTableViewController *details = segue.destinationViewController;
    NSUInteger index = [self.tableView indexPathForCell:sender].row;
    details.person = [self.dataProvider objectAtIndex:index];
}


@end
