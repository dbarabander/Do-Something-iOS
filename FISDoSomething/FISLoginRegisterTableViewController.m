//
//  FISLoginRegisterTableViewController.m
//  FISDoSomething
//
//  Created by DANIEL BARABANDER on 12/5/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISLoginRegisterTableViewController.h"
#import "FISEventSwipeViewController.h"
#import "FISChosenEventsTableViewController.h"
#import "AppDelegate.h"
#import "RMPhoneFormat.h"

@interface FISLoginRegisterTableViewController()<UITextFieldDelegate, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) UIDatePicker *birthdayDatePicker;

@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *passwordCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *confirmPasswordCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *segmentedControlCell;
@property (strong, nonatomic) NSArray *textFieldsArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) BOOL isSignUp;
@property (strong, nonatomic) UIScrollView *scrollView;

- (IBAction)doneButtonTapped:(id)sender;

@end

@implementation FISLoginRegisterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textFieldsArray = @[self.emailTextField, self.passwordTextField, self.confirmPasswordTextField, self.birthdayTextField, self.nameTextField];

    self.isSignUp = YES;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
    self.tableView.delegate = self;

    self.birthdayDatePicker = [[UIDatePicker alloc] init];
    self.birthdayDatePicker.datePickerMode = UIDatePickerModeDate;

    [self.birthdayTextField setInputView:self.birthdayDatePicker];
    [self.birthdayDatePicker addTarget:self  action:@selector(birthdayDateChanged:) forControlEvents:UIControlEventValueChanged];

    [self.passwordTextField addTarget:self action:@selector(passwordTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.segmentedControl addTarget:self action:@selector(showForm) forControlEvents:UIControlEventValueChanged];

    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.emailTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    self.confirmPasswordTextField.secureTextEntry = YES;
    self.birthdayTextField.delegate = self;
    self.nameTextField.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem.enabled = [self isFormFilledOut];
}


#pragma mark QCTCreatePollTableViewController delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 4) {
        UITextField *currentTextField= self.textFieldsArray[indexPath.row];
        [currentTextField becomeFirstResponder];
    }
}

- (void)birthdayDateChanged:(id)sender
{
    [self.birthdayDatePicker setMaximumDate:[NSDate date]];
    self.birthdayTextField.text = [self formatDateToString:self.birthdayDatePicker.date];
    if ([self isFormFilledOut]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (BOOL)isFormFilledOut
{
    if (self.isSignUp) {
        return ([self isValidEmail] || [self isValidPhone]) && [self isValidPassword] && [self isValidPasswordConfirmation] && self.birthdayTextField.text.length && [self isValidName];
    } else {
        return [self isValidEmail] && [self isValidPassword];
    }
}

- (BOOL) isValidEmail
{
    if (self.emailTextField.text.length > 0 && [self NSStringIsValidEmail:self.emailTextField.text])  {
        return YES;
    }
    return NO;
}

- (BOOL) isValidPhone
{
    RMPhoneFormat *fmt = [[RMPhoneFormat alloc] initWithDefaultCountry:@"us"];
    NSString *numberString = self.emailTextField.text;
    return [fmt isPhoneNumberValid:numberString];
}
- (NSString *)formatDateToString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YY"];
    NSString *formattedDateString = [formatter stringFromDate:date];
    return formattedDateString;
}

- (void)showForm
{
    if ([self.segmentedControl selectedSegmentIndex] == 0) {
        self.isSignUp = YES;
        self.hideSectionsWithHiddenRows = NO;
        [self cell:self.confirmPasswordCell setHidden:NO];
        [self cell:self.birthdayCell setHidden:NO];
        [self cell:self.nameCell setHidden:NO];
        [self reloadDataAnimated:YES];

    } else {
        self.isSignUp = NO;
        self.hideSectionsWithHiddenRows = YES;
        [self cell:self.confirmPasswordCell setHidden:YES];
        [self cell:self.birthdayCell setHidden:YES];
        [self cell:self.nameCell setHidden:YES];
        [self reloadDataAnimated:YES];
    }
}


- (BOOL) isValidName
{
    if (self.nameTextField.text.length > 0 && [self validateStringContainsAlphabetsOnly:self.nameTextField.text])  {
        return YES;
    }
    return NO;
//    else{
//        UIAlertView *invalidFirstName = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid  Name. A-Z only" delegate:self cancelButtonTitle:@"Clear" otherButtonTitles:@"OK", nil];
//        [invalidFirstName show];
//
//        return NO;
//    }
}

- (BOOL) isValidPassword
{
    if (self.passwordTextField.text.length >= 6){
        return YES;
    }
//    }else{
//        UIAlertView *invalidPassword = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Password" delegate:self cancelButtonTitle:@"Clear" otherButtonTitles:@"OK", nil];
//        [invalidPassword show];
//        return NO;
//    }
    return NO;
}

- (BOOL) isValidPasswordConfirmation
{
    if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]){
        return YES;
    } else {
        return NO;
    }
}

- (void)passwordTextDidChange:(id)sender
{
    if ([self.passwordTextField.text length] >= 6 && !self.isSignUp) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (BOOL) validateStringContainsAlphabetsOnly:(NSString*)strng
{
    NSCharacterSet *strCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "];
    strCharSet = [strCharSet invertedSet];
    NSRange r = [strng rangeOfCharacterFromSet:strCharSet];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return NO;
    }
    else{
        return YES;
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (![self isFormFilledOut]) {
        UIAlertView *invalidForm = [[UIAlertView alloc]initWithTitle:@"Error" message:@"All fields must be submitted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [invalidForm show];
    return NO;
}
    return YES;
}

- (void)loginOrSignupSuccessful
{
    // STORE USER NAME AND PASSWORD AND HASH IN KEYCHAIN/NSUSERDEFAULTS HERERERERERERE
    
    
    
    // Transition to scroll view
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIViewController *initialViewController = [self.storyboard instantiateInitialViewController];
    [UIView transitionWithView:appDelegate.window duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        appDelegate.window.rootViewController = initialViewController;
    } completion:^(BOOL finished) {}];
}

- (IBAction)doneButtonTapped:(id)sender {
    [self loginOrSignupSuccessful];
}

@end
