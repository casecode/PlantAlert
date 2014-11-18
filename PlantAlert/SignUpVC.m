//
//  SignUpVC.m
//  PlantAlert
//
//  Created by Shiquan Fu on 11/17/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

#import "SignUpVC.h"
#import "PANetworkingService.h"

@interface SignUpVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

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
    
    self.phoneNumberTextField.delegate = self;
}

- (IBAction)navigateBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpPressed:(id)sender {
    
    NSLog(@"len %lu, num: %@", self.phoneNumberTextField.text.length, self.phoneNumberTextField.text);

    NSDictionary *userData = @{@"email"     : _emailTextField.text,
                               @"password"  : _passwordTextField.text};
    [[self apiService] signUpWithUserData:userData completion:^(NSString *token, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else {
            NSLog(@"Token: %@", token);
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger length = [self getLength:textField.text];
    
    if (length == 10) {
        if (range.length == 0) {
            return NO;
        }
    }
    
    if (length == 3) {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0) {
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
    }
    else if (length == 6) {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) %@-", [num substringToIndex:3], [num substringFromIndex:3]];
        if (range.length > 0) {
            textField.text = [NSString stringWithFormat:@"(%@) %@", [num substringToIndex:3], [num substringFromIndex:3]];
        }
    }
    
    return YES;
}

- (NSString *)formatNumber:(NSString *)mobileNumber {
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    NSUInteger length = [mobileNumber length];
    if (length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
    }
    
    return mobileNumber;
}


- (NSUInteger)getLength:(NSString *)mobileNumber {
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    return [mobileNumber length];
}

@end
