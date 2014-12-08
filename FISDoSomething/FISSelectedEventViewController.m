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
#import "FISAppFont.h"
#import <AFNetworking/AFNetworking.h> 
#import "PopOverAnimation.h"
#import "FISDoSomethingAPI.h"


@interface FISSelectedEventViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *stepOneView;
@property (weak, nonatomic) IBOutlet UIView *stepTwoView;
@property (weak, nonatomic) IBOutlet UIView *stepThreeView;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
- (IBAction)cameraButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;

// Step 1
@property (weak, nonatomic) IBOutlet UILabel *stepOneTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *problemLabel;
@property (weak, nonatomic) IBOutlet UITextView *problemTextView;
@property (weak, nonatomic) IBOutlet UILabel *solutionLabel;
@property (weak, nonatomic) IBOutlet UITextView *solutionTextView;


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
    self.scrollView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.stepOneView.backgroundColor = [UIColor clearColor];
    self.stepTwoView.backgroundColor = [UIColor clearColor];
    self.stepThreeView.backgroundColor = [UIColor clearColor];
    
    // Setup stepone labels
    self.stepOneTitleLabel.font = appFont(23);
    self.stepOneTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.stepOneTitleLabel.backgroundColor = [UIColor blackColor];
    self.stepOneTitleLabel.alpha = 1.0;
    
    self.problemLabel.textColor = [UIColor blackColor];
    self.problemLabel.font = appFont(23);
    self.problemLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.problemTextView setText:self.selectedEvent.factProblem];
    self.problemTextView.textColor = [UIColor whiteColor];
    self.problemTextView.font = appFont(23);
    NSLog(@"TESTING :%@", self.problemTextView.text);
    self.problemTextView.hidden = NO;

    self.solutionLabel.textColor = [UIColor blackColor];
    self.solutionLabel.font = appFont(23);
    self.solutionLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.solutionTextView setText:self.selectedEvent.factSolution];
    self.solutionTextView.textColor = [UIColor whiteColor];
    self.solutionTextView.font = appFont(23);
    self.solutionTextView.hidden = NO;
    
    self.stepOneTitleLabel.alpha = 0.0;
    self.solutionLabel.alpha = 0.0;
    self.solutionTextView.alpha = 0.0;
    self.problemLabel.alpha = 0.0;
    self.problemTextView.alpha = 0.0;
    
    
    
    [self adjustNavigationBar];
    [self adjustViewConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // animate step one
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
            self.stepOneTitleLabel.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations:^{
            self.problemLabel.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.2 animations:^{
            self.problemTextView.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.2 animations:^{
            self.solutionLabel.alpha = 1.0;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            self.solutionTextView.alpha = 1.0;
        }];
    } completion:^(BOOL finished) {}];
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

- (void)removeAllViewConstraints
{
    NSArray *allViews = @[self.navigationBar, self.scrollView, self.view, self.imageView, self.stepOneView, self.stepTwoView, self.stepThreeView, self.problemLabel, self.problemTextView, self.solutionLabel, self.solutionTextView, self.stepOneTitleLabel];
    for (UIView *view in allViews) {
        [view removeConstraints:view.constraints];
    }
}

