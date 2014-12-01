//
//  FISChosenEventsTableViewController.m
//  FISDoSomething
//
//  Created by Karim Mourra on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISChosenEventsTableViewController.h"
#import "FISCustomEventTableViewCell.h"
#import "selectedEventViewController.h"

@interface FISChosenEventsTableViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSMutableArray* eventsToDisplay;
- (IBAction)segmentChanged:(id)sender;

@end

@implementation FISChosenEventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTestData];
    
    [self.segmentedControl setTitle:@"All" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:@"Completed" forSegmentAtIndex:1];

}

-(void)createTestData
{
    UIImage* image1 = [UIImage imageNamed:@"image1.jpeg"];
    UIImage* image2 = [UIImage imageNamed:@"image2.jpg"];
    UIImage* image3 = [UIImage imageNamed:@"image3.jpg"];
    UIImage* image4 = [UIImage imageNamed:@"image4.jpg"];
    UIImage* image5 = [UIImage imageNamed:@"image5.jpg"];

    eventTest* eventTest1 = [[eventTest alloc]initWithTitle:@"Title1" Detail:@"Detail1" Image:image1 Completed:YES];
    eventTest* eventTest2 = [[eventTest alloc]initWithTitle:@"Title2" Detail:@"Detail2" Image:image2 Completed:NO];
    eventTest* eventTest3 = [[eventTest alloc]initWithTitle:@"Title3" Detail:@"Detail3" Image:image3 Completed:NO];
    eventTest* eventTest4 = [[eventTest alloc]initWithTitle:@"Title4" Detail:@"Detail4" Image:image4 Completed:YES];
    eventTest* eventTest5 = [[eventTest alloc]initWithTitle:@"Title5" Detail:@"Detail5" Image:image5 Completed:YES];
    
    self.chosenEvents = [[NSMutableArray alloc] initWithObjects:eventTest1,eventTest2, eventTest3, eventTest4, eventTest5, nil];
    self.eventsToDisplay = self.chosenEvents;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"standardCell" forIndexPath:indexPath];

    eventTest* eventAtCell = self.eventsToDisplay[indexPath.row];
    
    UIImage* fullCellImage = [self resizeImage:eventAtCell.image width:cell.contentView.frame.size.width height:cell.contentView.frame.size.height];


    NSLog(@"imageViewX:%f, contentViewX:%f", cell.imageView.frame.origin.x, cell.contentView.frame.origin.x);
    cell.imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    cell.imageView.frame.origin.x = cell.imageView.frame.origin.x - 16;
    
    [self constrainImageViewToContentViewFor:cell];
    
//    cell.imageView.frame.origin.x = cell.contentView.frame.origin.x;
    cell.imageView.image = fullCellImage;

    [self addOverlayOnCell:cell];
    [self addTitle:eventAtCell.title OnCell:cell];
     
     [cell.contentView layoutSubviews];
     
     
     return cell;
}

-(void) constrainImageViewToContentViewFor:(UITableViewCell*)cell
{
    NSLayoutConstraint* imageViewLeft = [NSLayoutConstraint constraintWithItem:cell.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [cell.contentView addConstraint:imageViewLeft];
}

- (IBAction)segmentChanged:(id)sender {
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            //display all
            self.eventsToDisplay =[@[] mutableCopy];
            [self.eventsToDisplay addObjectsFromArray:self.chosenEvents];
            [self.tableView reloadData];
            break;
            
        case 1:
            //display finished
            self.eventsToDisplay =[@[] mutableCopy];
            for (eventTest* event in self.chosenEvents)
            {
                if (event.completed)
                {
                    [self.eventsToDisplay addObject:event];
                }
            }
            
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}
    



-(void) addOverlayOnCell:(UITableViewCell*)cell
{
    if ([cell.imageView.subviews count] >0)
    {
        for (UIView* subView in cell.imageView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    
    UIView* overlayView = [[UIView alloc] initWithFrame:CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.size.height *0.73f, cell.contentView.frame.size.width, cell.contentView.frame.size.height *0.27f )];
    
    overlayView.backgroundColor = [UIColor grayColor];
    overlayView.alpha = 0.75;
    [cell.imageView addSubview:overlayView];
}

-(void) addTitle:(NSString*)title OnCell:(UITableViewCell*)cell
{
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.origin.x + 50, cell.contentView.frame.size.height *0.73f, cell.contentView.frame.size.width, cell.contentView.frame.size.height *0.27f)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    
    [cell.imageView addSubview:titleLabel];
}

-(UIImage *)resizeImage:(UIImage *)image width:(int)width height:(int)height
{
    CGImageRef imageRef = [image CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    alphaInfo = kCGImageAlphaNoneSkipLast;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef),
                                                4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [self constrainImageViewToContentViewFor:cell];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    selectedEventViewController* selectedEventVC = segue.destinationViewController;
    
    NSIndexPath* selectedIp = [self.tableView indexPathForSelectedRow];
    eventTest* selectedEvent = self.eventsToDisplay[selectedIp.row];
    selectedEventVC.selectedEvent = selectedEvent;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
