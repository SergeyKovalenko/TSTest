//
//  TSTPersonDetailsTableViewController.m
//  Test_Project
//
//  Created by Sergey Kovalenko on 6/27/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTPersonDetailsTableViewController.h"
#import "TSTPerson.h"
static void * TSTPersonDetailsObserveContext = &TSTPersonDetailsObserveContext;

@interface TSTPersonDetailsTableViewController () <TSTListener, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthDatePicker;

@property (nonatomic, assign, getter = isPersonChanging) BOOL personChanging;
@end

@implementation TSTPersonDetailsTableViewController

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
    [self setupPersonBindings];
}

- (void)setPerson:(TSTPerson *)person
{
    if (_person != person)
    {
        [_person removeObserver:self forKeyPath:@"fullName" context:TSTPersonDetailsObserveContext];
        [_person removeListener:self];
        _person = person;
        [_person addListener:self];
        [_person addObserver:self forKeyPath:@"fullName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:TSTPersonDetailsObserveContext];
        [self setupPersonBindings];
    }
}

- (void)dealloc
{
    [_person removeObserver:self forKeyPath:@"fullName" context:TSTPersonDetailsObserveContext];
    [_person removeListener:self];
}

- (NSArray *)contactStringKeys;
{
    return @[@"firstName", @"lastName", @"email"];
}

- (UITextField *)textFieldForModelKey:(NSString *)key;
{
    return [self valueForKey:[key stringByAppendingString:@"TextField"]];
}

- (void)updateTextFields
{
    for (NSString *key in self.contactStringKeys)
    {
        [self textFieldForModelKey:key].text = [self.person valueForKey:key];
    }
}

- (void)setupPersonBindings
{
    if (self.isViewLoaded)
    {
        if (self.person.birthDate) {
            [self.birthDatePicker setDate:self.person.birthDate animated:YES];
        }
        [self updateTextFields];
    }
}

- (void)observableObjectDidChangeContent:(id <TSTObservable>)observable userInfo:(NSMutableDictionary *)userInfo
{
    if (self.isPersonChanging)
        return;
    
    [self setupPersonBindings];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.person && TSTPersonDetailsObserveContext == context) {
        self.title = change[NSKeyValueChangeNewKey];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    for (NSString *key in self.contactStringKeys)
    {
        UITextField *field = [self textFieldForModelKey:key];
        if (field == textField)
        {
            NSString *value = [textField.text stringByReplacingCharactersInRange:range withString:string];
            if ([self.person validateValue:&value forKey:key error:nil]) {
                [self willChangePerson];
                [self.person setValue:value forKey:key];
                [self didChangePerson];
                textField.textColor = nil;
            } else {
                textField.textColor = [UIColor redColor];
            }
            break;
        }
    }
    return YES;
}

- (void)didChangePerson
{
    self.personChanging = NO;
}

- (void)willChangePerson
{
    self.personChanging = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (IBAction)pickerDidChangeDate:(id)sender
{
    self.person.birthDate = self.birthDatePicker.date;
}

@end