- (void)adjustViewConstraints
{
    [self removeAllViewConstraints];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_navigationBar, _scrollView, _imageView, _stepOneView, _stepTwoView, _stepThreeView, _problemLabel, _problemTextView, _solutionLabel, _solutionTextView, _stepOneTitleLabel);
    NSDictionary *metrics = @{@"navigationBarHeight" : @44,
                              @"cameraButtonHeight" : @88,
                              @"imageWidth" : @(self.view.frame.size.width*0.94 * 3),
                              @"imageHeight" : @(self.view.frame.size.height * 0.94 - 44),
                              @"stepOneTitleLabelHeight" : @44,
                              @"problemLabelHeight" : @44,
                              @"solutionLabelHeight" : @44};
    
    // All VerticalConstraints
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_navigationBar(==navigationBarHeight)][_scrollView]|" options:0 metrics:metrics views:viewsDictionary];
    [self.view addConstraints:verticalConstraints];
    
    // Nav bar horizontal
    NSArray *horizontalNavigationBarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_navigationBar]|" options:0 metrics:metrics views:viewsDictionary];
    [self.view addConstraints:horizontalNavigationBarConstraints];
    
    // Scroll view horizontal
    NSArray *horizontalScrollViewConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"|[_scrollView]|" options:0 metrics:metrics views:viewsDictionary];
    [self.view addConstraints:horizontalScrollViewConstraints];
    
    // image horizontal
    NSArray *horizontalImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_imageView(==imageWidth)]|" options:0 metrics:metrics views:viewsDictionary];
    [self.scrollView addConstraints:horizontalImageConstraints];
    
    // Image vertical
    NSArray *verticalImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView(==imageHeight)]|" options:0 metrics:metrics views:viewsDictionary];
    [self.scrollView addConstraints:verticalImageConstraints];
    
    // step view vertical
    NSArray *stepOneViewVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stepOneView(==imageHeight)]|" options:0 metrics:metrics views:viewsDictionary];
    NSArray *stepTwoViewVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stepTwoView(==imageHeight)]|" options:0 metrics:metrics views:viewsDictionary];
    NSArray *stepThreeViewVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stepThreeView(==imageHeight)]|" options:0 metrics:metrics views:viewsDictionary];
    [self.scrollView addConstraints:stepOneViewVertical];
    [self.scrollView addConstraints:stepTwoViewVertical];
    [self.scrollView addConstraints:stepThreeViewVertical];
    
    // Horizontal step views
    NSArray *stepViewsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_stepOneView][_stepTwoView(==_stepOneView)][_stepThreeView(==_stepTwoView)]|" options:0 metrics:metrics views:viewsDictionary];
    [self.scrollView addConstraints:stepViewsHorizontal];
    
    // Step one labels
    NSArray *stepOneVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_stepOneTitleLabel(==stepOneTitleLabelHeight)][_problemLabel(==problemLabelHeight)][_problemTextView][_solutionLabel(==solutionLabelHeight)][_solutionTextView(==_problemTextView)]|" options:0 metrics:metrics views:viewsDictionary];
    [self.stepOneView addConstraints:stepOneVerticalConstraints];
    NSArray *stepOneTitleHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_stepOneTitleLabel]|" options:0 metrics:metrics views:viewsDictionary];
    [self.stepOneView addConstraints:stepOneTitleHorizontalConstraints];
    NSArray *problemLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_solutionLabel]|" options:0 metrics:metrics views:viewsDictionary];
    [self.stepOneView addConstraints:problemLabelHorizontalConstraints];
    NSArray *problemTextViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_problemTextView]|" options:0 metrics:metrics views:viewsDictionary];
    [self.stepOneView addConstraints:problemTextViewHorizontalConstraints];
    NSArray *solutionLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_solutionLabel]|" options:0 metrics:metrics views:viewsDictionary];
    [self.stepOneView addConstraints:solutionLabelHorizontalConstraints];
    NSArray *solutionTextViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_solutionTextView]|" options:0 metrics:metrics views:viewsDictionary];
    [self.stepOneView addConstraints:solutionTextViewHorizontalConstraints];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat contentOffest = scrollView.contentOffset.x;
    if (contentOffest >= 0 && contentOffest < 300) {
        NSLog(@"step one");
    }
    else if (contentOffest > 300 && contentOffest < 600) {
        [UIView animateWithDuration:0.5 animations:^{
            NSLog(@"animation step two");
        }];
        
    }
    else {
        [UIView animateWithDuration:0.5 animations:^{
            NSLog(@"animation step three");
        }];
    }
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
        UIAlertView* mediaAlert = [[UIAlertView alloc] initWithTitle:@"Share something!" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take a Picture", @"Choose an existing Photo", nil];
        
        [mediaAlert show];
    }
    else
    {
        
        UIAlertController* mediaAlert = [UIAlertController alertControllerWithTitle:@"Share a picture!" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"Take a Picture"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action){[self obtainImageFrom:UIImagePickerControllerSourceTypeCamera];
                                                          }];
        [mediaAlert addAction:takePhoto];
        
        UIAlertAction* chooseExistingPhoto = [UIAlertAction actionWithTitle:@"Choose an existing Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL
                                               usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    UIDocumentInteractionController *interactionController =
    [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

-(void) obtainImageFrom:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    NSArray *mediaTypesAllowed = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePicker.mediaTypes = mediaTypesAllowed;
    
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker
                       animated:YES
                     completion:^{
                         
                     }];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{

        NSLog(@"dictionnary = %@", info);
        NSString* mediaType = [info valueForKey:UIImagePickerControllerMediaType];
        NSLog(@"mediaType = %@", mediaType);
        
        if([mediaType isEqualToString:@"public.image"])
        {
            NSURL* extractedPhotoURL = [info valueForKey:UIImagePickerControllerReferenceURL];
            NSLog(@"test: %@", [extractedPhotoURL class] );
            
            UIImage* extractedPhoto = [info valueForKey:UIImagePickerControllerOriginalImage];
            
            [self popUpPropmtoForUploadingToAPI:extractedPhoto];
            [self sendToInstagram:extractedPhoto];
        }
    }];
}

