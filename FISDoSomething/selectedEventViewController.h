//
//  selectedEventViewController.h
//  FISDoSomething
//
//  Created by Karim Mourra on 12/1/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventTest.h"

@interface selectedEventViewController : UIViewController <UIImagePickerControllerDelegate>

@property (strong, nonatomic) eventTest* selectedEvent;

@end
