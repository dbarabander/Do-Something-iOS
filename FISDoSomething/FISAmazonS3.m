//
//  FISAmazonS3.m
//  FISDoSomething
//
//  Created by Karim Mourra on 12/8/14.
//  Copyright (c) 2014 Flatiron iOS 003. All rights reserved.
//

#import "FISAmazonS3.h"
#import <Reachability/Reachability.h>
#import <AWSCore.h>
#import <S3.h>

@implementation FISAmazonS3

+(void)uploadToAmazon:(NSURL*)pictureURL
{
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = @"flatiron-school-students";
    uploadRequest.key = @"picture.jpg";
    uploadRequest.body = pictureURL;
    
    [[transferManager upload:uploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor]
                                                       withBlock:^id(BFTask *task) {
                                                           if (task.error) {
                                                               if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                                                                   switch (task.error.code) {
                                                                       case AWSS3TransferManagerErrorCancelled:
                                                                       case AWSS3TransferManagerErrorPaused:
                                                                           break;
                                                                           
                                                                       default:
                                                                           NSLog(@"Error: %@", task.error);
                                                                           break;
                                                                   }
                                                               } else {
                                                                   // Unknown error.
                                                                   NSLog(@"Error: %@", task.error);
                                                               }
                                                           }
                                                           
                                                           if (task.result) {
                                                               AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
                                                               NSLog(@"###########UPLOADED!!!!!");
                                                               // The file uploaded successfully.
                                                           }
                                                           return nil;
                                                       }];
}


@end
