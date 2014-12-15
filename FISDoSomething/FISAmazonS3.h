//
//  FISAmazonS3.h
//  FISDoSomething
//
//  Created by Karim Mourra on 12/8/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISAmazonS3 : NSObject

+(void)uploadToAmazon:(NSURL*)pictureURL;

@end
