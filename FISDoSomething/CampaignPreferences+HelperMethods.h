//
//  CampaignPreferences+HelperMethods.h
//  FISDoSomething
//
//  Created by Blake Shetter on 12/4/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "CampaignPreferences.h"

@interface CampaignPreferences (HelperMethods)
+(void)insertCampaignPreferenceswithCampaign:(Campaign *)campaign liked:(BOOL)liked;
@end
