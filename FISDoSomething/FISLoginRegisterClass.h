//
//  FISLoginRegisterClass.h
//  FISDoSomething
//
//  Created by Blake Shetter on 12/8/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISLoginRegisterClass : NSObject

@property(nonatomic) BOOL failedLoginRegister;
@property(strong,nonatomic) NSString *failedLoginRegisterReason;
@property(strong,nonatomic) NSString *sessionSaveString;
@property(strong,nonatomic) NSString *sessionToken;

-(void)attemptLoginWithUsername:(NSString *)username password:(NSString *)password withCompletionHandler:(void (^)())completionHandler;
-(void)attemptRegistrationWithUsername:(NSString *)username password:(NSString *)password birthDate:(NSDate *)birthDate name:(NSString *)name withCompletionHandler:(void (^)())completionHandler;
@end
