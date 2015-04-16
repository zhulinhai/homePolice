//
//  UserFindPasswordViewController.m
//  ShopSmart
//
//  Created by ios001 on 14-6-27.
//  Copyright (c) 2014年 zh. All rights reserved.
//

#import "UserFindPasswordViewController.h"
#import "UserResetPwdViewController.h"

#define kShowUserPassWordViewControllerIdentifer @"showUserPassWordViewControllerIdentifer"

@interface UserFindPasswordViewController ()
{
    int timeOut;
    BOOL isRequest;
}
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneCode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCode;

@end

@implementation UserFindPasswordViewController

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
    self.textFieldPhoneNum.delegate = self;
    self.textFieldCode.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kShowUserPassWordViewControllerIdentifer]) {
    }
}

#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textFieldCode && range.location > 5) {
        return NO;
    } else if (textField == self.textFieldPhoneNum && range.location > 10) {
        return NO;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark uialertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
