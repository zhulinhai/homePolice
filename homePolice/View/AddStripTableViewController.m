//
//  AddStripTableViewController.m
//  homePolice
//
//  Created by zhulh on 15/2/28.
//  Copyright (c) 2015年 yunzhifeng. All rights reserved.
//

#import "AddStripTableViewController.h"

@interface AddStripTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation AddStripTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.btnAdd.layer.cornerRadius = 3.0;
    self.btnAdd.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark user action
- (IBAction)add:(id)sender {
    NSString *name = self.nameTextField.text;
    NSString *pwd = self.pwdTextField.text;
    NSString *user = self.userTextField.text;
    if ([name isEqualToString:@""] || [pwd isEqualToString:@""] || [user isEqualToString:@""]) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:name forKey:PARSER_DEVICE_NAME];
    [dict setValue:pwd  forKey:PARSER_DEVICE_PWD];
    [dict setValue:user  forKey:PARSER_DEVICE_UID];
    [dict setValue:[NSNumber numberWithInt:t_DeviceType_STRIP] forKey:PARSER_DEVICE_TYPE];
    [[DeviceListManager shareInstance] addDeviceWithInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
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
