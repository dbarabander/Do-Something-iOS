//
//  FISPhotoDisplayViewController.h
//  FISDoSomething
//
//  Created by Karim Mourra on 12/15/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface FISPhotoDisplayViewController : UIViewController <QLPreviewControllerDataSource>

@property (retain)UIDocumentInteractionController *interactionController;
@property (strong, nonatomic) UIImage* takenPhoto;


@end
