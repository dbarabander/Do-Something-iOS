//
//  Campaign+HelperMethods.m
//  FISDoSomething
//
//  Created by Blake Shetter on 12/2/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "Campaign+HelperMethods.h"
#import "Campaign.h"
#import "FISDataStore.h"
#import "NSString+cleanUp.h"

@implementation Campaign (HelperMethods)


+(void)generateCampaignsFromResponseObject:(id)responseObject withCompletionHandler:(void (^)(NSArray * campaigns))completionHandler{
    static NSInteger returnedCount=0;
    NSMutableArray *currentObjectsArray=[[NSMutableArray alloc] init];
    NSInteger returnedTotal=[(NSArray *)responseObject count];
    
    for (NSDictionary *responseDict in (NSArray*)responseObject) {
        BOOL isTheObjectThere = [currentObjectsArray containsObject: responseDict[@"nid"]];
        if(isTheObjectThere){
            returnedTotal--;
        }
        else{
            [currentObjectsArray addObject:responseDict[@"nid"]];
            Campaign *campaign = [NSEntityDescription insertNewObjectForEntityForName:@"Campaign" inManagedObjectContext:[FISDataStore sharedDataStore].context];
            campaign.nid=responseDict[@"nid"];
            campaign.isStaffPick=responseDict[@"is_staff_pick"];
            campaign.title=responseDict[@"title"];
        
            [[FISDataStore sharedDataStore] getMoreInfoOnCampaign:campaign withCompletionHandler:^{
                returnedCount++;
                if(returnedCount == returnedTotal){
                    // perform return here
                    completionHandler([FISDataStore sharedDataStore].campaigns);
                    [[FISDataStore sharedDataStore] saveContext];
                }
            }];
        }
    }
    

}

- (NSString *)description
{
    NSString *isStaffPick = self.isStaffPick ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"\nTitle: %@\nnid: %@\nisStaffPack: %@\ncallToAction: %@\nendDate: %@\nvalueProposition: %@\nfactSources: %@\ncoverImageLandscapeURL: %@\ncoverImageSquareURL: %@\nfactProblem: %@\nfactSolution: %@\nitemsNeeded: %@\nvips: %@\nlocationFinderInfo: %@\nlocationFinderURL: %@\ntimeAndPlace: %@\npromotingTips: %@\npreStep: %@\nphotoStep: %@\npostStep: %@", self.title, self.nid, isStaffPick, self.callToAction, self.endDate, self.valueProposition, self.factSources, self.coverImageLandscapeURL, self.coverImageSquareURL, self.factProblem, self.factSolution, self.itemsNeeded, self.vips, self.locationFinderInfo, self.locationFinderURL, self.timeAndPlace, self.promotingTips, self.preStep, self.photoStep, self.postStep];
}


+(void)generateMoreDetailsForCampaign:(Campaign*)campaign withResponseObject:(id)responseObject{
    
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        [[FISDataStore sharedDataStore].context deleteObject:campaign];
    }
    else{
        [[FISDataStore sharedDataStore].campaigns addObject:campaign];

        // Call to action
        if ([self isNotNull:responseObject[@"call_to_action"]]) {
            campaign.callToAction = [responseObject[@"call_to_action"] stringByCleaningUpString];
        }
        else {
            campaign.callToAction = [NSString new];
        }
        
        // End date
        if ([self isNotNull:responseObject[@"end_date"]]) {
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
            campaign.valueProposition = @"Swipe right to see more!";
        }
        
        // Fact Sources
//        if ([self isNotNull:responseObject[@"fact_sources"]]) {
//            for (NSString *source in responseObject[@"fact_sources"])
//                [campaign.factSources addObject:[source stringByCleaningUpString]];
//        }
        NSData *factSourcesData=[NSKeyedArchiver archivedDataWithRootObject:responseObject[@"fact_sources"]];
         if ([self isNotNull:responseObject[@"fact_sources"]]) {
             campaign.factSources = factSourcesData;
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
            NSData *itemsNeededData=[NSKeyedArchiver archivedDataWithRootObject:itemsNeededString];

            campaign.itemsNeeded = itemsNeededData;
//            for (NSString *eachItemNeeded in [itemsNeededString componentsSeparatedByString:@"\n"]) {
//                NSString *cleanedUpString = [eachItemNeeded stringByCleaningUpString];
//                if ([cleanedUpString length] > 0)
//                    [campaign.itemsNeeded addObject:eachItemNeeded];
//            }
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

        if ([self isNotNull:responseObject[@"stats_signups"]]) {
            campaign.statsSignups = responseObject[@"stats_signups"] ;
        }
        else {
            campaign.statsSignups = 0;
        }
}
}

+ (NSData *)shrinkLandscapeImage:(UIImage *)landscapeImage
{
    CGFloat ratio = landscapeImage.size.width/landscapeImage.size.height;
    CGFloat newHeight = landscapeImage.size.height * 0.5;
    CGSize newSize = CGSizeMake(newHeight*ratio, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [landscapeImage drawInRect:(CGRect){.origin = CGPointZero, .size = newSize}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.8);
    UIGraphicsEndImageContext();
    return imageData;
    //return UIImagePNGRepresentation(newImage);
}

+ (NSData *)shrinkSquareImage:(UIImage *)squareImage
{
    CGFloat newHeight = squareImage.size.height * 0.5;
    CGSize newSize = CGSizeMake(newHeight, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [squareImage drawInRect:(CGRect){.origin = CGPointZero, .size = newSize}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.8);
    UIGraphicsEndImageContext();
    return imageData;
    //return UIImagePNGRepresentation(newImage);
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
