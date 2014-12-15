//
//  FISPhotoDisplayViewController.m
//  FISDoSomething
//
//  Created by Karim Mourra on 12/15/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISPhotoDisplayViewController.h"
#import "FISDoSomethingAPI.h"



@interface FISPhotoDisplayViewController ()

@property (strong, nonatomic) UIButton *yesButton;
@property (strong, nonatomic) UIButton *noButton;
@property (strong, nonatomic) UILabel *pageTitle;
@property (strong, nonatomic) UIImageView *displayPicture;

@end

@implementation FISPhotoDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpDisplayOfPicture];
    [self setUpNoButton];
    [self setUpYesButton];
    [self setUpPageTitle];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpDisplayOfPicture
{
    self.displayPicture = [[UIImageView alloc] initWithImage:self.takenPhoto];//WithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 100)];
    [self.view addSubview:self.displayPicture];
    self.displayPicture.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *selectedPictureY = [NSLayoutConstraint constraintWithItem:self.displayPicture
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    NSLayoutConstraint *selectedPictureHeight = [NSLayoutConstraint constraintWithItem:self.displayPicture
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:0.75
                                                                      constant:0.0];
    
    NSLayoutConstraint *selectedPictureWidth = [NSLayoutConstraint constraintWithItem:self.displayPicture
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:0.75
                                                                     constant:0.0];
    
    NSLayoutConstraint *selectedPictureX = [NSLayoutConstraint constraintWithItem:self.displayPicture
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0.0];
    
    [self.view addConstraints:@[selectedPictureY, selectedPictureHeight, selectedPictureWidth, selectedPictureX]];
}
-(void) setUpYesButton
{
    self.yesButton = [[UIButton alloc] init];
    [self.view addSubview:self.yesButton];
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.yesButton.layer.cornerRadius=10.0f;
    self.yesButton.layer.masksToBounds=YES;
    [self.yesButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Yes!" attributes:nil] forState:UIControlStateNormal];
    self.yesButton.titleLabel.textColor=[UIColor whiteColor];
    [self.yesButton addTarget:self action:@selector(yesButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.yesButton addTarget:self action:@selector(yesButtonNormal) forControlEvents:UIControlEventTouchDown];
    
    self.yesButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    NSLayoutConstraint *yesButtonTop = [NSLayoutConstraint constraintWithItem:self.yesButton
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.displayPicture
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:20.0];
    
    NSLayoutConstraint *yesButtonBottom = [NSLayoutConstraint constraintWithItem:self.yesButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-20.0];
    
    NSLayoutConstraint *yesButtonWidth = [NSLayoutConstraint constraintWithItem:self.yesButton
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:0.5
                                                                       constant:-30.0];
    
    NSLayoutConstraint *yesButtonRight = [NSLayoutConstraint constraintWithItem:self.yesButton
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:-20.0];
    
    [self.view addConstraints:@[yesButtonTop, yesButtonBottom, yesButtonWidth, yesButtonRight]];
}

- (void)yesButtonTapped
{
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.yesButton.titleLabel.textColor=[UIColor whiteColor];

    [self popUpInitialSharingPropmt:self.takenPhoto];
}

-(void)yesButtonNormal
{
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.016 green:0.341 blue:0.22 alpha:1];
}

-(void) setUpNoButton
{
    self.noButton = [[UIButton alloc] init];
    [self.view addSubview:self.noButton];
    self.noButton.backgroundColor=[UIColor redColor];
    self.noButton.layer.cornerRadius=10.0f;
    self.noButton.layer.masksToBounds=YES;
    [self.noButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cancel" attributes:nil] forState:UIControlStateNormal];
    self.noButton.titleLabel.textColor=[UIColor whiteColor];
    [self.noButton addTarget:self action:@selector(noButtonNormal) forControlEvents:UIControlEventTouchDown];
    [self.noButton addTarget:self action:@selector(noButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.noButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    NSLayoutConstraint *noButtonTop = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.displayPicture
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:20.0];
    
    NSLayoutConstraint *noButtonBottom = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:-20.0];
    
    NSLayoutConstraint *noButtonWidth = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:0.5
                                                                      constant:-30.0];
    
    NSLayoutConstraint *noButtonLeft = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:20.0];
    
    [self.view addConstraints:@[noButtonTop, noButtonBottom, noButtonWidth, noButtonLeft]];
}

- (void)noButtonTapped
{
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.yesButton.titleLabel.textColor=[UIColor whiteColor];
    [self dismissViewControllerAnimated:YES completion:^{
        
        //return to selected and summon picker
        
    }];
}

-(void)noButtonNormal
{
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.016 green:0.341 blue:0.22 alpha:1];
}

