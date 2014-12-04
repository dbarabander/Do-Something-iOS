//
//  FISCompressedImages.h
//  FISDoSomething
//
//  Created by Ismail Mustafa on 12/4/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Campaign;

@interface FISCompressedImages : NSObject

@property (strong, nonatomic) NSMutableDictionary *campaignImages;

+ (instancetype)sharedCompressedImages;

- (void)cacheImageForCampaign:(Campaign *)campaign
        withCompletionHandler:(void (^)())completionHandler;

- (UIImage *)imageForCampaign:(Campaign *)campaign;
- (UIImage *)blurredImageForCampaign:(Campaign *)campaign;

@end

