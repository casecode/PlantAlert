//
//  PANetworkingService.h
//  PlantAlert
//
//  Created by Casey R White on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PANetworkingService : NSObject

@property (nonatomic, copy) NSString *deviceToken;

+ (id)sharedService;

- (void)signUpWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^) (BOOL success, NSError *error))completion;

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password completion:(void (^) (BOOL success, NSError *error))completion;

@end