-(void) setUpPageTitle
{
    self.pageTitle = [[UILabel alloc] init];
    [self.view addSubview:self.pageTitle];
    self.pageTitle.backgroundColor=[UIColor clearColor];
    self.pageTitle.layer.cornerRadius=10.0f;
    self.pageTitle.layer.masksToBounds=YES;
    [self.pageTitle setAttributedText:[[NSAttributedString alloc] initWithString:@"Proceed with this Picture?"]];
    self.pageTitle.textColor = [UIColor whiteColor];
    self.pageTitle.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    NSLayoutConstraint *pageTitleBottom = [NSLayoutConstraint constraintWithItem:self.pageTitle
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.displayPicture
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:-20.0];
    
    NSLayoutConstraint *pageTitleTop = [NSLayoutConstraint constraintWithItem:self.pageTitle
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:-20.0];
    
    NSLayoutConstraint *pageTitleWidth = [NSLayoutConstraint constraintWithItem:self.pageTitle
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1
                                                                       constant:0.0];
    
    NSLayoutConstraint *pageTitleX = [NSLayoutConstraint constraintWithItem:self.pageTitle
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    [self.view addConstraints:@[pageTitleTop, pageTitleBottom, pageTitleWidth, pageTitleX]];
}


-(BOOL)systemVersionLessThan8
{
    CGFloat deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    return deviceVersion < 8.0f;
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL
                                               usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    UIDocumentInteractionController *interactionController =
    [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1)
    {
        // popUpPropmtoForUploadingToAPI
        
        if(buttonIndex == 0){
            [self popUpPrompt:@"Share on Social Media instead?" ForSocialMediaSharing:self.takenPhoto];
        }else if (buttonIndex == 1){
            [self popUpPrompt:@"Success! You just pushed to the API!" ForSocialMediaSharing:self.takenPhoto];
        }
    }
    else if (alertView.tag ==2)
    {// -(void)popUpPrompt:(NSString*)phrase ForSocialMediaSharing:(UIImage*)photo
        if (buttonIndex == 1){
            [self sendToInstagram:self.takenPhoto WithBlock:^{
                
            }];
        }
    }
    
}

-(void)popUpInitialSharingPropmt:(UIImage*)photo
{
    if ([self systemVersionLessThan8])
    {
        UIAlertView* mediaAlert = [[UIAlertView alloc] initWithTitle:@"Great! You selected a Picture!" message:@"Post to our API?" delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"OK!", nil];
        
        mediaAlert.tag = 1;
        
        [mediaAlert show];
    }
    else
    {
        
        UIAlertController* shareAlert = [UIAlertController alertControllerWithTitle:@"Great! You selected a Picture!" message:@"How would you like to share it?" preferredStyle:UIAlertControllerStyleAlert];
        
        NSURL* fileURL = [self createFileURLFor:photo On:@"sendToAPI.jpg"];
        
        UIAlertAction* SendToWebSite = [UIAlertAction
                                        actionWithTitle:@"Post to API!"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action){[FISDoSomethingAPI post:photo from:fileURL ToWebsiteWithCompletionHandler:
                                                                          ^{
                                                                              [self popUpPrompt:@"Success! You just pushed to the API!" ForSocialMediaSharing:photo];
                                                                          }];
                                        }];
        [shareAlert addAction:SendToWebSite];
        
        UIAlertAction* shareOnSocialMedia = [UIAlertAction
                                             actionWithTitle:@"Post on Social Media!"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *action){[FISDoSomethingAPI post:photo from:fileURL ToWebsiteWithCompletionHandler:
                                                                               ^{
                                                                                   [self sendToInstagram:photo WithBlock:^{
                                                                                       [self popUpPrompt:@"Great job!" ForAPISharing:photo];
                                                                                   }];
                                                                               }];
                                             }];
        [shareAlert addAction:shareOnSocialMedia];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [shareAlert addAction:cancel];
        [self presentViewController:shareAlert animated:YES completion:^{
        }];
    }
}

