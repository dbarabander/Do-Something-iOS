//
//  UIImage+SaveLocal.h
//  FISDoSomething
//
//  Created by Ismail Mustafa on 12/8/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Campaign;

@interface UIImage (SaveLocal)

- (NSString *)saveLandscapeImageForCampaign:(Campaign *)campaign;
- (NSString *)saveSquareImageForCampaign:(Campaign *)campaign;
+ (UIImage *)getImageWithPath:(NSString *)filePath;

@end
