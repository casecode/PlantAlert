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
static NSString * const kAPIPathAddCity = @"/v1/api/addcity";
static NSString * const kAPIPathDeleteCity = @"/v1/api/deletecity";

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

- (NSString *)deviceToken {
    return _deviceToken ? _deviceToken : @"testDeviceToken";
}

#pragma mark - Authenticate Users

- (void)signUpWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL, NSError *))completion {
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@%@", kAPIDomain, kAPIPathUsers];
    NSURL *url = [NSURL URLWithString:apiEndpoint];
    NSError *jsonError = nil;
    NSData *userData = [self generatePostDataforUserWithEmail:email password:password error:&jsonError];
    
    if (jsonError) {
        completion(NO, jsonError);
    }
    else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:kHTTPValueForContentType forHTTPHeaderField:kHTTPHeaderForContentType];
        [request setHTTPBody:userData];
        
        [self authenticateUserWithRequest:request callback:completion];
    }
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^)(BOOL, NSError *))completion {
    NSString *params = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@", kAPIKeyEmail, email, kAPIKeyPassword, password, kAPIKeyDeviceToken, self.deviceToken];
    NSString *apiEndpoint = [NSString stringWithFormat:@"%@%@%@", kAPIDomain, kAPIPathUsers, params];
    NSURL *url = [NSURL URLWithString:apiEndpoint];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self authenticateUserWithRequest:request callback:completion];
}

#pragma mark Private

- (void)authenticateUserWithRequest:(NSURLRequest *)request callback:(void (^)(BOOL, NSError *))callback {
    
    __block BOOL success = NO;
    __block NSError *authError;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error) {
            authError = error;
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

                if (httpResponse.statusCode < 300) {
                    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&authError];

                    if (!authError) {
                        
                        if ([jsonData isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *responseData = (NSDictionary *)jsonData;
                            NSString *apiToken = responseData[kAPIKeyJWTToken];
                            if (apiToken) {
                                success = YES;
                                [[NSUserDefaults standardUserDefaults] setObject:apiToken forKey:kAPIKeyJWTToken];
                            }
                        }
                    }
                }
                else {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%lu", httpResponse.statusCode]};
                    authError = [NSError errorWithDomain:kPADomain code:-1 userInfo:userInfo];
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(success, authError);
        });
    }];
    
    [task resume];
}

- (NSData *)generatePostDataforUserWithEmail:(NSString *)email password:(NSString *)password error:(NSError *__autoreleasing *)error {
    NSDictionary *userData = @{kAPIKeyEmail         : email,
                               kAPIKeyPassword      : password,
                               kAPIKeyDeviceToken   : self.deviceToken};
    return [NSJSONSerialization dataWithJSONObject:userData options:0 error:&*error];
}

#pragma mark - Cities

- (void)addCity:(City *)city completion:(void (^)(BOOL, NSError *))completion {
    NSString *url = [NSString stringWithFormat:@"%@%@", kAPIDomain, kAPIPathAddCity];
    [self requestForCity:city withURL:url callback:completion];
}

- (void)deleteCity:(City *)city completion:(void (^)(BOOL, NSError *))completion {
    NSString *url = [NSString stringWithFormat:@"%@%@", kAPIDomain, kAPIPathDeleteCity];
    [self requestForCity:city withURL:url callback:completion];
}

- (void)requestForCity:(City *)city withURL:(NSString *)urlString callback:(void (^)(BOOL, NSError *))callback {

    __block BOOL success = NO;
    __block NSError *cityError;
    
    NSData *cityData = [self generatePostDataForCity:city error:&cityError];
    
    if (cityError) {
        callback(success, cityError);
    }
    else {
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:kHTTPValueForContentType forHTTPHeaderField:kHTTPHeaderForContentType];
        [request setHTTPBody:cityData];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                cityError = error;
                NSLog(@"Error: %@", [error localizedDescription]);
            }
            else {
                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                    
                    if (httpResponse.statusCode < 300) {
                        success = YES;
                    }
                    else {
                        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"%lu", httpResponse.statusCode]};
                        cityError = [NSError errorWithDomain:kPADomain code:-1 userInfo:userInfo];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(success, cityError);
            });
        }];
        
        [task resume];
    }
}


#pragma mark Private

-(NSData *)generatePostDataForCity:(City *)city error:(NSError *__autoreleasing *)error {
    NSDictionary *cityData = @{kAPIKeyCityName   : city.name,
                               kAPIKeyJWTToken   : [self retrieveJWTToken]};
    return [NSJSONSerialization dataWithJSONObject:cityData options:0 error:&*error];
}

- (NSString *)retrieveJWTToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kAPIKeyJWTToken];
    return token ? token : @"testJWTToken";
}

@end
