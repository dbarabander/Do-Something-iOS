//
//  FISUser.m
//  FISDoSomething
//
//  Created by Levan Toturgul on 12/2/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

/* 
CLIENT INFO
CLIENT ID    908a50054bf8441e9a7fb87a7f338256
CLIENT SECRET    8678bf2b0a734178abedb57b6596575e
WEBSITE URL    http://www.flatironschool.com
REDIRECT URI    http://OAuth
*/

#import "FISUser.h"
#import <AFNetworking/AFNetworking.h>
#import "FISDataStore.h"

@implementation FISUser





/*
//DON'T FORGET to remove this from AppDelegate, file was imported there
+(void)memberLogin:(NSString*)username password:(NSString*)password{
    

    NSDictionary *parameters = @{@"username":username, @"password":password};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://www.dosomething.org/api/v1/auth/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}

*/

+(void)obtainAccessToken//:(NSString*)code{
{
    FISDataStore* dataStore = [FISDataStore sharedDataStore];
    
    
    NSDictionary *parameters = @{@"client_id":@"908a50054bf8441e9a7fb87a7f338256", @"client_secret":@"8678bf2b0a734178abedb57b6596575e", @"grant_type":@"authorization_code", @"redirect_uri":@"OAuth://", @"code":dataStore.code};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"https://api.instagram.com/oauth/access_token" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* userInstagramInfo = responseObject;
        
        dataStore.accessToken = userInstagramInfo[@"access_token"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://location?id=1"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    
    
}


@end
