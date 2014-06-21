//
//  TSTViewController.m
//  Test_Project
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTViewController.h"
#import "TSTPerson.h"
#import "TSTPersonDescriptionFormatter.h"

@interface TSTViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;

@property (strong, nonatomic) NSMutableArray *personsArray;
@property (strong, nonatomic) TSTPersonDescriptionFormatter *personDescriptionFormatter;

@end

@implementation TSTViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _personsArray = [NSMutableArray array];
        _personDescriptionFormatter = [[TSTPersonDescriptionFormatter alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField == self.firstNameTextField)
//    {
//        self.person.firstName = self.firstNameTextField.text;
//    }
//    else
//    {
//        self.person.lastName = self.lastNameTextField.text;
//    }
}

- (IBAction)datePicked:(UIDatePicker *)sender
{
//    self.person.birthDate = sender.date;
}


- (IBAction)displayPerson:(id)sender
{
    TSTPerson *person = [TSTPerson new];
    person.firstName = self.firstNameTextField.text;
    person.lastName = self.lastNameTextField.text;
    person.birthDate = self.birthdayPicker.date;
    
    [self.personsArray addObject:person];
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"Number of persons in array: %i", [self.personsArray count]];
    
//    self.descriptionLabel.text = [self.personDescriptionFormatter descriptionStringFromPerson:self.person];
//    NSLog(@"%@", self.person);
}





@end
