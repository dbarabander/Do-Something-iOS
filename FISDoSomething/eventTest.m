//
//  eventTest.m
//  FISDoSomething
//
//  Created by Karim Mourra on 11/25/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "eventTest.h"

@implementation eventTest


-(instancetype) initWithTitle:(NSString*)title Detail:(NSString*)detail Image:(UIImage*)image Completed:(BOOL)completed
{
    self = [super init];
    if (self)
    {
        _title = title;
        _detail = detail;
        _image = image;
        _completed = completed;
    }
    return self;
}

@end
