//
//  StripViewController.m
//  homePolice
//
//  Created by zhulh on 15/3/1.
//  Copyright (c) 2015年 yunzhifeng. All rights reserved.
//

#import "StripViewController.h"

@interface StripViewController ()
{
    NSDictionary *dictInfo;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceState;

@end

@implementation StripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)loadData
{
    dictInfo = [[DeviceListManager shareInstance] getDeviceInfoWithId:_uid];
    self.title = [dictInfo valueForKey:PARSER_DEVICE_NAME];
    BOOL status = [[dictInfo valueForKey:PARSER_IS_POWERON] boolValue];
    [_btnSwitch setImage:[UIImage imageNamed:status?@"deviceOn":@"deviceOff"] forState:UIControlStateNormal];
    [_lblDeviceState setText:(status?@"开启":@"关闭")];
    [_lblDeviceState setTextColor:(status?[UIColor getStripGreenColor]:[UIColor getStripGrayColor])];
}

- (IBAction)setSwitch:(id)sender
{
    [ProgressHUD show:@"正在操作"];
    NSString *token = [dictInfo valueForKey:PARSER_DEVICE_TOKEN];
    BOOL status = [[dictInfo valueForKey:PARSER_IS_POWERON] boolValue];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"api.reco4life.com/v/api.1.1"
                                                     customHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil]];
    MKNetworkOperation *op = [engine operationWithPath:@"item_switch"
                                                params:[NSDictionary dictionaryWithObjectsAndKeys:@"波波阳",@"user_name",
                                                        [NSNumber numberWithBool:!status], @"status", _uid, @"sn", nil]
                                            httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *responseDic = [completedOperation responseJSON];
        NSInteger result = [[responseDic valueForKey:@"result"] integerValue];
        if (result == 1) {
            [ProgressHUD showSuccess:[self getCodeTitle:result]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dictInfo];
            [dict setValue:[NSNumber numberWithBool:!status] forKey:PARSER_IS_POWERON];
            [[DeviceListManager shareInstance] updateDeviceWithInfo:dict];
            [self loadData];
        } else {
            [ProgressHUD showError:[self getCodeTitle:result]];
            [[DeviceListManager shareInstance] loadStripDeviceList];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DLog(@"%@", error);
    }];
    [engine enqueueOperation:op];
}

- (NSString *)getCodeTitle:(NSInteger)code
{
    NSString *title = nil;
    switch (code) {
        case -1:
            title = @"操作失败";
            break;
        case 1:
            title = @"操作成功";
            break;
        case 7:
            title = @"您没有设备操作权限";
            break;
        case 8:
            title = @"设备已断开连接";
            break;
        case 999:
            title = @"服务异常";
            break;
        default:
            break;
    }
    return title;
}

@end