-(void)popUpPropmtoForUploadingToAPI:(UIImage*)photo
{
    UIAlertController* shareAlert = [UIAlertController alertControllerWithTitle:@"Great! You selected a Picture!" message:@"Post to our API?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* SendToWebSite = [UIAlertAction
                                    actionWithTitle:@"OK!"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action){[FISDoSomethingAPI postToWebsite:photo withCompletionHandler:
    ^{
        [self popUpPrompt:@"Success! You just pushed to the API!" ForSocialMediaSharing:photo];
    }];
    }];
    [shareAlert addAction:SendToWebSite];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self popUpPrompt:@"Share on Social Media instead?" ForSocialMediaSharing:photo];
    }];
    [shareAlert addAction:cancel];
    [self presentViewController:shareAlert animated:YES completion:^{
    }];
}

-(void)popUpPrompt:(NSString*)phrase ForSocialMediaSharing:(UIImage*)photo
{
    UIAlertController* shareAlert = [UIAlertController alertControllerWithTitle:phrase message:@"Would you like to share on Social Media?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* shareOnSocialMedia = [UIAlertAction actionWithTitle:@"Yes!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sendToInstagram:photo];
    }];
    
    [shareAlert addAction:shareOnSocialMedia];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [shareAlert addAction:cancel];
    
    [self presentViewController:shareAlert animated:YES completion:^{
        
    }];
    
}
- (void)logInToInstagram{
    NSURL *githubAuthURL = [NSURL URLWithString:@"https://api.instagram.com/oauth/authorize/?client_id=908a50054bf8441e9a7fb87a7f338256&redirect_uri=OAuth%3A%2F%2F&response_type=code"];
    [[UIApplication sharedApplication] openURL:githubAuthURL];
    
}

-(NSURL*) createFileURLFor:(UIImage*)photo On:(NSString*)pathComponent
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pathComponent];
    
    [UIImageJPEGRepresentation(photo, 1) writeToFile:savedImagePath atomically:YES];
    NSURL *fileURL = [NSURL fileURLWithPath:savedImagePath];
    return fileURL;
}

-(void) sendToInstagram:(UIImage*)extractedPhoto
{
    NSURL* fileURL = [self createFileURLFor:extractedPhoto On:@"test.ig"];
    
    self.interactionController= [self setupControllerWithURL:fileURL usingDelegate:self];
    
    self.interactionController.annotation = @{@"InstagramCaption":@"#doSthg"};
    self.interactionController.UTI =@"com.instagram.photo";
    
    [self.interactionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
}

- (NSString*) photoFilePath {
    return [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],@"tempinstgramphoto.igo"];
}

@end
