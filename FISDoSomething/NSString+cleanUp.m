//
//  NSString+HTML.m
//  FISDoSomething
//
//  Created by Levan Toturgul on 11/26/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "NSString+cleanUp.h"

@implementation NSString (cleanUp)

-(NSString *) stringByCleaningUpString {
    
    if (self) {
        // HTML Cleanup
        NSRange range;
        NSString *cleanedUpString = [self copy];
        while ((range = [cleanedUpString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            cleanedUpString = [cleanedUpString stringByReplacingCharactersInRange:range withString:@""];
        
        // \n cleanup
        cleanedUpString = [cleanedUpString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        return cleanedUpString;
    }
    else {
        return @"";
    }
}

- (NSString *) stringByCleaningUpHTML
{
    if (self) {
        // HTML Cleanup
        NSRange range;
        NSString *cleanedUpString = [self copy];
        while ((range = [cleanedUpString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            cleanedUpString = [cleanedUpString stringByReplacingCharactersInRange:range withString:@""];
        return cleanedUpString;
    }
    else {
        return @"";
    }
}


@end
