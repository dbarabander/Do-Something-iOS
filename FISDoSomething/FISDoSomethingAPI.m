//
//  FISDoSomethingAPI.m
//  FISDoSomething
//
//  Created by Levan Toturgul on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISDoSomethingAPI.h"
#import "FISCampaign.h"
#import <AFNetworking/AFNetworking.h>



@implementation FISDoSomethingAPI

// Gets an array of all active campaigns
+(void)retrieveAllActiveCampaignsWithCompletionHandler:(void (^)(NSArray * campaigns))completionHandler
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://www.dosomething.org/api/v1/campaigns.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionHandler([FISCampaign generateCampaignsFromResponseObject:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

// Retreive specific information on any campaign
+ (void)retrieveMoreInfoOnCampaign:(FISCampaign *)campaign
             withCompletionHandler:(void (^)())completionHandler
{
    NSString *url = [NSString stringWithFormat:@"https://www.dosomething.org/api/v1/content/%@.json",campaign.nid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [FISCampaign generateMoreDetailsForCampaign:campaign withResponseObject:responseObject];
        completionHandler();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"Error: %@", error);
    }];
}

// Download image for campaign
+ (void)retrieveImageForCampaign:(FISCampaign *)campaign
                     inLandscape:(BOOL)landscape
           withCompletionHandler:(void (^)(UIImage *image))completionHandler
{
    NSString *stringURL;
    if (landscape) stringURL = campaign.coverImageLandscapeURL;
    else stringURL = campaign.coverImageSquareURL;
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:stringURL]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (landscape) campaign.landscapeImage = responseObject;
        else campaign.squareImage = responseObject;
        completionHandler(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
}

@end
