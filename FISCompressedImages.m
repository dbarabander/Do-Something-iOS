//
//  FISCompressedImages.m
//  FISDoSomething
//
//  Created by Ismail Mustafa on 12/4/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISCompressedImages.h"
#import "Campaign+HelperMethods.h"
#import <GPUImage/GPUImage.h>
#import "UIImage+SaveLocal.h"

@implementation FISCompressedImages

+ (instancetype)sharedCompressedImages {
    static FISCompressedImages *_sharedCompressedImages = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCompressedImages = [[FISCompressedImages alloc] init];
    });
    return _sharedCompressedImages;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _campaignImages = [NSMutableDictionary new];
    }
    return self;
}

- (void)cacheImageForCampaign:(Campaign *)campaign
        withCompletionHandler:(void (^)())completionHandler
{
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        NSString *landscapeImagePath = campaign.landscapeImage;
        UIImage *normalImage = [UIImage getImageWithPath:landscapeImagePath];
        if (normalImage) {
            UIImage *blurredImage = [self blurImage:normalImage];
            [self.campaignImages setObject:@{@"normal" : normalImage,
                                             @"blurred" : blurredImage}
                                    forKey:campaign.nid];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler();
            }];
        }
    }];
}

- (UIImage *)imageForCampaign:(Campaign *)campaign
{
    NSDictionary *images = [self.campaignImages objectForKey:campaign.nid];
    UIImage *image = images[@"normal"];
    if (image) {
        return image;
    }
    else {
        return nil;
    }
}

- (UIImage *)blurredImageForCampaign:(Campaign *)campaign
{
    NSDictionary *images = [self.campaignImages objectForKey:campaign.nid];
    UIImage *image = images[@"blurred"];
    if (image) {
        return image;
    }
    else {
        return nil;
    }
}


- (UIImage *)blurImage:(UIImage *)image
{
    GPUImageiOSBlurFilter *blurFilter = [GPUImageiOSBlurFilter new];
    blurFilter.blurRadiusInPixels = 5.0;
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    return blurredImage;
}

@end
