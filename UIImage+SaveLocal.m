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
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@.jpg", campaign.title,
                           [campaign.nid stringValue], imageType];
    NSString *fullPath = [self documentsPathForFileName:imageName];
    [data writeToFile:fullPath atomically:YES];
    return fullPath;
}

+ (UIImage *)getImageWithPath:(NSString *)filePath
{
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}


@end
