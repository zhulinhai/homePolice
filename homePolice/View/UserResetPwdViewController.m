//
//  UserResetPwdViewController.m
//  ShopSmart
//
//  Created by ios001 on 14-7-22.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import "UserResetPwdViewController.h"
#import "UserFindPasswordViewController.h"
#import "UserController.h"

@interface UserResetPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAgainPwd;

@end

@implementation UserResetPwdViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textFieldNewPwd && range.location > 19) {
        return NO;
    } else if (textField == self.textFieldAgainPwd && range.location > 19) {
        return NO;
    }
    
    return YES;
}


- (IBAction)commit:(id)sender {
    NSString *newPwd = self.textFieldNewPwd.text;
    NSString *againPwd = self.textFieldAgainPwd.text;
    
    if ([FieldValidate checkPassWord:self.textFieldNewPwd] && [FieldValidate checkPassWord:self.textFieldAgainPwd]){
        if ([FieldValidate validateRePwd:newPwd reValue:againPwd]) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];

            
        } else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"两次密码输入不相同,请检查后重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            self.textFieldNewPwd.text = @"";
            self.textFieldAgainPwd.text = @"";
            [self.textFieldNewPwd becomeFirstResponder];
        }
    }
}


@end
