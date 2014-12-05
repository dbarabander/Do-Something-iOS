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

- (IBAction)presentEventSwipe:(id)sender;


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
        return [self isValidEmail] && [self isValidPassword] && [self isValidPasswordConfirmation] && self.birthdayTextField.text.length && [self isValidName];
    } else {
        return [self isValidEmail] && [self isValidPassword];
    }
}

- (BOOL) isValidEmail
{
    if (self.emailTextField.text.length > 0 && [self NSStringIsValidEmail:self.emailTextField.text])  {
        return YES;
    } else{
        UIAlertView *invalidEmail = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Email" delegate:self cancelButtonTitle:@"Clear" otherButtonTitles:@"OK", nil];
//        [invalidEmail show];
        return NO;
    }
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
    if (self.passwordTextField.text.length > 6){
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

- (IBAction)presentEventSwipe:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    FISEventSwipeViewController *eventSwipeViewController = [[FISEventSwipeViewController alloc] init];
    [self setUpViewController:eventSwipeViewController];
    [self setUpScrollview: eventSwipeViewController];
    [self.navigationController pushViewController:eventSwipeViewController animated:YES];
}

- (void)setUpViewController:(UIViewController *)viewController
{

    CGRect viewControllerFrame = viewController.view.frame;
    viewControllerFrame.origin.x = 0;
    viewController.view.frame = viewControllerFrame;
    [self addChildViewController:viewController];
    [self.scrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];

    FISChosenEventsTableViewController *chosenEventVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"chosenEventsTVC"];
    CGRect randomVCFrame = chosenEventVC.view.frame;
    randomVCFrame.origin.x = self.view.frame.size.width;
    chosenEventVC.view.frame = randomVCFrame;
    [self addChildViewController:chosenEventVC];
    [self.scrollView addSubview:chosenEventVC.view];
    [chosenEventVC didMoveToParentViewController:self];

    if ([viewController isKindOfClass:[FISEventSwipeViewController class]]) {
        ((FISEventSwipeViewController *)viewController).delegate = chosenEventVC.childViewControllers[0];
    }
}

- (void)setUpScrollview: (FISEventSwipeViewController *)viewController
{
    viewController.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);
    viewController.scrollView.pagingEnabled = YES;

    // Start at left most
    CGPoint leftScrollView = CGPointMake(0, 0);
    [viewController.scrollView setContentOffset:leftScrollView];

    // Hide scroll view indicators
    [viewController.scrollView setShowsHorizontalScrollIndicator:NO];
    [viewController.scrollView setShowsVerticalScrollIndicator:NO];
}

@end