-(void)popUpPrompt:(NSString*)phrase ForSocialMediaSharing:(UIImage*)photo
{
    if ([self systemVersionLessThan8])
    {
        UIAlertView* mediaAlert = [[UIAlertView alloc] initWithTitle:phrase message:@"Would you like to share on Social Media as well?" delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Yes!", nil];
        
        mediaAlert.tag = 2;
        
        [mediaAlert show];
    }
    else
    {
        UIAlertController* shareAlert = [UIAlertController alertControllerWithTitle:phrase message:@"Would you like to share on Social Media as well?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* shareOnSocialMedia = [UIAlertAction actionWithTitle:@"Yes!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self sendToInstagram:photo WithBlock:^{
                
            }];
        }];
        
        [shareAlert addAction:shareOnSocialMedia];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        [shareAlert addAction:cancel];
        
        [self presentViewController:shareAlert animated:YES completion:^{
            
        }];
    }
    
}

-(void)popUpPrompt:(NSString*)phrase ForAPISharing:(UIImage*)photo
{
    if ([self systemVersionLessThan8])
    {
        UIAlertView* mediaAlert = [[UIAlertView alloc] initWithTitle:phrase message:@"Would you like to poste to our API as well?" delegate:self cancelButtonTitle:@"Not now" otherButtonTitles:@"Yes!", nil];
        
        mediaAlert.tag = 2;
        
        [mediaAlert show];
    }
    else
    {
        UIAlertController* shareAlert = [UIAlertController alertControllerWithTitle:phrase message:@"Would you like to post to our API as well?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSURL* fileURL = [self createFileURLFor:photo On:@"sendToAPI.jpg"];
        
        UIAlertAction* shareOnSocialMedia = [UIAlertAction actionWithTitle:@"Yes!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
        {
            [FISDoSomethingAPI post:photo from:fileURL ToWebsiteWithCompletionHandler:^{
                UIAlertController* successAlert = [UIAlertController alertControllerWithTitle:@"Well done!" message:@"You successfully posted to the API!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* done = [UIAlertAction actionWithTitle:@"Done!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:successAlert completion:^{
                        [self dismissViewControllerAnimated:self completion:^{
                            
                        }];
                    }];
                }];
                
                [successAlert addAction:done];
                
                [self presentViewController:successAlert animated:YES completion:^{
                    
                }];
            }];
        }];
        
        [shareAlert addAction:shareOnSocialMedia];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
        [shareAlert addAction:cancel];
        
        [self presentViewController:shareAlert animated:YES completion:^{
            
        }];
    }
    
}

- (NSString*) photoFilePath {
    return [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],@"tempinstgramphoto.igo"];
}

-(NSURL*) createFileURLFor:(UIImage*)photo On:(NSString*)pathComponent
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pathComponent];
    
    [UIImageJPEGRepresentation(photo, 1) writeToFile:savedImagePath atomically:YES];
    NSURL *fileURL = [NSURL fileURLWithPath:savedImagePath];
    return fileURL;
}

-(void) sendToInstagram:(UIImage*)extractedPhoto WithBlock:(void (^)())completion
{
    NSURL* fileURL = [self createFileURLFor:extractedPhoto On:@"test.ig"];
    
    self.interactionController= [self setupControllerWithURL:fileURL usingDelegate:self];
    
    self.interactionController.annotation = @{@"InstagramCaption":@"#doSomethingCustomHashTag"};
    self.interactionController.UTI =@"com.instagram.photo";
    
    [self.interactionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    
    completion();
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
