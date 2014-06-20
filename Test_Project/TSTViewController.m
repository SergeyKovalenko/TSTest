//
//  TSTViewController.m
//  Test_Project
//
//  Created by Anton Kuznetsov on 6/17/14.
//  Copyright (c) 2014 Anton Kuznetsov. All rights reserved.
//

#import "TSTViewController.h"
#import "TSTPerson.h"

@interface TSTViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (strong, nonatomic) TSTPerson *person;
@end

@implementation TSTViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _person = [[TSTPerson alloc] init];
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
    if (textField == self.firstNameTextField)
    {
        self.person.firstName = self.firstNameTextField.text;
    }
    else
    {
        self.person.lastName = self.lastNameTextField.text;
    }
}

- (IBAction)datePicked:(UIDatePicker *)sender
{
    self.person.birthDate = sender.date;
}


- (IBAction)displayPerson:(id)sender
{
    self.descriptionLabel.text = self.person.description;
    NSLog(@"%@", self.person);
}





@end
