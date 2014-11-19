//
//  SignUpVC.m
//  PlantAlert
//
//  Created by Shiquan Fu on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "SignUpVC.h"
#import "PANetworkingService.h"
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
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(navigateBack:)];
        self.navigationItem.leftBarButtonItem = backButton;
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
        [TSMessage showNotificationInViewController:self
                                              title:errorMessage
                                           subtitle:nil
                                              image:nil
                                               type:TSMessageNotificationTypeMessage
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:nil
                                        buttonTitle:@"OK"
                                     buttonCallback:^{
                                         NSLog(@"User tapped the button");
                                     }
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
    }
    else {
        NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDictionary *userData = @{@"email"     : _emailTextField.text,
                                   @"password"  : _passwordTextField.text,
                                   @"deviceID"  : deviceID};
        [[self apiService] signUpWithUserData:userData completion:^(NSString *token, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
            else {
                NSLog(@"Token: %@", token);
            }
        }];
    }
}

@end
