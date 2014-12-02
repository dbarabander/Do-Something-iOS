//
//  Campaign+HelperMethods.h
//  FISDoSomething
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "Campaign.h"
@class FISDataStore;
@interface Campaign (HelperMethods)

// Basic Campaign info
+(void)generateCampaignsFromResponseObject:(id)responseObject withCompletionHandler:(void (^)(NSArray * campaigns))completionHandler;


// Advanced Campaign info
+(void)generateMoreDetailsForCampaign:(Campaign*)campaign withResponseObject:(id)responseObject;

@end
