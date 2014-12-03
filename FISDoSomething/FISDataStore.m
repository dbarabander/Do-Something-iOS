//
//  FISDataStore.m
//  FISDoSomething
//
//  Created by Levan Toturgul on 11/26/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISDataStore.h"
#import "FISDoSomethingAPI.h"

@implementation FISDataStore


+ (instancetype)sharedDataStore {
    static FISDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISDataStore alloc] init];
    });
    return _sharedDataStore;
}
-(instancetype)init{
    self=[super init];
    if(self){
        
        _campaigns=[[NSMutableArray alloc] init];

        
    }
    return self;
}
//  Basic Campaign Info
- (void)getAllActiveCampaignsWithCompletionHandler:(void (^)())completionHandler
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Campaign"];
    NSArray *fetchCampaigns = [self.context executeFetchRequest:fetchRequest error:nil];
    if([fetchCampaigns count]>=1){
        [self.campaigns addObjectsFromArray:fetchCampaigns];
        NSSortDescriptor* sortByID = [NSSortDescriptor sortDescriptorWithKey:@"nid" ascending:NO];
        [self.campaigns sortUsingDescriptors:[NSArray arrayWithObject:sortByID]];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler();
        }];
    }
    else{
        [FISDoSomethingAPI retrieveAllActiveCampaignsWithCompletionHandler:^(NSArray *campaigns) {

                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            completionHandler();
                        }];
            
        }];
    }
}


// Advanced Campaign Info
- (void)getMoreInfoOnCampaign:(Campaign *)campaign
        withCompletionHandler:(void (^)())completionHandler
{
    [FISDoSomethingAPI retrieveMoreInfoOnCampaign:campaign withCompletionHandler:^{
        completionHandler();
    }];
    
}

// Download images for campaign
- (void)getImagesForCampaign:(Campaign *)campaign
       withCompletionHandler:(void (^)())completionHandler
{
    [FISDoSomethingAPI retrieveImagesForCampaign:campaign withCompletionHandler:^{
        completionHandler();
    }];
}

@synthesize context = _context;

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.context;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (NSManagedObjectContext *)context
{
    if (_context != nil) {
        return _context;
    }
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FISDoSomething.sqlite"];
    
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:coordinator];
    }
    return _context;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
