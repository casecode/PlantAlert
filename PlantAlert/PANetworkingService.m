//
//  PANetworkingService.m
//  PlantAlert
//
//  Created by Casey R White on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "PANetworkingService.h"

static NSString * const kAPIDomain = @"http://127.0.0.1:3000/test";

@implementation PANetworkingService

+ (id)sharedService {
    static PANetworkingService *_sharedService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[PANetworkingService alloc] init];
    });
    
    return _sharedService;
}

- (void)signUpWithUserData:(NSDictionary *)userData completion:(void (^)(NSString *, NSError *))completion {
    
    NSURL *url = [NSURL URLWithString:kAPIDomain];
    
    __block NSString *token = nil;
    __block NSError *signUpError;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:userData options:0 error:&signUpError];

    if (!signUpError) {

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:postData];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                signUpError = error;
                NSLog(@"Error: %@", [error localizedDescription]);
            }
            else {
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    
                    NSLog(@"Response: %lu", httpResponse.statusCode);
                    token = @"someToken";
                }
            }
            
            completion(token, signUpError);
        }];
        
        [task resume];
    }
}

@end
