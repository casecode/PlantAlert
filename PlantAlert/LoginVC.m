//
//  LoginVC.m
//  PlantAlert
//
//  Created by Shiquan Fu on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "LoginVC.h"
#import "PAConstants.h"
#import "SignUpVC.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController) {
        self.title = @"Login";
    }
    
    //background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plantAlertBg.jpg"]];
    

}

- (IBAction)LoginPressed:(id)sender {
    id gardenListVC = [self.storyboard instantiateViewControllerWithIdentifier:kReIDGardenListVC];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:gardenListVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)SignUpPressed:(id)sender {
    SignUpVC *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:kReIDSignUpVC];
    [self.navigationController pushViewController:signUpVC animated:YES];
}


@end
