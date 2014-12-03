//
//  CampaignPreferences.h
//  FISDoSomething
//
//  Created by DANIEL BARABANDER on 12/3/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Campaign;

@interface CampaignPreferences : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSNumber * liked;
@property (nonatomic, retain) NSNumber * swipedTimeStamp;
@property (nonatomic, retain) Campaign *campaign;

@end
