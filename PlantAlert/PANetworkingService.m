//
//  PANetworkingService.m
//  PlantAlert
//
//  Created by Casey R White on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "PANetworkingService.h"
#import "PAConstants.h"

static NSString * const kAPIDomain = @"http://127.0.0.1:3000";

// Paths
static NSString * const kAPIPathUsers = @"/api/users";
static NSString * const kAPIPathAddCity = @"/api/addcity";
static NSString * const kAPIPathDeleteCity = @"/api/deletecity";

// HTTP Constants
static NSString * const kHTTPHeaderForContentType = @"Content-type";
static NSString * const kHTTPValueForContentType = @"application/json";

// Keys for post data
static NSString * const kAPIKeyEmail = @"email";
static NSString * const kAPIKeyPassword = @"password";
static NSString * const kAPIKeyDeviceToken = @"deviceToken";
static NSString * const kAPIKeyJWTToken = @"jwt";
static NSString * const kAPIKeyCityName = @"cityName";

@implementation PANetworkingService

+ (id)sharedService {
    static PANetworkingService *_sharedService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [[PANetworkingService alloc] init];
    });
    
    return _sharedService;
}

- (void)signUpWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(NSString *, NSError *))completion {
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@%@", kAPIDomain, kAPIPathUsers];
    NSURL *url = [NSURL URLWithString:apiEndpoint];
    
    __block NSString *apiToken = nil;
    __block NSError *signUpError;
    
    NSData *postData = [self generatePostDataforUserWithEmail:email password:password error:&signUpError];
    
    if (signUpError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(apiToken, signUpError);
        });
    }
    else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:kHTTPValueForContentType forHTTPHeaderField:kHTTPHeaderForContentType];
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
                    
                    if (httpResponse.statusCode < 300) {
                        id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&signUpError];
                        
                        if (!signUpError) {
                            if ([jsonData isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *responseData = (NSDictionary *)jsonData;
                                apiToken = responseData[kAPIKeyJWTToken];
                                if (apiToken) {
                                    [[NSUserDefaults standardUserDefaults] setObject:apiToken forKey:kAPIKeyJWTToken];
                                }
                            }
                        }
                    }
                    else {
                        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%lu", httpResponse.statusCode]};
                        signUpError = [NSError errorWithDomain:kPADomain code:-1 userInfo:userInfo];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(apiToken, signUpError);
            });
        }];
        
        [task resume];
    }
}

- (NSData *)generatePostDataforUserWithEmail:(NSString *)email password:(NSString *)password error:(NSError *__autoreleasing *)error {
//    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
    NSDictionary *postData = @{kAPIKeyEmail         : email,
                               kAPIKeyPassword      : password,
                               kAPIKeyDeviceToken   : self.deviceToken};
    return [NSJSONSerialization dataWithJSONObject:postData options:0 error:&*error];
}

@end
