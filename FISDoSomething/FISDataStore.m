//
//  FISDataStore.m
//  FISDoSomething
//
//  Created by Levan Toturgul on 11/26/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISDataStore.h"
#import "FISDoSomethingAPI.h"

@implementation FISDataStore


+ (instancetype)sharedDataStore {
    static FISDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISDataStore alloc] init];
    });
    return _sharedDataStore;
}

//  Basic Campaign Info
- (void)getAllActiveCampaignsWithCompletionHandler:(void (^)())completionHandler
{
    [FISDoSomethingAPI retrieveAllActiveCampaignsWithCompletionHandler:^(NSArray *campaigns) {
        self.campaigns = campaigns;
        completionHandler();
    }];
}


// Advanced Campaign Info
- (void)getMoreInfoOnCampaign:(FISCampaign *)campaign
        withCompletionHandler:(void (^)())completionHandler
{
    [FISDoSomethingAPI retrieveMoreInfoOnCampaign:campaign withCompletionHandler:^{
        completionHandler();
    }];
    
}

// Download image for campaign
- (void)getImageForCampaign:(FISCampaign *)campaign
                inLandscape:(BOOL)landscape
      withCompletionHandler:(void (^)(UIImage *image))completionHandler
{
    [FISDoSomethingAPI retrieveImageForCampaign:campaign
                                    inLandscape:landscape
                          withCompletionHandler:^(UIImage *image) {
                              completionHandler(image);
    }];
}

@end
