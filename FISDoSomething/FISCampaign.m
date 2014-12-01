//
//  FISCampaign.m
//  FISDoSomething
//
//  Created by Levan Toturgul on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISCampaign.h"
#import "NSString+cleanUp.h"
@implementation FISCampaign

-(instancetype) init{
    return [self initWithTitle:@"" nid:@-1 isStaffPick:NO];
}

-(instancetype) initWithTitle:(NSString*)title nid:(NSNumber *)nid isStaffPick:(BOOL)isStaffPick{
    
    self = [super init];
    if (self) {
        _title = title;
        _nid = nid;
        _isStaffPick = isStaffPick;
        _factSources = [NSMutableArray new];
        _itemsNeeded = [NSMutableArray new];
    }
    return self;
}

+(FISCampaign*)createCampaignFromDictionary:(NSDictionary*)dictionary{
    return [[FISCampaign alloc] initWithTitle:dictionary[@"title"] nid:dictionary[@"nid"] isStaffPick:[dictionary[@"is_staff_pick"] integerValue] == 0 ? NO : YES];
}

+(NSArray*)generateCampaignsFromResponseObject:(id)responseObject{
    NSMutableArray *allCampaigns = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tempDict in (NSArray*)responseObject) {
        FISCampaign *tempCampaign = [FISCampaign createCampaignFromDictionary:tempDict];
        
        // Remove copies
        BOOL alreadyExists = NO;
        for (FISCampaign *currentCampaign in allCampaigns) {
            if ([currentCampaign.nid integerValue] == [tempCampaign.nid integerValue]) {
                alreadyExists = YES;
                break;
            }
        }
        if (!alreadyExists) {
            [allCampaigns addObject:[FISCampaign createCampaignFromDictionary:tempDict]];
        }
    }
    
    return [NSArray arrayWithArray:allCampaigns];
}

- (NSString *)description
{
    NSString *isStaffPick = self.isStaffPick ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"\nTitle: %@\nnid: %@\nisStaffPack: %@\ncallToAction: %@\nendDate: %@\nvalueProposition: %@\nfactSources: %@\ncoverImageLandscapeURL: %@\ncoverImageSquareURL: %@\nfactProblem: %@\nfactSolution: %@\nitemsNeeded: %@\nvips: %@\nlocationFinderInfo: %@\nlocationFinderURL: %@\ntimeAndPlace: %@\npromotingTips: %@\npreStep: %@\nphotoStep: %@\npostStep: %@", self.title, self.nid, isStaffPick, self.callToAction, self.endDate, self.valueProposition, self.factSources, self.coverImageLandscapeURL, self.coverImageSquareURL, self.factProblem, self.factSolution, self.itemsNeeded, self.vips, self.locationFinderInfo, self.locationFinderURL, self.timeAndPlace, self.promotingTips, self.preStep, self.photoStep, self.postStep];
}


