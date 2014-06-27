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

@interface TSTPersonsTableViewController () <TSTListener>

@property (nonatomic, strong) id <TSTDataProvider, TSTObservable> dataProvider;

@end

@implementation TSTPersonsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataProvider = [TSTAppDelegate sharedDelegate].dataProvider;
    [self.dataProvider addListener:self];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [self createAddButton];
}

- (UIBarButtonItem *)createAddButton
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson:)];
}

- (void)addPerson:(id)sender
{
    TSTPerson *person = [[TSTPerson alloc] init];
    person.firstName = @"John";
    person.lastName = @"Doe";
    [self.dataProvider addObject:person];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataProvider.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    TSTPerson *person = [self.dataProvider objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = person.fullName;
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:person.birthDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];

    // Configure the cell...

    return cell;
}

- (void)observableObjectWillChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo
{
    [self.tableView beginUpdates];
}

- (void)observableObject:(id <TSTObservable>)observable didChangeObject:(id)anObject atIndex:(NSUInteger)index1 forChangeType:(TSTListenerChangeType)type userInfo:(NSMutableDictionary *)userInfo
{
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

- (void)observableObjectDidChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo
{
    [self.tableView endUpdates];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataProvider removeObjectAtIndex:indexPath.row];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TSTPersonDetailsTableViewController *details = segue.destinationViewController;
    NSUInteger index = [self.tableView indexPathForCell:sender].row;
    details.person = [self.dataProvider objectAtIndex:index];
    
}


@end
