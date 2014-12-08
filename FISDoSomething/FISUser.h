//
//  FISUser.h
//  FISDoSomething
//
//  Created by Levan Toturgul on 12/2/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISDataStore.h"

@interface FISUser : NSObject
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;



+(void)memberLogin:(NSString*)username password:(NSString*)password;
+(void)obtainAccessToken;//:(NSString*)code;

@end
