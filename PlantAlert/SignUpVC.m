//
//  SignUpVC.m
//  PlantAlert
//
//  Created by Shiquan Fu on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "SignUpVC.h"

@interface SignUpVC ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController) {
        self.title = @"Sign Up";
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(navigateBack:)];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
}

- (IBAction)navigateBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpPressed:(id)sender {
}


@end
