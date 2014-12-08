//
//  FISLoginRegisterClass.m
//  FISDoSomething
//
//  Created by Blake Shetter on 12/8/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISLoginRegisterClass.h"
#import "FISDataStore.h"
#import "FISDoSomethingAPI.h"
#import <SSKeychain.h>
@implementation FISLoginRegisterClass


-(void)attemptLoginWithUsername:(NSString *)username password:(NSString *)password withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary *parameters = @{@"username": @"2237742",
                                 @"password": password
                                 };
    
    
    [FISDoSomethingAPI postLoginToAPI:parameters withCompletionHandler:^(id responseObject) {
        if([responseObject isKindOfClass:[NSError class]]){
            self.failedLoginRegisterReason=@"Login Failed!";
            self.failedLoginRegister=YES;
        }
        else{
            self.sessionSaveString=[NSString stringWithFormat:@"%@=%@",responseObject[@"session_name"],responseObject[@"sessid"]];
            self.sessionToken=responseObject[@"token"];
            
            [SSKeychain setPassword:password forService:@"doSomething" account:username];

            
            [[NSUserDefaults standardUserDefaults] setObject:self.sessionSaveString forKey:@"sessionString"];
            [[NSUserDefaults standardUserDefaults] setObject:self.sessionToken forKey:@"sessionToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        completionHandler();
    }];
    
    
    
}


-(void)attemptRegistrationWithUsername:(NSString *)username password:(NSString *)password birthDate:(NSDate *)birthDate name:(NSString *)name withCompletionHandler:(void (^)())completionHandler{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-DD"];
    NSString *finalBirthDate=[dateFormat stringFromDate:birthDate];

    NSDictionary *parameters = @{@"email": username,
                                 @"password": password,
                                 @"birthdate": finalBirthDate,
                                 @"first_name": name,
                                 @"user_registration_source": @"Do something IOS APP"
                                 };
    
    
    [FISDoSomethingAPI postRegistrationToAPI:parameters withCompletionHandler:^(id responseObject) {
        if([responseObject isKindOfClass:[NSError class]]){
            self.failedLoginRegisterReason=@"Registration Failed!";
            self.failedLoginRegister=YES;
        }
        else{
//            self.sessionSaveString=[NSString stringWithFormat:@"%@=%@",responseObject[@"session_name"],responseObject[@"sessid"]];
//            self.sessionToken=responseObject[@"token"];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:self.sessionSaveString forKey:@"sessionString"];
//            [[NSUserDefaults standardUserDefaults] setObject:self.sessionToken forKey:@"sessionToken"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        completionHandler();
    }];
    
    
    
}


@end
