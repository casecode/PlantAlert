//
//  SignUpVC.m
//  PlantAlert
//
//  Created by Shiquan Fu on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "SignUpVC.h"
#import "PANetworkingService.h"
#import "PAConstants.h"
#import <TSMessages/TSMessage.h>
#import <TSMessages/TSMessageView.h>

@interface SignUpVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (strong, nonatomic) PANetworkingService *apiService;

@end

@implementation SignUpVC

- (PANetworkingService *)apiService {
    if (!_apiService) {
        _apiService = [PANetworkingService sharedService];
    }
    
    return _apiService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController) {
        self.title = @"Sign Up";
        
     
        UIImage *image = [UIImage imageNamed:@"leftGreen"];
        CGRect frame = CGRectMake(0, 0, 22, 22);
        UIButton* button = [[UIButton alloc] initWithFrame:frame];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(navigateBack:) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [self.navigationItem setLeftBarButtonItem:backButton];
    }
}

- (IBAction)navigateBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpPressed:(id)sender {
    [self resignFirstResponder];
    
    NSString *errorMessage = nil;
    
    if (self.emailTextField.text.length == 0) {
        errorMessage = @"You must provide an email address";
        self.emailTextField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    }
    
    else if (self.passwordTextField.text.length < 8) {
        errorMessage = @"Your password must be at least 8 characters long";
        self.passwordTextField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    }
    else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        errorMessage = @"Password and password confirmation must match";
        self.passwordTextField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        self.confirmPasswordTextField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    }
    
    if (errorMessage) {
        [self showTSMessageWithTitle:errorMessage subtitle:nil];
    }
    else {
        [self.apiService signUpWithEmail:self.emailTextField.text andPassword:self.passwordTextField.text completion:^(NSString *token, NSError *error) {
            if (token) {
                id gardenNavController = [self.storyboard instantiateViewControllerWithIdentifier:kReIDGardenNavController];
                [self presentViewController:gardenNavController animated:YES completion:nil];
            }
            else {
                [self showTSMessageWithTitle:@"Unable to create new account" subtitle:nil];
            }
        }];
    }
}

- (void)showTSMessageWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [TSMessage showNotificationInViewController:self
                                          title:title
                                       subtitle:subtitle
                                          image:nil
                                           type:TSMessageNotificationTypeMessage
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:@"Dismiss"
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

@end
