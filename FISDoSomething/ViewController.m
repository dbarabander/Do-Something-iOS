//
//  ViewController.m
//  FISDoSomething
//
//  Created by DANIEL BARABANDER on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "ViewController.h"
#import "FISEventSwipeViewController.h"
#import "FISChosenEventsTableViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ViewController

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
    
    // Initalize left most view controller
    FISEventSwipeViewController *eventSwipeViewController = [[FISEventSwipeViewController alloc] init];
    CGRect eventSwipeVCFrame = eventSwipeViewController.view.frame;
    eventSwipeVCFrame.origin.x = 0;
    eventSwipeViewController.view.frame = eventSwipeVCFrame;
    [self addChildViewController:eventSwipeViewController];
    [self.scrollView addSubview:eventSwipeViewController.view];
    [eventSwipeViewController didMoveToParentViewController:self];
    
    FISChosenEventsTableViewController *randomVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"chosenEventsTVC"];
    CGRect randomVCFrame = randomVC.view.frame;
    randomVCFrame.origin.x = self.view.frame.size.width;
    randomVC.view.frame = randomVCFrame;
    [self addChildViewController:randomVC];
    [self.scrollView addSubview:randomVC.view];
    [randomVC didMoveToParentViewController:self];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
