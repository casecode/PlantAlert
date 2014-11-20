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
#import <TSMessages/TSMessage.h>
#import <TSMessages/TSMessageView.h>
#import "PANetworkingService.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) PANetworkingService *apiService;

@end

@implementation LoginVC

- (PANetworkingService *)apiService {
    if (!_apiService) {
        _apiService = [PANetworkingService sharedService];
    }
    
    return _apiService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController) {
        self.title = @"Login";
    }
    
    //background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"plantAlertBg.jpg"]];
    

}

- (IBAction)LoginPressed:(id)sender {
    [self resignFirstResponder];
    
    NSString *errorMessage = nil;
    
    if (self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        errorMessage = @"You must provide your email and password";
        self.emailTextField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        self.passwordTextField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    }
    
    if (errorMessage) {
        [self showTSMessageWithTitle:errorMessage subtitle:nil];
    }
    else {
        [self.apiService loginWithEmail:self.emailTextField.text andPassword:self.passwordTextField.text completion:^(BOOL success, NSError *error) {
            if (success) {
                id gardenNavController = [self.storyboard instantiateViewControllerWithIdentifier:kReIDGardenNavController];
                [self presentViewController:gardenNavController animated:YES completion:nil];
            }
            else {
                [self showTSMessageWithTitle:@"Unable to find an account with the email and password provided." subtitle:nil];
                NSLog(@"ERROR: %@", [error localizedDescription]);
            }
        }];
    }
}

- (IBAction)SignUpPressed:(id)sender {
    SignUpVC *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:kReIDSignUpVC];
    [self.navigationController pushViewController:signUpVC animated:YES];
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
