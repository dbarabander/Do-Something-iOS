//
//  FISChosenEventsTableViewController.m
//  FISDoSomething
//
//  Created by Karim Mourra on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISChosenEventsTableViewController.h"
#import "FISCustomEventTableViewCell.h"
#import "FISSelectedEventViewController.h"
#import "FISEventSwipeViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "PopOverAnimation.h"
#import "Campaign.h"
#import "FISDataStore.h"
#import "FISAppFont.h"

@interface FISChosenEventsTableViewController () <FISEventSwipeViewControllerProtocol, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) NSMutableArray* eventsToDisplay;
@property (strong, nonatomic) FISEventSwipeViewController *swipeVC;

@end

@implementation FISChosenEventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FISDataStore *dataStore=[FISDataStore sharedDataStore];
    self.eventsToDisplay = [[NSMutableArray alloc] initWithArray:[dataStore getAllSavedCampaigns]];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithRed:77.0/255.0 green:43.0/255.0 blue:99.0/255.0 alpha:1.0];

    [self adjustNavigationBar];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"Any campaigns you like will show up here.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"ProximaNovaA-Bold" size:20.0],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIColor colorWithRed:77.0/255.0 green:43.0/255.0 blue:99.0/255.0 alpha:1.0];
}

- (void)adjustNavigationBar
{
    [self.navigationController.navigationBar
     setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      appFont(23),
      NSFontAttributeName, [UIColor whiteColor],
      NSForegroundColorAttributeName, nil]];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:77.0/255.0 green:43.0/255.0 blue:99.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:77.0/255.0 green:43.0/255.0 blue:99.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:77.0/255.0 green:43.0/255.0 blue:99.0/255.0 alpha:1.0];
    
}

- (void)didLikeCampaign:(Campaign *)campaign
{
    [self.eventsToDisplay addObject:campaign];
    [self.tableView reloadData];
    static BOOL firstCampaignSelected = NO;
    if (!firstCampaignSelected) {
        firstCampaignSelected = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveToSelectedCampaigns" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.eventsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FISCustomEventTableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:@"campaignCell"];
    Campaign *eventAtCell = self.eventsToDisplay[indexPath.row];
    eventCell.campaign = eventAtCell;
    return eventCell;
}

-(void) constrainImageViewToContentViewFor:(UITableViewCell*)cell
{
    NSLayoutConstraint* imageViewLeft = [NSLayoutConstraint constraintWithItem:cell.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [cell.contentView addConstraint:imageViewLeft];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    FISSelectedEventViewController *selectedEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"campaignDetailVC"];
    Campaign* selectedEvent = self.eventsToDisplay[indexPath.row];
    selectedEventVC.selectedEvent = selectedEvent;
    selectedEventVC.modalPresentationStyle = UIModalPresentationCustom;
    selectedEventVC.transitioningDelegate = self;
    [self presentViewController:selectedEventVC animated:YES completion:nil];
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    PopOverAnimation *animation = [[PopOverAnimation alloc] init];
    animation.reverse = NO;
    return animation;
}

- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController:(UIViewController *)dismissed
{
    PopOverAnimation *animation = [[PopOverAnimation alloc] init];
    animation.reverse = YES;
    return animation;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
