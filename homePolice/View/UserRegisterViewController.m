//
//  UserRegisterViewController.m
//  ShopSmart
//
//  Created by ios001 on 14-6-27.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "UserController.h"

@interface UserRegisterViewController ()
{
    BOOL isAccess;
    int timeOut;
}

@property (weak, nonatomic) IBOutlet UITextField *textFiledPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneCode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassWord;

@property (weak, nonatomic) IBOutlet UIButton *btnPhoneCode;
@property (weak, nonatomic) IBOutlet UIImageView *imageCheck;

@end

@implementation UserRegisterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnPhoneCode.layer.cornerRadius = 3.0;
    self.btnPhoneCode.layer.masksToBounds = YES;
    isAccess = YES;
    
    self.textFiledPhoneNum.delegate = self;
    self.textFieldPhoneCode.delegate = self;
    self.textFieldPassWord.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark register
- (IBAction)getPhoneCode:(id)sender {
    
}

- (IBAction)userRegister:(id)sender {
    
}

- (IBAction)access:(id)sender {
}

#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textFiledPhoneNum && range.location > 10) {
        return NO;
    } else if (textField == self.textFieldPhoneCode && range.location > 5) {
        return NO;
    } else if (textField == self.textFieldPassWord && range.location > 19) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
