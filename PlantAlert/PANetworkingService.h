//
//  PANetworkingService.h
//  PlantAlert
//
//  Created by Casey R White on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PANetworkingService : NSObject

+ (id)sharedService;

- (void)signUpWithUserData:(NSDictionary *)userData completion:(void (^) (NSString *token, NSError *error))completion;

@end
