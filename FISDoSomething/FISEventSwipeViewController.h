//
//  FISEventSwipeViewController.h
//  Cahoots
//
//  Created by Zachary Langley on 4/7/14.
//  Copyright (c) 2014 Qallect. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Campaign;

@protocol FISEventSwipeViewControllerProtocol <NSObject>

- (void)didLikeCampaign:(Campaign *)campaign;

@end

@interface FISEventSwipeViewController : UIViewController

@property (strong, nonatomic) id <FISEventSwipeViewControllerProtocol> delegate;

@end
