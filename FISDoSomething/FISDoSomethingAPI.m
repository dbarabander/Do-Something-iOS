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
        campaign.landscapeImage = [Campaign shrinkLandscapeImage:responseObject];
        
        // Square image request
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:squareURL]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            campaign.squareImage = [Campaign shrinkSquareImage:responseObject];
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

+(void)postLoginToAPI:(NSDictionary *)parameters withCompletionHandler:(void (^)(id responseObject))completionHandler
{
    
    
    NSString* postURL = [NSString stringWithFormat:@"https://www.dosomething.org/api/v1/auth/login"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *jsonDataConverted = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:jsonData];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonDataConverted];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completionHandler(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        completionHandler(error);
        
    }];
    [op start];
    
}


+(void)postRegistrationToAPI:(NSDictionary *)parameters withCompletionHandler:(void (^)(id responseObject))completionHandler
{
    
    
    NSString* postURL = [NSString stringWithFormat:@"https://www.dosomething.org/api/v1/users"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *jsonDataConverted = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:jsonData];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonDataConverted];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completionHandler(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        completionHandler(error);
        
    }];
    [op start];
    
}


@end