+(void)generateMoreDetailsForCampaign:(FISCampaign*)campaign withResponseObject:(id)responseObject{
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        // Call to action
        if ([self isNotNull:responseObject[@"call_to_action"]]) {
            campaign.callToAction = [responseObject[@"call_to_action"] stringByCleaningUpString];
        }
        else {
            campaign.callToAction = [NSString new];
        }
        
        // End date
        if ([self isNotNull:responseObject[@"end_date"]]) {
            NSLog(@"%@", responseObject[@"end_date"]);
            campaign.endDate = [NSDate dateWithTimeIntervalSince1970:[responseObject[@"end_date"] doubleValue]];
        }
        else {
            campaign.endDate = [[NSDate alloc] init];
        }
        
        // Value proposition
        if ([self isNotNull:responseObject[@"value_proposition"]]) {
            campaign.valueProposition = [responseObject[@"value_proposition"] stringByCleaningUpString];
        }
        else {
            campaign.valueProposition = [NSString new];
        }
        
        // Fact Sources
        if ([self isNotNull:responseObject[@"fact_sources"]]) {
            for (NSString *source in responseObject[@"fact_sources"])
                [campaign.factSources addObject:[source stringByCleaningUpString]];
        }
        
        // Cover Image Landscape
        if ([self isNotNull:responseObject[@"image_cover"][@"url"][@"landscape"][@"raw"]]) {
            campaign.coverImageLandscapeURL = [[NSString stringWithFormat:@"%@",responseObject[@"image_cover"][@"url"][@"landscape"][@"raw"]] stringByCleaningUpString];
        }
        else {
            campaign.coverImageLandscapeURL = [NSString new];
        }
        
        
        // Cover Image Square
        if ([self isNotNull:responseObject[@"image_cover"][@"url"][@"square"][@"raw"]]) {
            campaign.coverImageSquareURL = [[NSString stringWithFormat:@"%@",responseObject[@"image_cover"][@"url"][@"square"][@"raw"]] stringByCleaningUpString];
        }
        else {
            campaign.coverImageSquareURL = [NSString new];
        }
        
        
        // Fact Problem
        if ([self isNotNull:responseObject[@"fact_problem"]]) {
            if ([self isNotNull:responseObject[@"fact_problem"][@"fact"]]) {
                campaign.factProblem = [responseObject[@"fact_problem"][@"fact"] stringByCleaningUpString];
            }
            else {
                campaign.factProblem = [NSString new];
            }
        }
        else {
            campaign.factProblem = [NSString new];
        }
        
        // Fact Solution
        if ([self isNotNull:responseObject[@"fact_solution"]]) {
            if ([self isNotNull:responseObject[@"fact_solution"][@"fact"]]) {
                campaign.factSolution = [responseObject[@"fact_solution"][@"fact"] stringByCleaningUpString];
            }
            else {
                campaign.factSolution = [NSString new];
            }
        }
        else {
            campaign.factSolution = [NSString new];
        }
        
        // Items Needed
        if ([self isNotNull:responseObject[@"items_needed"]]) {
            NSString *itemsNeededString = [responseObject[@"items_needed"] stringByCleaningUpHTML];
            for (NSString *eachItemNeeded in [itemsNeededString componentsSeparatedByString:@"\n"]) {
                NSString *cleanedUpString = [eachItemNeeded stringByCleaningUpString];
                if ([cleanedUpString length] > 0)
                    [campaign.itemsNeeded addObject:eachItemNeeded];
            }
        }
        
        // Vips
        if ([self isNotNull:responseObject[@"vips"]]) {
            campaign.vips = [responseObject[@"vips"] stringByCleaningUpString];
        }
        else {
            campaign.vips = [NSString new];
        }
        
        // Location Finder Info
        if ([self isNotNull:responseObject[@"location_finder_copy"]]) {
            campaign.locationFinderInfo = [responseObject[@"location_finder_copy"] stringByCleaningUpString];
        }
        else {
            campaign.locationFinderInfo = [NSString new];
        }
        
        // Location Finder URL
        if ([self isNotNull:responseObject[@"location_finder_url"]]) {
            campaign.locationFinderURL = [[NSString stringWithFormat:@"%@",responseObject[@"location_finder_url"]] stringByCleaningUpString];
        }
        else {
            campaign.locationFinderURL = [NSString new];
        }
        
        // Time and Place
        if ([self isNotNull:responseObject[@"time_and_place"]]) {
            campaign.timeAndPlace = [responseObject[@"time_and_place"] stringByCleaningUpString];
        }
        else {
            campaign.timeAndPlace = [NSString new];
        }
        
        // Promoting Tips
        if ([self isNotNull:responseObject[@"promoting_tips"]]) {
            campaign.promotingTips = [responseObject[@"promoting_tips"] stringByCleaningUpString];
        }
        else {
            campaign.preStep = [NSString new];
        }
        
        
        // PreStep
        if ([self isNotNull:responseObject[@"pre_step_copy"]]) {
            campaign.preStep = [responseObject[@"pre_step_copy"] stringByCleaningUpString];
        }
        else {
            campaign.preStep = [NSString new];
        }
        
        // PhotoStep
        if ([self isNotNull:responseObject[@"photo_step"]]) {
            campaign.photoStep = [responseObject[@"photo_step"] stringByCleaningUpString];
        }
        else {
            campaign.photoStep = [NSString new];
        }
        
        // PostStep
        if ([self isNotNull:responseObject[@"post_step_copy"]]) {
            campaign.postStep = [responseObject[@"post_step_copy"] stringByCleaningUpString];
        }
        else {
            campaign.postStep = [NSString new];
        }
    }
}

+ (BOOL)isNotNull:(id)object
{
    if(![object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
