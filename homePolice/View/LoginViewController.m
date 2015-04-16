//
//  LoginViewController.m
//  HomePolice
//
//  Created by ios001 on 14-11-25.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnLogin.layer.cornerRadius = 3.0;
    self.btnLogin.layer.masksToBounds = YES;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.navigationController.topViewController isKindOfClass:[self class]]) {
        return NO;
    }
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
