//
//  HomeVC.m
//  PlantAlert
//
//  Created by Shiquan Fu on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "HomeVC.h"
#import "PAConstants.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id loginVC = [self.storyboard instantiateViewControllerWithIdentifier:kReIDLoginVC];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navController animated:YES completion:nil];
    
//    // Temporary segue to test AddGardenVC - To be removed
//    id addGardenVC = [self.storyboard instantiateViewControllerWithIdentifier:kReIDAddGardenVC];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addGardenVC];
//    [self presentViewController:navController animated:YES completion:nil];
    
}





@end
