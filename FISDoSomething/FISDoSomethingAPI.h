//
//  FISDoSomethingAPI.h
//  FISDoSomething
//
//  Created by Levan Toturgul on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Campaign.h"
@interface FISDoSomethingAPI : NSObject

//  Basic Campaign Info
+ (void)retrieveAllActiveCampaignsWithCompletionHandler:(void (^)(NSArray * campaigns))completionHandler;


// Advanced Campaign Info
+ (void)retrieveMoreInfoOnCampaign:(Campaign *)campaign
             withCompletionHandler:(void (^)())completionHandler;

// Download image for campaign
+ (void)retrieveImageForCampaign:(Campaign *)campaign
                     inLandscape:(BOOL)landscape
           withCompletionHandler:(void (^)(UIImage *image))completionHandler;
@end
