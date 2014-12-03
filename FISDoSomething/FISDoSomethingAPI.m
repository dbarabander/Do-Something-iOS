//
//  FISDoSomethingAPI.m
//  FISDoSomething
//
//  Created by Levan Toturgul on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISDoSomethingAPI.h"
#import "Campaign+HelperMethods.h"
#import <AFNetworking/AFNetworking.h>



@implementation FISDoSomethingAPI

// Gets an array of all active campaigns
+(void)retrieveAllActiveCampaignsWithCompletionHandler:(void (^)(NSArray * campaigns))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://www.dosomething.org/api/v1/campaigns.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Campaign generateCampaignsFromResponseObject:responseObject withCompletionHandler:^(NSArray *campaigns) {
            completionHandler(campaigns);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

// Retreive specific information on any campaign
+ (void)retrieveMoreInfoOnCampaign:(Campaign *)campaign
             withCompletionHandler:(void (^)())completionHandler
{
    NSString *url = [NSString stringWithFormat:@"https://www.dosomething.org/api/v1/content/%@.json",campaign.nid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Campaign generateMoreDetailsForCampaign:campaign withResponseObject:responseObject];
        completionHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"Error: %@", error);
    }];
}

// Download images for campaign
+ (void)retrieveImagesForCampaign:(Campaign *)campaign
           withCompletionHandler:(void (^)())completionHandler
{
    NSString *landscapeURL = campaign.coverImageLandscapeURL;
    NSString *squareURL = campaign.coverImageSquareURL;
    
    if (!landscapeURL) {
        landscapeURL = @"https://dosomething-a.akamaihd.net/profiles/dosomething/themes/dosomething/paraneue_dosomething/logo.png";
    }
    if (!squareURL) {
        squareURL = @"https://dosomething-a.akamaihd.net/profiles/dosomething/themes/dosomething/paraneue_dosomething/logo.png";
    }
    
    // Landscape image request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:landscapeURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *imageData = UIImagePNGRepresentation(responseObject);
        campaign.landscapeImage = imageData;
        
        // Square image request
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:landscapeURL]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *imageData = UIImagePNGRepresentation(responseObject);
            campaign.squareImage = imageData;
            completionHandler();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
        }];
        [requestOperation start];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}

@end
