//
//  eventTest.h
//  FISDoSomething
//
//  Created by Karim Mourra on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface eventTest : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* detail;
@property (strong, nonatomic) UIImage* image;
@property (nonatomic) BOOL completed;


-(instancetype) initWithTitle:(NSString*)title Detail:(NSString*)detail Image:(UIImage*)image Completed:(BOOL)completed;

@end
