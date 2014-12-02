//
//  Campaign.h
//  FISDoSomething
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Campaign : NSManagedObject

@property (nonatomic, retain) NSString * callToAction;
@property (nonatomic, retain) NSString * coverImageLandscapeURL;
@property (nonatomic, retain) NSString * coverImageSquareURL;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * factProblem;
@property (nonatomic, retain) NSString * factSolution;
@property (nonatomic, retain) NSData * factSources;
@property (nonatomic, retain) NSNumber * isStaffPick;
@property (nonatomic, retain) NSData * itemsNeeded;
@property (nonatomic, retain) NSData * landscapeImage;
@property (nonatomic, retain) NSString * locationFinderInfo;
@property (nonatomic, retain) NSString * locationFinderURL;
@property (nonatomic, retain) NSNumber * nid;
@property (nonatomic, retain) NSString * photoStep;
@property (nonatomic, retain) NSString * postStep;
@property (nonatomic, retain) NSString * preStep;
@property (nonatomic, retain) NSString * promotingTips;
@property (nonatomic, retain) NSString * scholarship;
@property (nonatomic, retain) NSData * squareImage;
@property (nonatomic, retain) NSString * timeAndPlace;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * valueProposition;
@property (nonatomic, retain) NSString * vips;
@property (nonatomic, retain) NSNumber * statsSignups;

@end
