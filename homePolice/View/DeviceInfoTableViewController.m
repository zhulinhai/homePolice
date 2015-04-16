//
//  DeviceInfoTableViewController.m
//  HomePolice
//
//  Created by zhulh on 14-12-7.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import "DeviceInfoTableViewController.h"

@interface DeviceInfoTableViewController ()
{
    NSDictionary *deviceInfo;
}
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPwd;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDNS;
@property (weak, nonatomic) IBOutlet UILabel *lblSoftVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblSDStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblSpace;


@end

@implementation DeviceInfoTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    
    self.logoImageView.layer.cornerRadius = 3.0;
    self.logoImageView.layer.masksToBounds = YES;
    
    deviceInfo = [[DeviceListManager shareInstance] getDeviceInfoWithId:_uid];
    [self.logoImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_uid]];
    self.textFieldName.text = [deviceInfo valueForKey:PARSER_DEVICE_NAME];
    self.textFieldPwd.text = [deviceInfo valueForKey:PARSER_DEVICE_PWD];
    self.textFieldDNS.text = [deviceInfo valueForKey:PARSER_DDNS_USER];
    
    [self loadInfo];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadInfo
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/web/cgi-bin/hi3510/param.cgi?cmd=getserverinfo&cmd=getstreamnum", _hostName];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:[DeviceListManager getServerHost]
                                                     customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithURLString:urlString];
    [op setUsername:[deviceInfo valueForKey:PARSER_DEVICE_ACOUNT] password:[deviceInfo valueForKey:PARSER_DEVICE_PWD] basicAuth:YES];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *responseStr = [completedOperation responseString];
        NSString *str = [responseStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@";" withString:@""];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\r\n"]];
        NSString *freeSpace = nil;
        NSString *totalSpace = nil;
        for (NSString *info in array) {
            if ([info rangeOfString:PARSER_SD_STATUS].length > 0) {
                self.lblSDStatus.text = ([[info stringByAffterString:PARSER_SD_STATUS] isEqualToString:@"Ready"]?@"有卡":@"无卡");
            } else if ([info rangeOfString:PARSER_SOFT_VERSION].length > 0) {
                self.lblSoftVersion.text = [info stringByAffterString:PARSER_SOFT_VERSION];
            } else if ([info rangeOfString:PARSER_SD_FREESPACE].length > 0) {
                freeSpace = [NSString stringWithFormat:@"%.fG", [[info stringByAffterString:PARSER_SD_FREESPACE] integerValue]/(1024*1024.0)];
            } else if ([info rangeOfString:PARSER_SD_TOTALSPACE].length > 0) {
                totalSpace = [NSString stringWithFormat:@"%.fG", [[info stringByAffterString:PARSER_SD_TOTALSPACE] integerValue]/(1024*1024.0)];
            }
        }
        
        self.lblSpace.text = [NSString stringWithFormat:@"可用:%@ 总容量:%@", freeSpace, totalSpace];
        [self.tableView layoutSubviews];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    [engine enqueueOperation:op];
}

#pragma mark - Table view data source

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark user action
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
