//
//  selectedEventViewController.m
//  FISDoSomething
//
//  Created by Karim Mourra on 12/1/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "selectedEventViewController.h"
#import "Campaign.h"

@interface selectedEventViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end

@implementation selectedEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.eventImage.image = [UIImage imageWithData:self.selectedEvent.squareImage];
    self.eventDescription.text = self.selectedEvent.valueProposition;
    self.navigationBar.topItem.title = self.selectedEvent.title;
    
    [self adjustNavigationBar];
}

- (void)adjustNavigationBar
{
    [self.navigationBar
     setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"ProximaNovaA-Bold" size:14],
      NSFontAttributeName, [UIColor whiteColor],
      NSForegroundColorAttributeName, nil]];
    self.navigationBar.backgroundColor = [UIColor colorWithRed:77.0/255.0 green:43.0/255.0 blue:99.0/255.0 alpha:1.0];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationBar.barTintColor =[UIColor colorWithRed:77.0/255.0 green:43.0/255.0 blue:99.0/255.0 alpha:1.0];
    self.navigationBar.tintColor =[UIColor colorWithRed:77.0/255.0 green:43.0/255.0 blue:99.0/255.0 alpha:1.0];
    
    self.backButton.tintColor = [UIColor whiteColor];
    [self.backButton setTitleTextAttributes:@{
        NSFontAttributeName : [UIFont fontWithName:@"ProximaNovaA-Bold" size:21.0],
        NSForegroundColorAttributeName : [UIColor whiteColor]
    } forState:UIControlStateNormal];
    
    self.cameraButton.tintColor = [UIColor whiteColor];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) obtainImageFrom:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    NSArray *mediaTypesAllowed = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePicker.mediaTypes = mediaTypesAllowed;
    
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker
                       animated:YES
                     completion:^{
                         //digitize chosen picture and attach to message
                         
                     }];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self obtainImageFrom:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 2){
        [self obtainImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

-(BOOL)systemVersionLessThan8
{
    CGFloat deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    return deviceVersion < 8.0f;
}

- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)cameraButtonTapped:(id)sender {
    if ([self systemVersionLessThan8])
    {
        UIAlertView* mediaAlert = [[UIAlertView alloc] initWithTitle:@"Share something!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take a Picture or Video", @"Choose an existing Photo or Video", nil];
        
        [mediaAlert show];
    }
    else
    {
        
        UIAlertController* mediaAlert = [UIAlertController alertControllerWithTitle:@"Share a picture!" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"Take a Picture or Video"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action){[self obtainImageFrom:UIImagePickerControllerSourceTypeCamera];
                                                          }];
        [mediaAlert addAction:takePhoto];
        
        UIAlertAction* chooseExistingPhoto = [UIAlertAction actionWithTitle:@"Choose an existing Photo or Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self obtainImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        
        [mediaAlert addAction:chooseExistingPhoto];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        [mediaAlert addAction:cancel];
        
        [self presentViewController:mediaAlert animated:YES completion:^{
            
        }];
    }
}
@end
