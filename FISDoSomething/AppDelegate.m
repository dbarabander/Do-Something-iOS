//
//  AppDelegate.m
//  FISDoSomething
//
//  Created by DANIEL BARABANDER on 12/1/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "AppDelegate.h"
#import <SSKeychain/SSKeychain.h>
#import "FISViewController.h"
#import "FISLoginRegisterTableViewController.h"
#import "FISUser.h"
#import "FISDataStore.h"
#import <AWSCore.h>

@interface AppDelegate ()

@property (strong, nonatomic) FISDataStore* dataManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([SSKeychain accountsForService:@"doSomething"]) {
        FISViewController *scrollViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        self.window.rootViewController = scrollViewController;
    }
    else {
        FISLoginRegisterTableViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"loginVC"];
        self.window.rootViewController = loginVC;
    }

    self.dataManager = [FISDataStore sharedDataStore];
    
    //  [FISUser memberLogin:@"joeflat@mailinator.com" password:@"ironman123"];
    
    [self createDefaultAmazonServiceConfiguration];
    
    return YES;
}
-(void) createDefaultAmazonServiceConfiguration
{
    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider credentialsWithRegionType:AWSRegionUSEast1
                                                          
    //must update account id and identityPoolID- waiting for joe
                                                                                                        accountId:@"AKIAI6FWRIPOGSU6PGYQ"
                                                                                                   identityPoolId:@"2lN7gbaf6TvSRUaRgYOYL7fz+JOwn/kM2eu6CmUI"
                                                                                                    unauthRoleArn:nil
                                                                                                      authRoleArn:nil];
    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1
                                                                          credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString* urlString = [url absoluteString];
    NSArray* brokenDownURL = [urlString componentsSeparatedByString:@"="];
    
    self.dataManager.code = [brokenDownURL lastObject];
    NSLog(@"%%%%%%%% %@", self.dataManager.code);
    
    [FISUser obtainAccessToken];//:self.dataManager.code];
    
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://camera"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
