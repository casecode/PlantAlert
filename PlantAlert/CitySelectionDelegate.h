//
//  CitySelectionDelegate.h
//  PlantAlert
//
//  Created by Casey R White on 11/19/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@protocol CitySelectionDelegate <NSObject>

- (void)citySelected:(City *)city;

@end