//
//  AddDeviceViewController.m
//  HomePolice
//
//  Created by zhulh on 14-11-16.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "ZBarScanViewController.h"
#import "SearchDeviceViewController.h"
#import "DeviceListTableViewController.h"

@interface AddDeviceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.btnAdd.layer.cornerRadius = self.btnAdd.frame.size.height/2;
    self.btnAdd.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kShowSearchDeviceViewControllerIdentifer]) {
        SearchDeviceViewController *searchController = segue.destinationViewController;
        searchController.delegate = self;
    } else if ([segue.identifier isEqualToString:kShowScanViewControllerIdentifer]) {
        ZBarScanViewController *scanController = segue.destinationViewController;
        scanController.delegate = self;
    }
}

- (IBAction)addDevice:(id)sender {
    NSString *name = self.nameTextField.text;
    NSString *pwd = self.pwdTextField.text;
    NSString *user = self.userTextField.text;
    if ([name isEqualToString:@""] || [pwd isEqualToString:@""] || [user isEqualToString:@""]) {
        return;
    }
    
    NSString *uid = [self.deviceInfo valueForKey:PARSER_DEVICE_UID];
    if (!uid) {
        uid = [[NSDate date] description];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.deviceInfo];
    [dict setValue:name forKey:PARSER_DEVICE_NAME];
    [dict setValue:pwd  forKey:PARSER_DEVICE_PWD];
    [dict setValue:user forKey:PARSER_DDNS_USER];
    [dict setValue:uid  forKey:PARSER_DEVICE_UID];
    [dict setValue:[NSNumber numberWithInt:t_DeviceType_IPC] forKey:PARSER_DEVICE_TYPE];
    [dict setValue:@"admin" forKey:PARSER_DEVICE_ACOUNT];
    if (![dict valueForKey:PARSER_RTSP_PORT]) {
        [dict setValue:@(554) forKey:PARSER_RTSP_PORT];
        [dict setValue:@(12) forKey:PARSER_CAM_CHANNEL2];
        [dict setValue:@(81) forKey:PARSER_HTTP_PORT];
    }
    
    [[DeviceListManager shareInstance] addDeviceWithInfo:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
