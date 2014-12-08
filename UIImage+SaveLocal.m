//
//  UIImage+SaveLocal.m
//  FISDoSomething
//
//  Created by Ismail Mustafa on 12/8/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "UIImage+SaveLocal.h"
#import "Campaign+HelperMethods.h"

@implementation UIImage (SaveLocal)

- (NSString *)saveLandscapeImageForCampaign:(Campaign *)campaign
{
    return [self saveImageOfType:@"landscape" forCampaign:campaign];
}

- (NSString *)saveSquareImageForCampaign:(Campaign *)campaign
{
    return [self saveImageOfType:@"square" forCampaign:campaign];
}

- (NSString *)saveImageOfType:(NSString *)imageType forCampaign:(Campaign *)campaign
{
    NSData *data;
    if ([imageType isEqualToString:@"landscape"]) {
        data = [Campaign shrinkLandscapeImage:self];
    }
    else {
        data = [Campaign shrinkSquareImage:self];
    }
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@", campaign.title,
                           [campaign.nid stringValue], imageType];
    NSString *fullPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:imageName];
    [data writeToFile:fullPath atomically:YES];
    return fullPath;
}

+ (UIImage *)getImageWithPath:(NSString *)filePath
{
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
