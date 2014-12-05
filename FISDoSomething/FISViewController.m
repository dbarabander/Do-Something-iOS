//
//  ViewController.m
//  FISDoSomething
//
//  Created by DANIEL BARABANDER on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISViewController.h"
#import "FISEventSwipeViewController.h"
#import "FISChosenEventsTableViewController.h"
#import "FISLoginRegisterTableViewController.h"

@interface FISViewController () <FISEventSwipeViewControllerProtocol>

@property (strong, nonatomic) UIScrollView *scrollView;
@property BOOL *isLoggedIn;

@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationItem.rightBarButtonItem.title = @"BLAH BLAH BLAH";
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Initalize scroll view
    self.scrollView = [[UIScrollView alloc]
                       initWithFrame:CGRectMake(0,
                                                0,
                                                self.view.frame.size.width,
                                                self.view.frame.size.height)];
    self.scrollView.scrollEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    self.view.backgroundColor = [UIColor blackColor];

    [self checkIsLoggedIn];


}

- (void)checkIsLoggedIn
{
    if (self.isLoggedIn) {
        // Initalize left most view controller
        FISEventSwipeViewController *eventSwipeViewController = [[FISEventSwipeViewController alloc] init];
        [self setUpViewController:eventSwipeViewController];
        [self setUpScrollview];

    } else {
        UINavigationController *loginRegisterNavVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"loginRegisterNavController"];
        [self setUpViewController:loginRegisterNavVC];
    }
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

- (void)setUpScrollview
{
    // Set scroll view size
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);
    self.scrollView.pagingEnabled = YES;

    // Start at left most
    CGPoint leftScrollView = CGPointMake(0, 0);
    [self.scrollView setContentOffset:leftScrollView];

    // Hide scroll view indicators
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    [super prepareForSegue:segue sender:sender];
//
//    if ([segue.identifier isEqualToString:@"settingsSegue"]) {
//        UINavigationController *navController = [segue destinationViewController];
//        QCTSettingsTableViewController *settingsViewController = (QCTSettingsTableViewController *)([navController viewControllers][0]);
//        settingsViewController.currentUser = _viewingUser;
//    } else {
//        UIViewController *destinationViewController = [segue destinationViewController];
//        if ([destinationViewController isKindOfClass:[UINavigationController class]]) {
//            UIViewController *rootViewController = [[(UINavigationController *)destinationViewController viewControllers] firstObject];
//            if ([rootViewController isKindOfClass:[QCTCreatePollTableViewController class]]) {
//                QCTCreatePollTableViewController *createPollViewController = (QCTCreatePollTableViewController *)rootViewController;
//                createPollViewController.pollCreationDelegate = self;
//                createPollViewController.viewingUser = _viewingUser;
//            }
//        }
//    }
//}

//
//}


@end
