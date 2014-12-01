//
//  FISCampaign.h
//  FISDoSomething
//
//  Created by Levan Toturgul on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FISCampaign : NSObject

// basic campaign properties
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSNumber * nid;
@property (nonatomic) BOOL isStaffPick;


// initial exposure to campaign
@property (strong, nonatomic) NSString *callToAction;
@property (strong, nonatomic) NSDate * endDate;
@property (strong, nonatomic) NSString *valueProposition;
@property (strong, nonatomic) NSMutableArray *factSources;
@property (strong, nonatomic) NSString *coverImageLandscapeURL;
@property (strong, nonatomic) NSString *coverImageSquareURL;


// Step 1
@property (strong, nonatomic) NSString *factProblem;
@property (strong, nonatomic) NSString *factSolution;


//Step 2
@property (strong, nonatomic) NSMutableArray *itemsNeeded;
@property (strong, nonatomic) NSString *vips;
@property (strong, nonatomic) NSString *locationFinderInfo;
@property (strong, nonatomic) NSString *locationFinderURL;
@property (strong, nonatomic) NSString *timeAndPlace;
@property (strong, nonatomic) NSString *promotingTips;


//Step 3
@property (strong, nonatomic) NSString *preStep;
@property (strong, nonatomic) NSString *photoStep;
@property (strong, nonatomic) NSString *postStep;

// Images
@property (strong, nonatomic) UIImage *landscapeImage;
@property (strong, nonatomic) UIImage *squareImage;

-(instancetype) initWithTitle:(NSString*)title nid:(NSNumber *)nid isStaffPick:(BOOL)isStaffPick;

// Basic Campaign info
+(FISCampaign*)createCampaignFromDictionary:(NSDictionary*)dictionary;
+(NSArray*)generateCampaignsFromResponseObject:(id)responseObject;


// Advanced Campaign info
+(void)generateMoreDetailsForCampaign:(FISCampaign*)campaign withResponseObject:(id)responseObject;



@end
