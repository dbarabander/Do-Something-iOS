//
//  selectedEventViewController.h
//  FISDoSomething
//
//  Created by Karim Mourra on 12/1/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@class Campaign;

@interface FISSelectedEventViewController : UIViewController <UIImagePickerControllerDelegate, UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource>

@property (strong, nonatomic) Campaign *selectedEvent;
@property (retain)UIDocumentInteractionController *interactionController;

@end
