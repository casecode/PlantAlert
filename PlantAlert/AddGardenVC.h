//
//  AddGardenVC.h
//  PlantAlert
//
//  Created by Casey R White on 11/18/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySelectionDelegate.h"

@interface AddGardenVC : UIViewController

@property (weak, nonatomic) id <CitySelectionDelegate> citySelectionDelegate;

@end
