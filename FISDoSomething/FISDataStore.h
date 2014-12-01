//
//  FISDataStore.h
//  FISDoSomething
//
//  Created by Levan Toturgul on 11/26/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

//------HOW TO USE THIS API-------------------------------------
/*
 
 HOW THE METHODS WORK
 
 - USE THE FIRST METHOD TO GET FILL THE CAMPAIGNS ARRAY PROPERTY
   IN THIS DATA STORE WITH BASIC INFORMATION ON THE CAMPAIGNS. THIS
   INCLUDES THE "TITLE", "NID", AND "ISSTAFF
 - Use the first method to fill the campaigns array in the data store
   with basic info about those campaigns. This includes the "title",
   "nid", and "isStaffPick" properties. 
 - When you want more information on a specific campaign, you pass that
   campaign into the second method, this method fills up most of the next
   17 properties associated with the FISCampaign model. You can look at these
   properties in the class definition. The properties are split by section to
   make it easier to understand. Remember that with the second method,
   you are directly modifying the campaign object you passed into the method,
   so the completion handler has no parameters. It's just there to tell you that
   the object has been filled out. (TWO OF THE PROPERTIES IN THE CAMPAIGN CLASS
   ARE THE IMAGE LINKS. YOU NEED TO CALL THIS METHOD BEFORE USING THE THIRD METHOD
   TO DOWNLOAD THE IMAGE).
 - The third method will actually download the image associated with the campaign
   you passed in. There are two images associated with a campaign object; a "square"
   image, and a "landscape" image. You pick which one using the "landscape" BOOL 
   property. "YES" means landscape, "NO" means square. Out of convenience, the
   completion handler returns the image that was downloaded but there are two
   image properties in the campaign class, one for each image. These are the
   properties that hold the image in case you ever need to get access to it again.
 
 --------------------------------------------------------------
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FISCampaign;

@interface FISDataStore : NSObject

@property (strong, nonatomic) NSArray *campaigns;

+ (instancetype)sharedDataStore;

//  Basic Campaign Info
- (void)getAllActiveCampaignsWithCompletionHandler:(void (^)())completionHandler;


// Advanced Campaign Info
- (void)getMoreInfoOnCampaign:(FISCampaign *)campaign
             withCompletionHandler:(void (^)())completionHandler;

// Download image for campaign
- (void)getImageForCampaign:(FISCampaign *)campaign
                     inLandscape:(BOOL)landscape
           withCompletionHandler:(void (^)(UIImage *image))completionHandler;


@end
