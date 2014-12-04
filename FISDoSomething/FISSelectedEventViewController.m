//
//  selectedEventViewController.m
//  FISDoSomething
//
//  Created by Karim Mourra on 12/1/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISSelectedEventViewController.h"
#import "Campaign.h"
#import <GPUImage/GPUImage.h>
#import "FISCompressedImages.h"

@interface FISSelectedEventViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
- (IBAction)backButtonTapped:(id)sender;

@end

@implementation FISSelectedEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationBar.topItem.title = self.selectedEvent.title;
    [self setBackgroundImage];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self adjustNavigationBar];
    [self adjustViewConstraints];
}

- (void)setBackgroundImage
{
    UIImage *image = [[FISCompressedImages sharedCompressedImages]
                      blurredImageForCampaign:self.selectedEvent];
    if (image) {
        self.imageView.image = image;
    }
    else {
        [[FISCompressedImages sharedCompressedImages]
         cacheImageForCampaign:self.selectedEvent
         withCompletionHandler:^() {
             self.imageView.image = [[FISCompressedImages sharedCompressedImages]
                                     blurredImageForCampaign:self.selectedEvent];
         }];
    }
}

- (UIImage *)blurImage:(UIImage *)image
{
//    GPUImageiOSBlurFilter *blurFilter = [GPUImageiOSBlurFilter new];
//    blurFilter.blurRadiusInPixels = 6.0;
//    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
//    return blurredImage;
    return image;
}

- (void)removeAllViewConstraints
{
    NSArray *allViews = @[self.navigationBar, self.scrollView, self.view, self.imageView];
    for (UIView *view in allViews) {
        [view removeConstraints:view.constraints];
    }
}

- (void)adjustViewConstraints
{
    [self removeAllViewConstraints];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_navigationBar, _scrollView, _imageView);
    NSDictionary *metrics = @{@"navigationBarHeight" : @44,
                              @"cameraButtonHeight" : @88,
                              @"imageWidth" : @(self.view.frame.size.width*0.94 * 3),
                              @"imageHeight" : @(self.view.frame.size.height * 0.94 - 44)};
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_navigationBar(==navigationBarHeight)][_scrollView]|" options:0 metrics:metrics views:viewsDictionary];
    [self.view addConstraints:verticalConstraints];
    
    NSArray *horizontalNavigationBarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_navigationBar]|" options:0 metrics:metrics views:viewsDictionary];
    [self.view addConstraints:horizontalNavigationBarConstraints];
    
    NSArray *horizontalScrollViewConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"|[_scrollView]|" options:0 metrics:metrics views:viewsDictionary];
    [self.view addConstraints:horizontalScrollViewConstraints];
    
    NSArray *horizontalImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_imageView(==imageWidth)]|" options:0 metrics:metrics views:viewsDictionary];
    [self.scrollView addConstraints:horizontalImageConstraints];
    
    NSArray *verticalImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView(==imageHeight)]|" options:0 metrics:metrics views:viewsDictionary];
    [self.scrollView addConstraints:verticalImageConstraints];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 100;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"stepCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
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
