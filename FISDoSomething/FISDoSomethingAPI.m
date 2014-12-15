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
#import "UIImage+SaveLocal.h"
#import "FISAmazonS3.h"



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
        campaign.landscapeImage = [responseObject saveLandscapeImageForCampaign:campaign];
        
        // Square image request
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:squareURL]];
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            campaign.squareImage = [responseObject saveSquareImageForCampaign:campaign];
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

+(void)post:(UIImage*)picture from:(NSURL*)fileURL ToWebsiteWithCompletionHandler:(void (^)())completionHandler
{
    //after blake sets up the login, we can replace hardcoded data with variables based on results from UserLogin result
    
//    [FISAmazonS3 uploadToAmazon:fileURL];
    
    NSString* recipientURL = [NSString stringWithFormat:@"https://www.dosomething.org/api/v1/campaigns/%@/reportback", @22];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:recipientURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    NSDictionary *parameters = @{@"quantity": @3,
                                 @"uid": @2230235,
                                 @"nid": @22,
                                 @"file_url": @"http://voldemortwearsarmani.files.wordpress.com/2013/01/batman-chronicles.jpg",
                                 @"why_participated": @"Test from API",
                                 @"caption": @"API Testing!"};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *jsonDataConverted = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"jsonData:%@", jsonDataConverted);
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:jsonData];
    NSLog(@"body:%@", body);
    
    NSString* sessionName = @"SSESSfb1cb9741b4d644cdf5904d0bbaacbe1";
    NSString* sessID = @"tKcickanqmrPrYYF7b2wYW4ADLvYqPoI_X4sqL53zD0";
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue: @"Pmmku70IUh96kY8qP8gVz_RxiUNbxlpMTknpz7S89f8" forHTTPHeaderField:@"X-CSRF-Token"];
    [request setValue: [[sessionName stringByAppendingString:@"="] stringByAppendingString:sessID] forHTTPHeaderField:@"Cookie"];
    [request setHTTPBody:jsonDataConverted];
    NSLog(@"request:%@, \n %d \n %@", request.HTTPMethod, [request.HTTPBody isEqual:body], request.HTTPBody);
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        completionHandler();

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        
        //here for demo!
        completionHandler();
        
    }];
    [op start];
}
@end
