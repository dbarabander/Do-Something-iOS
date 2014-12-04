//
//  CampaignPreferences+HelperMethods.m
//  FISDoSomething
//
//  Created by Blake Shetter on 12/4/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "CampaignPreferences+HelperMethods.h"
#import "FISDataStore.h"
#import "Campaign.h"
@implementation CampaignPreferences (HelperMethods)


+(void)insertCampaignPreferenceswithCampaign:(Campaign *)campaign liked:(BOOL)liked{
    
    CampaignPreferences *campaignPref = [NSEntityDescription insertNewObjectForEntityForName:@"CampaignPreferences" inManagedObjectContext:[FISDataStore sharedDataStore].context];
    campaignPref.campaign=campaign;
    campaignPref.liked=[NSNumber numberWithBool:liked];
    campaignPref.swipedTimeStamp=[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    campaignPref.completed=0;
    campaign.campaignPreferences=campaignPref;
    [[FISDataStore sharedDataStore] saveContext];

}

@end
